package de.ingrid.server.opensearch.mapping;

import java.util.HashMap;

import org.dom4j.Document;

import de.ingrid.utils.IngridHits;

public interface OpensearchMapper {
	
	public static final String REQUEST_WRAPPER 		= "RequestWrapper";
	public static final String HTTP_SERVLET_REQUEST	= "HttpServletRequest";
	
	public Document mapToXML(IngridHits hits, HashMap<String, Object> parameter);
}
