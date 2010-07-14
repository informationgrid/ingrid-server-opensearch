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
