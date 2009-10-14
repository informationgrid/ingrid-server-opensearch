package de.ingrid.server.opensearch.mapping;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.dom4j.Document;

import de.ingrid.opensearch.servlet.OpensearchServlet;
import de.ingrid.opensearch.util.RequestWrapper;
import de.ingrid.utils.IngridHits;

public class IgcToXmlMapper implements OpensearchMapper {

	@Override
	public Document mapToXML(IngridHits hits, HashMap<String, Object> parameter) {
		Document doc = null;
        try {
        	OpensearchServlet osServlet = new OpensearchServlet();
			doc = osServlet.createXMLDocumentFromIngrid(
					(HttpServletRequest) parameter.get(HTTP_SERVLET_REQUEST),
					(RequestWrapper) parameter.get(REQUEST_WRAPPER),
					hits);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return doc;
	}

}
