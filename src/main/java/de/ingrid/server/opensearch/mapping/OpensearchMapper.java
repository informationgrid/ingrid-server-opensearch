/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 - 2018 wemove digital solutions GmbH
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
package de.ingrid.server.opensearch.mapping;

import java.util.HashMap;

import org.dom4j.Document;

import de.ingrid.utils.IngridHits;

public interface OpensearchMapper {
	
	public static final String REQUEST_WRAPPER 		= "RequestWrapper";
	public static final String HTTP_SERVLET_REQUEST	= "HttpServletRequest";
	
	public Document mapToXML(IngridHits hits, HashMap<String, Object> parameter);
}
