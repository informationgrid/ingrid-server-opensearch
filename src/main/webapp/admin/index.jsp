<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 - 2015 wemove digital solutions GmbH
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
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*" %>
<%@ page import="de.ingrid.iplug.*" %>
<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="de.ingrid.utils.xml.*"%>
<%@ page import="de.ingrid.utils.PlugDescription" %>
<%@ page import="de.ingrid.utils.BeanFactory"%>
<%@ page import="de.ingrid.iplug.util.*"%>
<%
BeanFactory beanFactory = (BeanFactory) application.getAttribute("beanFactory");
File pd_file = (File) beanFactory.getBean("pd_file");
PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");

if (pd_file.exists()) {
	InputStream in = new FileInputStream(pd_file);
	
	XMLSerializer serializer = new XMLSerializer();
	serializer.aliasClass(PlugDescription.class.getName(), PlugDescription.class );
	description = (PlugDescription)serializer.deSerialize(in);		
}

request.getSession().removeAttribute("description");
request.getSession().setAttribute("description", description);

//description.setIPlugClass("de.ingrid.iplug.dsc.index.DSCSearcher");
Construct construct = (Construct) description.get("construct");
request.getSession().setAttribute("construct", construct);

String mode = WebUtil.getParameter(request, "mode", "invalid");
if(mode.equals("editall")){
	response.sendRedirect(response.encodeRedirectURL("osSettings.jsp"));
}else if(mode.equals("reindex")){
	response.sendRedirect(response.encodeRedirectURL("scheduler.jsp"));
}	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Index Mapping</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />

</head>
<body>
<center>
    <div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
        Administration des Opensearch-Servers
        <br /><br />
    </div>
    <br />
	<form name="mode" method="post" action="<%=response.encodeURL("index.jsp")%>">
		<table class="table" width="400" align="center">
		    <tr>
		        <td colspan="2" class="tablehead" align="center">Auswahl</td>
		    </tr>
		    <tr>
		        <td class="tablecell"><a href="index.jsp?mode=editall"><input type="button" value="Alle Einstellungen bearbeiten"/></a></td>
		        <td class="tablecell"><a href="index.jsp?mode=reindex"><input type="button" value="Nur Zeitsteuerung bearbeiten / sofortige Neuindizierung"/></a></td>
		    </tr>
		</table>
	</form>
</center>
</body>
</html>
