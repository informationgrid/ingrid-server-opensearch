<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 - 2018 wemove digital solutions GmbH
  ==================================================
  Licensed under the EUPL, Version 1.1 or – as soon they will be
  approved by the European Commission - subsequent versions of the
  EUPL (the "Licence");
  
  You may not use this work except in compliance with the Licence.
  You may obtain a copy of the Licence at:
  
  http://ec.europa.eu/idabc/eupl5
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the Licence is distributed on an "AS IS" basis,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the Licence for the specific language governing permissions and
  limitations under the Licence.
  **************************************************#
  --%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="de.ingrid.iplug.dsc.index.*"%>
<%@ page import="de.ingrid.iplug.util.*"%>
<%@ page import="de.ingrid.utils.PlugDescription" %>
<%@ page import="org.apache.commons.configuration.PropertiesConfiguration" %>
<%@ page import="de.ingrid.opensearch.util.OpensearchConfig"%>
<%@ include file="timeoutcheck.jsp"%>
<%@ page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="org.w3c.dom.NodeList"%>
<%@page import="javax.xml.xpath.XPath"%>
<%@page import="javax.xml.xpath.XPathFactory"%>
<%@page import="javax.xml.xpath.XPathConstants"%>
<%@page import="org.apache.xml.serialize.OutputFormat"%>
<%@page import="org.apache.xml.serialize.XMLSerializer"%>

<%!
private final String SERVER_PORT    = "server.port";
private final String PROXY_URL      = "proxy.url";

private final String ERROR_PORT     = "error.port";
%>
<%

	boolean submitted = WebUtil.getParameter(request, "submitted", null )!=null;
	String error = request.getParameter("error");
	PropertiesConfiguration properties = OpensearchConfig.getInstance();//new PropertiesConfiguration("conf/ingrid-opensearch.properties");
	
	if(submitted){
	    String port = request.getParameter("port");
	    
	    // save back in properties file
        properties.setProperty(SERVER_PORT, port);
        properties.setProperty(PROXY_URL,   request.getParameter("extUrl"));
        
        // check if port is correct
	    if (!port.matches("[1-9][0-9]+")) {
	        error = ERROR_PORT;
	    } else {
		    properties.save();
		    
		    //-------------------------------------------
		    // write descriptor with updated external URL
		    //-------------------------------------------
		    DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse (new File("conf/descriptor.xml"));
            
            NodeList nodeList = doc.getElementsByTagName("Url");
            XPath xpath = XPathFactory.newInstance().newXPath();
            NodeList urlList = (NodeList) xpath.evaluate("/OpenSearchDescription/Url/@template", doc, XPathConstants.NODESET);
            String url = urlList.item(0).getTextContent();
            url = url.replaceAll("http:.*query", request.getParameter("extUrl") + "/query");
            urlList.item(0).setTextContent(url);
            //System.out.println("URL: " + url);
            
            FileOutputStream fos = new FileOutputStream("conf/descriptor.xml");
            // XERCES 1 or 2 additionnal classes.
			OutputFormat of = new OutputFormat("XML","UTF-8",true);
			of.setIndent(1);
			of.setIndenting(true);
			XMLSerializer serializer = new XMLSerializer(fos,of);
			// As a DOM Serializer
			serializer.asDOMSerializer();
			serializer.serialize( doc.getDocumentElement() );
			fos.close();
			//-------------------------------------------
			
		    // write working directory into PD which is also needed for indexing
		    PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");
		    description.setWorkinDirectory(new File("./"));
            description.setIPlugClass("de.ingrid.server.opensearch.index.OSSearcher");

		    //System.out.println("WorkingDir: " + (new File("index/")).getAbsolutePath());
		    
		    // redirect to the next page
		    response.sendRedirect(response.encodeRedirectURL("dbConnection.jsp"));
	    }
	} 
		
	String port   = properties.getString(SERVER_PORT);
    String extUrl = properties.getString(PROXY_URL);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Opensearch Server - Administration</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />

<script  language="javascript">

</script>

</head>
<body>
	<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Opensearch Einstellungen
		<br /><br />	
	</div>
	<br />
	<form name="osSettings" method="post" action="<%=response.encodeURL("osSettings.jsp")%>">
		<table class="table" style="width:600px;" align="center">
			<tr>
				<td colspan="2" class="tablehead">Einstellungen</td>
			</tr>
			<tr>
				<td class="tablecell" width="160">Opensearch-Server Port:</td>
				<td class="tablecell">
				    <input name="port" type="text" style="width:100%" value="<%=port%>"/>
				    <% if (error != null && error.equals(ERROR_PORT)) { %>
				    <div class="error">Der Port muss mindestens zweistellig sein und nur aus Zahlen bestehen!</div>
				    <% } %>
				    <div style="color:gray;">Port auf dem der Opensearch-Server betrieben werden soll Wird dieser Port geändert so muss der Server neu gestartet werden.</div> 
				</td>
			</tr>
			<tr>
                <td class="tablecell" width="160">Externe URL des Dienstes:</td>
                <td class="tablecell"><input name="extUrl" type="text" style="width:100%" value="<%=extUrl%>"/><br/>
                <div style="color:gray;">Von außen sichtbare URL des Dienstes. Diese URL wird verwendet, um den Dienst in Suchergebnis und Deskriptor zu referenzieren.</div></td>
            </tr>
		</table>
		<br />
		<table class="table" align="center">
				<tr align="center">
					<td>
						<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
					</td>
					<td>
						<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
					</td>
					<td>
						<input type="hidden" name="submitted" value="true"> 
						<input type="submit" value="Weiter"/>						
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
</html>
