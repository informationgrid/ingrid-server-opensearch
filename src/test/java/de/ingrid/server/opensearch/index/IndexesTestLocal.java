/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 - 2017 wemove digital solutions GmbH
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

import java.io.File;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import junit.framework.TestCase;
import de.ingrid.iplug.PlugServer;
import de.ingrid.iplug.dsc.index.AbstractSearcher;
import de.ingrid.iplug.dsc.index.DatabaseConnection;
import de.ingrid.iplug.dsc.schema.Construct;
import de.ingrid.iplug.dsc.schema.DBSchemaController;
import de.ingrid.iplug.dsc.schema.RecordReader;
import de.ingrid.iplug.dsc.schema.Relation;
import de.ingrid.iplug.dsc.schema.Table;
import de.ingrid.utils.PlugDescription;
import de.ingrid.utils.dsc.Column;
import de.ingrid.utils.xml.XMLSerializer;

public class IndexesTestLocal extends TestCase {
    private Connection fConnection;

    protected void setUp() throws Exception {
        Class.forName("org.hsqldb.jdbcDriver");
        this.fConnection = DriverManager.getConnection("jdbc:hsqldb:mem:testdb", "sa", "");
        Statement statement = this.fConnection.createStatement();
        InputStream resourceAsStream = DBSchemaController.class.getResourceAsStream("/sql2.txt");
        statement.addBatch(XMLSerializer.getContents(resourceAsStream));
        statement.executeBatch();

    }

    protected void tearDown() throws Exception {
        Statement statement = this.fConnection.createStatement();
        statement.execute("SHUTDOWN");
        //DBSchemaControllerTest.removeDB("testdb");
    }

    /**
     * @throws Exception
     */
    public void testIndexer() throws Exception {
/*        File file = new File("./testIndex");
        RecordReader recordReader = new RecordReader(getSimpleConstruct(), this.fConnection, null, "jdbc:hsqldb:mem:testdb", "sa", "");
        Indexer indexer = new Indexer(file, recordReader);
        indexer.index();
        indexer.close();*/
        /*DSCSearcher searcher = new DSCSearcher(new File(file, "index"), "myProviderId");
        IngridHits hits = searcher.search(QueryStringParser.parse("av"), 0, 100);
        assertNotNull(hits);
        assertTrue(hits.getHits().length > 0);*/
    }
    
    public void testIndexerWithPD() throws Exception {
    	File file = new File("./testIndex");
    	
    	PlugDescription plugDescription = PlugServer.getPlugDescription("./src/test/resources/plugdescription.xml");
        Construct construct = AbstractSearcher.getConstruct(plugDescription);
        
        DatabaseConnection dsConnection = (DatabaseConnection) plugDescription.getConnection();
        String url = dsConnection.getConnectionURL();
        String user = dsConnection.getUser();
        String password = dsConnection.getPassword();
        Connection connection = DriverManager.getConnection(url, user, password);
        
        RecordReader recordReader = new RecordReader(construct, connection, dsConnection.getSchema(), url, user, password );
        de.ingrid.iplug.dsc.index.Indexer indexer = new de.ingrid.iplug.dsc.index.Indexer(file, recordReader);
        indexer.index();
        indexer.close();
    }
    
    public static Construct getSimpleConstruct() {
        Table item = new Table("item", null);
        Table invoice = new Table("invoice", null);
        Table customer = new Table("CUSTOMER", null);

        item.addColumn(new Column("item", "invoiceid", Column.TEXT, true));
        item.addColumn(new Column("item", "item", Column.TEXT, true));
        item.addColumn(new Column("item", "quantity", Column.TEXT, true));
        item.addColumn(new Column("item", "cost", Column.TEXT, true));

        invoice.addColumn(new Column("invoice", "id", Column.TEXT, true));
        invoice.addColumn(new Column("invoice", "customerid", Column.TEXT, true));
        invoice.addColumn(new Column("invoice", "total", Column.TEXT, true));
        invoice.addColumn(new Column("invoice", "id", Column.TEXT, true));

        customer.addColumn(new Column("CUSTOMER", "id", Column.TEXT, true));
        customer.addColumn(new Column("CUSTOMER", "firstname", Column.TEXT, true));
        customer.addColumn(new Column("CUSTOMER", "lastname", Column.TEXT, true));
        customer.addColumn(new Column("CUSTOMER", "street", Column.TEXT, true));
        customer.addColumn(new Column("CUSTOMER", "city", Column.TEXT, true));

        Relation relation1 = new Relation(invoice.getColumnByName("id"), item, item.getColumnByName("invoiceid"),
                Relation.ONE_TO_MANY);
        invoice.addRelation(relation1);

        Relation relation2 = new Relation(invoice.getColumnByName("customerid"), customer, customer
                .getColumnByName("id"), Relation.ONE_TO_ONE);
        invoice.addRelation(relation2);

        Column key = new Column("invoice", "id", Column.TEXT, false);

        return new Construct(key, invoice, new Table[] { item, invoice, customer });
    }
}
