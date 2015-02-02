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
package de.ingrid.server.security;

import java.security.Principal;
import java.util.Set;

import javax.security.auth.Subject;
import javax.security.auth.login.LoginContext;
import javax.security.auth.login.LoginException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mortbay.jetty.Request;
import org.mortbay.jetty.security.UserRealm;

import de.ingrid.server.security.IngridPrincipal.KnownPrincipal;

public class IngridRealm implements UserRealm {

    private final Log LOG = LogFactory.getLog(IngridRealm.class);

    public IngridRealm() {
        System.setProperty("java.security.auth.login.config", System.getProperty("user.dir") + "/conf/ingrid.auth");
    }

    @Override
    public Principal authenticate(final String userName, final Object password, final Request request) {

        Principal principal = null;
        try {
            final RequestCallbackHandler handler = new RequestCallbackHandler(request);
            final LoginContext loginContext = new LoginContext("IngridLogin", handler);
            loginContext.login();
            final Subject subject = loginContext.getSubject();
            final Set<Principal> principals = subject.getPrincipals();
            final Principal tmpPrincipal = principals.isEmpty() ? principal : principals.iterator().next();
            if (tmpPrincipal instanceof KnownPrincipal) {
                final KnownPrincipal knownPrincipal = (KnownPrincipal) tmpPrincipal;
                knownPrincipal.setLoginContext(loginContext);
                principal = knownPrincipal;
                LOG.info("principal has logged in: " + principal);
            }
        } catch (final LoginException e) {
            LOG.error("login error for user: " + userName);
        }
        if (principal == null) {
            LOG.info("login failed for userName: " + userName);
        }
        return principal;
    }

    @Override
    public void disassociate(final Principal principal) {
        // nothing todo
    }

    @Override
    public String getName() {
        return IngridRealm.class.getSimpleName();
    }

    @Override
    public Principal getPrincipal(final String name) {
        throw new UnsupportedOperationException("not implemented");
    }

    @Override
    public boolean isUserInRole(final Principal principal, final String role) {
        boolean bit = false;
        if (principal instanceof KnownPrincipal) {
            final KnownPrincipal knownPrincipal = (KnownPrincipal) principal;
            bit = knownPrincipal.isInRole(role);
        }
        return bit;
    }

    @Override
    public void logout(final Principal principal) {
        try {
            if (principal instanceof KnownPrincipal) {
                final KnownPrincipal knownPrincipal = (KnownPrincipal) principal;
                final LoginContext loginContext = knownPrincipal.getLoginContext();
                if (loginContext != null) {
                    loginContext.logout();
                }
                LOG.info("principal has logged out: " + knownPrincipal);
            }
        } catch (final LoginException e) {
            LOG.warn("logout failed", e);
        }
    }

    @Override
    public Principal popRole(final Principal principal) {
        return principal;
    }

    @Override
    public Principal pushRole(final Principal principal, final String role) {
        return principal;
    }

    @Override
    public boolean reauthenticate(final Principal principal) {
        return (principal instanceof KnownPrincipal);
    }

}
