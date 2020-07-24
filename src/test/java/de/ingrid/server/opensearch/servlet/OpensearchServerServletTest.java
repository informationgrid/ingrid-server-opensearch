/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 - 2020 wemove digital solutions GmbH
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
package de.ingrid.server.opensearch.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletInputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import junit.framework.TestCase;

import org.dom4j.Document;

import de.ingrid.opensearch.util.RequestWrapper;
import de.ingrid.server.opensearch.mapping.OpensearchMapper;
import de.ingrid.utils.IngridHit;
import de.ingrid.utils.IngridHitDetail;
import de.ingrid.utils.IngridHits;
import de.ingrid.utils.tool.SpringUtil;

public class OpensearchServerServletTest extends TestCase {

    protected void setUp() throws Exception {
        super.setUp();
    }

    public void testMapping() throws Exception {
        final OpensearchMapper mapper = (new SpringUtil("spring/spring.xml")).getBean("mapper", OpensearchMapper.class);
        final HashMap<String, Object> parameter = new HashMap<String, Object>();
        
        HttpServletRequest request = new NullHttpServletRequest();
        RequestWrapper reqWrapper = new RequestWrapper(request);
        
        parameter.put(OpensearchMapper.REQUEST_WRAPPER, reqWrapper);
        
        IngridHit hit = new IngridHit();
        hit.setPlugId("/unitTest:plugId");
        hit.setDocumentId(1);
        hit.setDataSourceId(9);
        hit.setScore(0.789f);
        IngridHitDetail detail = new IngridHitDetail(hit, "Test Title", "Test Summary");
        hit.setHitDetail(detail);
        
        IngridHit[] hitsArray = {hit};
        IngridHits hits = new IngridHits(1, hitsArray);
        
        final Document doc = mapper.mapToXML(hits, parameter);
        assertNotNull(doc);
    }

    public class NullHttpServletRequest implements HttpServletRequest {

        @Override
        public Object getAttribute(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Enumeration getAttributeNames() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getCharacterEncoding() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public int getContentLength() {
            // TODO Auto-generated method stub
            return 0;
        }

        @Override
        public String getContentType() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public ServletInputStream getInputStream() throws IOException {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getLocalAddr() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getLocalName() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public int getLocalPort() {
            // TODO Auto-generated method stub
            return 0;
        }

        @Override
        public Locale getLocale() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Enumeration getLocales() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getParameter(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Map getParameterMap() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Enumeration getParameterNames() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String[] getParameterValues(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getProtocol() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public BufferedReader getReader() throws IOException {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getRealPath(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getRemoteAddr() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getRemoteHost() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public int getRemotePort() {
            // TODO Auto-generated method stub
            return 0;
        }

        @Override
        public RequestDispatcher getRequestDispatcher(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getScheme() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getServerName() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public int getServerPort() {
            // TODO Auto-generated method stub
            return 0;
        }

        @Override
        public boolean isSecure() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public void removeAttribute(String arg0) {
            // TODO Auto-generated method stub

        }

        @Override
        public void setAttribute(String arg0, Object arg1) {
            // TODO Auto-generated method stub

        }

        @Override
        public void setCharacterEncoding(String arg0) throws UnsupportedEncodingException {
            // TODO Auto-generated method stub

        }

        @Override
        public String getAuthType() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getContextPath() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Cookie[] getCookies() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public long getDateHeader(String arg0) {
            // TODO Auto-generated method stub
            return 0;
        }

        @Override
        public String getHeader(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Enumeration getHeaderNames() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Enumeration getHeaders(String arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public int getIntHeader(String arg0) {
            // TODO Auto-generated method stub
            return 0;
        }

        @Override
        public String getMethod() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getPathInfo() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getPathTranslated() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getQueryString() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getRemoteUser() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getRequestURI() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public StringBuffer getRequestURL() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getRequestedSessionId() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String getServletPath() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public HttpSession getSession() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public HttpSession getSession(boolean arg0) {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Principal getUserPrincipal() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public boolean isRequestedSessionIdFromCookie() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public boolean isRequestedSessionIdFromURL() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public boolean isRequestedSessionIdFromUrl() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public boolean isRequestedSessionIdValid() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public boolean isUserInRole(String arg0) {
            // TODO Auto-generated method stub
            return false;
        }

    }
}
