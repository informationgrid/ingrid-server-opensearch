<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 - 2020 wemove digital solutions GmbH
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
<%@ include file="timeoutcheck.jsp"%>
<%
	//de.ingrid.iplug.web.WebContainer container = (de.ingrid.iplug.web.WebContainer) application.getAttribute("server");
	//container.logoutUser(request.getUserPrincipal());
	//System.out.println("user logged out: " +request.getUserPrincipal().getName());

	//String header = "WWW-Authenticate";
	//String value = "Basic realm=\"admin\"";
	request.getSession().invalidate();

	//response.addHeader(header, value);
	//response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Konfiguation abgeschlossen</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
	<div class="headline"><!-- <a class="logout" href="login.jsp?logout=true">abmelden</a>--><br />
		Konfiguration abgeschlossen
		<br /><br />
		<span class="byline">
			Ihr Opensearch-Server ist jetzt fertig eingerichtet. Sie k&#x00F6;nnen Ihren Browser schlie&#x00DF;en.<br />
		</span>
	</div>
	<br />
	<form method="post" action="<%=response.encodeURL("index.jsp")%>">
	<table class="table" align="center">
		<tr align="center">
			<td>
				<input type="submit" value="Neu einloggen" />
			</td>
		</tr>
	</table>
	</form>
	</center>
</body>
</html>
