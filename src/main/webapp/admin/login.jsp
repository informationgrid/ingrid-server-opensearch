<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 wemove digital solutions GmbH
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
<%@ page import="de.ingrid.iplug.util.*"%>
<%
final boolean logout = WebUtil.getParameter(request, "logout", null) != null;
if (logout) {
    session.invalidate();
}
final String error = WebUtil.getParameter(request, "error", null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Datenbankverbindung</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
    <center>
    <div class="headline"><br />
        Authentifizierung
        <br /><br />
        <span class="byline">
        Bitte authentifizieren Sie sich um fortzufahren.
        </span>
    </div>
    <br />
<% if (logout) { %>
    <div class="success">
    Sie wurden erfolgreich abgemeldet.
    </div>
    <br />
<% } %>
<% if (error != null) { %>
    <div class="error">
    <% if ("wrong".equals(error)) { %>
        Die Anmeldung ist fehlgeschlagen. Bitte überprüfen Sie Ihre Daten.
    <% } else if ("role".equals(error)) { %>
        Sie besitzen nicht aureichend Rechte für diese Aktion.
    <% } %>
    </div>
    <br />
<% } %>
    <form name="selectDb" method="post" action="j_security_check">
        <table class="table" width="400" align="center">
            <tr>
                <td colspan="2" class="tablehead">Login Daten</td>
            </tr>
            <tr>
                <td class="tablecell" width="100">Benutzer:</td>
                <td class="tablecell"><input type="text" name="j_username" style="width:100%" value="admin" /></td>
            </tr>
            <tr>
                <td class="tablecell" width="100">Password:</td>
                <td class="tablecell"><input type="password" name="j_password" style="width:100%" value="" /></td>
            </tr>
	    </table>
	    <br />
        <table class="table" align="center">
	        <tr align="center">
	            <td>
	                <input type="submit" value="Anmelden" />                       
	            </td>
	        </tr>
	    </table>
    </form>
    </center>
</body>
</html>