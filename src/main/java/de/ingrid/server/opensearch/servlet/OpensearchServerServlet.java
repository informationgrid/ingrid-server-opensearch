/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 wemove digital solutions GmbH
 * ==================================================
 * Licensed under the EUPL, Version 1.1 or – as soon they will be
 * approved by the European Commission - subsequent versions of the
 * EUPL (the "Licence");
 * 
 * You may not use this work except in compliance with the Licence.
 * You may obtain a copy of the Licence at:
 * 
 * http://ec.europa.eu/idabc/eupl5
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the Licence is distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the Licence for the specific language governing permissions and
 * limitations under the Licence.
 * **************************************************#
 */
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

    /**
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doGet(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, IOException {
    	IngridHits hits = null;
        long overallStartTime = 0;

        if (log.isDebugEnabled()) {
            overallStartTime = System.currentTimeMillis();
        }

        final RequestWrapper reqWrapper = new RequestWrapper(request);

        // set content Type
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml");
        response.setCharacterEncoding("UTF-8");

        OSSearcher osSearcher = OSSearcher.getInstance();

        if (osSearcher == null) {
        	// redirect or show error page or empty result
        	final PrintWriter pout = response.getWriter();
            pout.write("Error: no index file found");
        	return;
        }

        int page = reqWrapper.getRequestedPage();
        final int hitsPerPage = reqWrapper.getHitsPerPage();
        if (page <= 0) {
            page = 1;
        }
        final int startHit = (page-1) *  hitsPerPage;

        try {
			// Hits also need Details which has title and summary!!!
			hits = osSearcher.searchAndDetails(reqWrapper.getQuery(), startHit, reqWrapper.getHitsPerPage());
		} catch (final Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // transform hits into target format
        final OpensearchMapper mapper = (new SpringUtil("spring/spring.xml")).getBean("mapper", OpensearchMapper.class);
        final HashMap<String, Object> parameter = new HashMap<String, Object>();
        parameter.put(OpensearchMapper.REQUEST_WRAPPER, reqWrapper);

        final Document doc = mapper.mapToXML(hits, parameter);

        // write target format
        final PrintWriter pout = response.getWriter();

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
    @Override
    protected void doPost(final HttpServletRequest request, final HttpServletResponse response) throws ServletException,
            IOException {
        doGet(request, response);
    }

}
