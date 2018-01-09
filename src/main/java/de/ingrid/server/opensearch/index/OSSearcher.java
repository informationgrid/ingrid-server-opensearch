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
/*

 * Copyright (c) 1997-2005 by media style GmbH
 */

package de.ingrid.server.opensearch.index;

import java.io.File;
import java.io.IOException;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.store.FSDirectory;

import de.ingrid.iplug.dsc.index.AbstractSearcher;
import de.ingrid.iplug.scheduler.SchedulingService;
import de.ingrid.opensearch.util.OpensearchConfig;
import de.ingrid.utils.IngridHit;
import de.ingrid.utils.IngridHitDetail;
import de.ingrid.utils.IngridHits;
import de.ingrid.utils.PlugDescription;
import de.ingrid.utils.dsc.Record;
import de.ingrid.utils.processor.ProcessorPipe;
import de.ingrid.utils.query.IngridQuery;

/**
 * Searcher for the local index.
 */
public class OSSearcher extends AbstractSearcher {

	//private RecordLoader fDetailer;

	private SchedulingService fScheduler;

	private PlugDescription fPlugDescription;

	private ProcessorPipe _processorPipe = new ProcessorPipe();
	
	

	/**
	 * Initializes the opensearch searcher variant.
	 */
	public OSSearcher() {
		super();
	}

	/**
	 * @param file
	 * @param string
	 * @throws IOException
	 */
	public OSSearcher(File file, String string) throws IOException {
		super(file, string);
	}
	
	public static OSSearcher getInstance() {
		// this is a hack, since the AbstractSearcher is a singleton
		// and the AbstractSearcher is used in Indexer.
		if (fInstance == null) {
			fInstance = new OSSearcher();
		}
		return (OSSearcher)fInstance;
	}

	public void configure(final PlugDescription plugDescription) throws Exception {
		this.fPlugDescription = plugDescription;
		this.fPlugId = OpensearchConfig.getInstance("conf/ingrid-opensearch.properties").getString("associated.iplug", "NOT_DEFINED");//plugDescription.getPlugId();
		this.fUrl = (String) plugDescription.get("detailUrl");
		if (log.isDebugEnabled()) {
			log.debug("Use search index in: " + new File(plugDescription
					.getWorkinDirectory(), "index").getAbsolutePath());
		}
		
        if (this.fScheduler != null) {
        	this.fScheduler.shutdown();
        }
		this.fScheduler = new SchedulingService(new File(plugDescription.getWorkinDirectory(), "jobstore"));

		File indexDir = new File(plugDescription.getWorkinDirectory(), "index");
		if (indexDir.exists()) {
	        if (this.fSearcher != null) {
	        	log.info("Close searcher: " + this.fSearcher);
	        	this.fSearcher.getIndexReader().close();
	        	this.fSearcher.close();
	        	System.gc();
	        }
			this.fSearcher = new IndexSearcher(IndexReader.open(FSDirectory.open(indexDir), true));
        	log.info("Created new searcher: " + this.fSearcher);
		} else {
			log.warn("Problem when configuring the Searcher. Probably no index available!?");
		}
	}

	public IngridHits search(IngridQuery query, int start, int length)
			throws Exception {

    	_processorPipe.preProcess(query);
		
		IngridHits ingridHits = search(query, false, start, length);
    	
    	
		_processorPipe.postProcess(query, ingridHits.getHits());

		
		return ingridHits;
	}
	
	public IngridHits searchAndDetails(IngridQuery query, int start, int length)
			throws Exception {

    	//_processorPipe.preProcess(query);
		
		IngridHits ingridHits = search(query, false, start, length);
    	
		String[] reqMetadata = {"partner","provider","t1","t2","x1","x2","y1","y2"};
		IngridHitDetail[] details = getDetails(ingridHits.getHits(), query, reqMetadata);
		for (int i=0; i<details.length; i++) {
			ingridHits.getHits()[i].setHitDetail(details[i]);
		}
    	
		//_processorPipe.postProcess(query, ingridHits.getHits());
		
		return ingridHits;
	}
	

	public void close() throws Exception {
        if (this.fSearcher != null) {
            this.fSearcher.getIndexReader().close();
            this.fSearcher.close();
            System.gc();
        }
		if (this.fScheduler != null) {
			this.fScheduler.shutdown();
		}
	}

	public PlugDescription getPlugDescription() {
		return this.fPlugDescription;
	}

	@Override
	public Record getRecord(IngridHit arg0) throws IOException, Exception {
	    log.debug("Returning an empty record, but it shouldn't be called here at all");
		Record rec = new Record();
		return rec;
	}

	
}
