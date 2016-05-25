/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 - 2016 wemove digital solutions GmbH
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
package de.ingrid.iplug.dsc.util;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import de.ingrid.server.opensearch.index.OSSearcher;
import de.ingrid.utils.BeanFactory;
import de.ingrid.utils.PlugDescription;
import de.ingrid.utils.xml.XMLSerializer;

public class ContextListener implements ServletContextListener {

    private static final Logger LOG = Logger.getLogger(ContextListener.class);

    @Override
    public void contextDestroyed(final ServletContextEvent servletcontextevent) {

    }

    @Override
    public void contextInitialized(final ServletContextEvent servletcontextevent) {
        final ServletContext servletContext = servletcontextevent.getServletContext();

        final BeanFactory beanFactory = new BeanFactory();
        servletContext.setAttribute("beanFactory", beanFactory);

        String plugDescription = System.getProperty("plugDescription");
        if (plugDescription == null) {
            plugDescription = "conf/plugdescription.xml";
            System.setProperty("plugDescription", plugDescription);
            LOG.warn("plug description is not defined. using default: " + plugDescription);
        }

        try {
            final File file = new File(plugDescription);
            if (!file.exists()) {
                //file.mkdirs();
                file.createNewFile();
                final PlugDescription pd = new PlugDescription();
                final XMLSerializer serializer = new XMLSerializer();
                serializer.serialize(pd, file);
            }
            beanFactory.addBean("pd_file", file);
            
            // init and start scheduler of DSC component
            OSSearcher searcher = OSSearcher.getInstance();
            final XMLSerializer serializer = new XMLSerializer();
            
            PlugDescription pd = (PlugDescription)serializer.deSerialize(file);
            pd.put("PLUGDESCRIPTION_FILE", file.getAbsolutePath());
            try {
                searcher.configure(pd);
            } catch (Exception e) {
                LOG.error("Problem when configuring the Searcher. Probably no index available!?", e);
            }
        } catch (final IOException e) {
            LOG.error("can not add plugdescription", e);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
}
