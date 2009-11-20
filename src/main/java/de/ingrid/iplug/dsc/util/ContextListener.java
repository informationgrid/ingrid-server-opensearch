package de.ingrid.iplug.dsc.util;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

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
        } catch (final IOException e) {
            LOG.error("can not add plugdescription", e);
        }
    }

}
