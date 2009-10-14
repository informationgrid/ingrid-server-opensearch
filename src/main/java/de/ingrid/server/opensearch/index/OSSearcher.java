/*

 * Copyright (c) 1997-2005 by media style GmbH
 */

package de.ingrid.server.opensearch.index;

import java.io.File;
import java.io.IOException;

import net.sf.ehcache.Cache;

import org.apache.lucene.document.Document;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;

import de.ingrid.iplug.dsc.index.AbstractSearcher;
import de.ingrid.iplug.dsc.index.RecordLoader;
import de.ingrid.iplug.scheduler.SchedulingService;
import de.ingrid.utils.IngridDocument;
import de.ingrid.utils.IngridHit;
import de.ingrid.utils.IngridHitDetail;
import de.ingrid.utils.IngridHits;
import de.ingrid.utils.IngridHitsEnrichmentFactory;
import de.ingrid.utils.PlugDescription;
import de.ingrid.utils.dsc.Record;
import de.ingrid.utils.processor.ProcessorPipe;
import de.ingrid.utils.processor.ProcessorPipeFactory;
import de.ingrid.utils.query.IngridQuery;

/**
 * Searcher for the local index.
 */
public class OSSearcher extends AbstractSearcher {

	private RecordLoader fDetailer;

	private SchedulingService fScheduler;

	private PlugDescription fPlugDescription;

	private Cache cache = null;
	
	private ProcessorPipe _processorPipe = new ProcessorPipe();
	

	/**
	 * Initilaizes the DSC searcher variant.
	 */
	public OSSearcher() {
		// nothing to do here
	}

	/**
	 * @param file
	 * @param string
	 * @throws IOException
	 */
	public OSSearcher(File file, String string) throws IOException {
		super(file, string);
	}

	public void configure(PlugDescription plugDescription) throws Exception {
		this.fPlugDescription = plugDescription;
		this.fPlugId = plugDescription.getPlugId();
		this.fUrl = (String) plugDescription.get("detailUrl");
		if (log.isDebugEnabled()) {
			log.debug("Use search index in: " + new File(plugDescription
					.getWorkinDirectory(), "index").getAbsolutePath());
		}
		this.fSearcher = new IndexSearcher(new File(plugDescription
				.getWorkinDirectory(), "index").getAbsolutePath());
		/*this.fDetailer = new RecordLoader();
		this.fScheduler = new SchedulingService(new File(plugDescription
				.getWorkinDirectory(), "jobstore"));
		ProcessorPipeFactory processorPipeFactory = new ProcessorPipeFactory(
				plugDescription);
		_processorPipe = processorPipeFactory.getProcessorPipe();
		IngridHitsEnrichmentFactory factory = new IngridHitsEnrichmentFactory();
		factory.register(new CswDscIdentifierEnrichment());
		
		this.mapper = SimpleSpringBeanFactory.INSTANCE.getBean(ConfigurationKeys.CSW_MAPPER, DocumentMapper.class);
		if (this.mapper == null) {
			throw new RuntimeException("DSCSearcher is not configured properly. "+
					"Bean '"+ConfigurationKeys.CSW_MAPPER+"' is missing in spring configuration.");
		}


		this.cache = SimpleSpringBeanFactory.INSTANCE.getBean(ConfigurationKeys.CSW_CACHE, Cache.class);
		if (this.cache == null) {
			throw new RuntimeException("DSCSearcher is not configured properly. "+
					"Bean '"+ConfigurationKeys.CSW_CACHE+"' is missing in spring configuration.");
		} else {
			this.cache.configure(SimpleSpringBeanFactory.INSTANCE.getBean(ConfigurationKeys.CSW_FACTORY, CSWFactory.class));
		}*/
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

    	_processorPipe.preProcess(query);
		
		IngridHits ingridHits = search(query, false, start, length);
    	
		String[] reqMetadata = {};
		IngridHitDetail[] details = getDetails(ingridHits.getHits(), query, reqMetadata);
		for (int i=0; i<details.length; i++) {
			ingridHits.getHits()[i].setHitDetail(details[i]);
		}
		
    	
		_processorPipe.postProcess(query, ingridHits.getHits());

		
		return ingridHits;
	}

	

	public void close() throws Exception {
		if (this.fDetailer != null) {
			this.fDetailer.close();
		}
		if (this.fSearcher != null) {
			this.fSearcher.close();
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
		// TODO Auto-generated method stub
		return null;
	}

	
}
