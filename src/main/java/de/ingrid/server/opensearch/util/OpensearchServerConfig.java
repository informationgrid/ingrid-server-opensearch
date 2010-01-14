package de.ingrid.server.opensearch.util;

import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class OpensearchServerConfig extends PropertiesConfiguration {

        // private stuff
        private static OpensearchServerConfig instance = null;

        private final static Log log = LogFactory.getLog(OpensearchServerConfig.class);

        public static final String SERVER_PORT = "server.port";

        public static final String MAX_REQUESTED_HITS = "max.requested.hits";
        
        public static final String PROXY_URL = "proxy.url";

        public static final String METADATA_DETAILS_URL = "metadata.details.url";
        
        public static final String DESCRIPTOR_FILE = "descriptor.file";
        
        public static synchronized OpensearchServerConfig getInstance() {
            if (instance == null) {
                try {
                    instance = new OpensearchServerConfig();
                } catch (Exception e) {
                    if (log.isFatalEnabled()) {
                        log.fatal(
                                "Error loading the portal config application config file. (ingrid-opensearch.properties)",
                                e);
                    }
                }
            }
            return instance;
        }

        private OpensearchServerConfig() throws Exception {
            super("conf/ingrid-opensearch.properties");
        }
    }

