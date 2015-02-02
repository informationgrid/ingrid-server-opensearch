/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 - 2015 wemove digital solutions GmbH
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

import java.io.UnsupportedEncodingException;
import java.util.HashMap;

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
					(RequestWrapper) parameter.get(REQUEST_WRAPPER),
					hits,
					true);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return doc;
	}

}
