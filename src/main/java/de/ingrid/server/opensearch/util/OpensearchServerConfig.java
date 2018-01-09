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
package de.ingrid.server.opensearch.util;

import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class OpensearchServerConfig extends PropertiesConfiguration {

    // private stuff
    private static OpensearchServerConfig instance = null;

    private final static Log log = LogFactory.getLog( OpensearchServerConfig.class );

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
                    log.fatal( "Error loading the application config file. (ingrid-opensearch.properties)", e );
                }
            }
        }
        return instance;
    }

    private OpensearchServerConfig() throws Exception {
        super( "conf/ingrid-opensearch.properties" );
    }
}
