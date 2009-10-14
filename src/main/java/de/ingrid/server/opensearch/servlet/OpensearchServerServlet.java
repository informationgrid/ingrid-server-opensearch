/*
 * Copyright (c) 2006 wemove digital solutions. All rights reserved.
 */
package de.ingrid.server.opensearch.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;

import de.ingrid.iplug.PlugServer;
import de.ingrid.opensearch.util.RequestWrapper;
import de.ingrid.server.opensearch.index.OSSearcher;
import de.ingrid.server.opensearch.mapping.OpensearchMapper;
import de.ingrid.utils.IngridHits;
import de.ingrid.utils.tool.SpringUtil;

/**
 * Servlet handles OpenSearch queries.
 * 
 * @author joachim@wemove.com
 */
public class OpensearchServerServlet extends HttpServlet {

    private static final long serialVersionUID 	= 597250457306006899L;
    
    private final static Log log = LogFactory.getLog(OpensearchServerServlet.class);
    
    private OSSearcher osSearcher = null;

    /**
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	IngridHits hits = null;
        long overallStartTime = 0;
        
        if (log.isDebugEnabled()) {
            overallStartTime = System.currentTimeMillis();
        }        

        RequestWrapper reqWrapper = new RequestWrapper(request);

        OSSearcher searcher = getSearcher();//new OSSearcher();
        int page = reqWrapper.getRequestedPage();
        int hitsPerPage = reqWrapper.getHitsPerPage();
        if (page <= 0)
            page = 1;
        int startHit = (page-1) *  hitsPerPage;
        
        try {
			// Hits also need Details which has title and summary!!!
			hits = searcher.searchAndDetails(reqWrapper.getQuery(), startHit, reqWrapper.getHitsPerPage());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// transform IngridHit to XML
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml");
        
        // transform hits into target format
        OpensearchMapper mapper = (new SpringUtil("spring/spring.xml")).getBean("mapper", OpensearchMapper.class);
        //OpensearchMapper mapper = new IgcToXmlMapper();
        HashMap<String, Object> parameter = new HashMap<String, Object>();
        parameter.put(OpensearchMapper.REQUEST_WRAPPER, reqWrapper);
        parameter.put(OpensearchMapper.HTTP_SERVLET_REQUEST, request);
        
        Document doc = mapper.mapToXML(hits, parameter);
        
        // write target format
        PrintWriter pout = response.getWriter();

        pout.write(doc.asXML());
        pout.close();
        request.getInputStream().close();
        doc.clearContent();

        if (log.isDebugEnabled()) {
            log.debug("Time for complete search: " + (System.currentTimeMillis() - overallStartTime) + " ms");
        }
    }


    /**
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        doGet(request, response);
    }
    
    private OSSearcher getSearcher() {
    	try {
    		if (osSearcher == null) {
	    		osSearcher = new OSSearcher();
	    		// get plugDescription info
	    		//osSearcher.configure(PlugServer.getPlugDescription());
	    		osSearcher.configure(PlugServer.getPlugDescription("src/test/resources/plugdescription.xml"));
    		}
    	} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return osSearcher; 
    }
}
