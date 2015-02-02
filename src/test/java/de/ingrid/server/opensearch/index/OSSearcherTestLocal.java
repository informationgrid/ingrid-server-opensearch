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
package de.ingrid.server.opensearch.index;

import de.ingrid.iplug.PlugServer;
import de.ingrid.utils.query.IngridQuery;
import de.ingrid.utils.query.TermQuery;
import junit.framework.TestCase;

public class OSSearcherTestLocal extends TestCase {

    public final void testSearchIngridQueryIntInt() {
        OSSearcher searcher = new OSSearcher();
        IngridQuery query = new IngridQuery(false, false, 0, "test");
        TermQuery termQuery = new TermQuery(false, false, "Test");
        query.addTerm(termQuery);
        try {
            searcher.configure(PlugServer.getPlugDescription("conf/plugdescription.xml"));
            searcher.searchAndDetails(query, 0, 10);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        fail("Not yet implemented"); // TODO
    }

}
