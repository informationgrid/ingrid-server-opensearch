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
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<%

if (request.getParameter("columnId") != null) {
	int columId = Integer.parseInt(request.getParameter("columnId"));
	Table[] tables = (Table[])request.getSession().getAttribute("tables");
	Column keyColumnOrg = UiUtil.getColumnFromTables(tables, columId);
	Table orginalTable = UiUtil.getTableContainsColumn(tables, columId);
	Table table = (Table)UiUtil.deepClone(orginalTable);
	
	Column keyCol = table.getColumnByName(keyColumnOrg.getColumnName());
	keyCol.setType(Column.TEXT);
	Construct construct = new Construct(keyCol,table);
	request.getSession().setAttribute("construct",construct);
	response.sendRedirect(response.encodeRedirectURL("addRelation.jsp?tableId="+table.getId()));
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Primary Key ausw&#x00E4;hlen</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Mapping Startpunkt<br /><br />
		<span class="byline">Bitte w&#x00E4;hlen Sie die Tabellenspalte, die den eindeutigen Schl&#x00FC;ssel Ihrer Daten enth&#x00E4;lt.<br /> 
		</span>
	</div>
	<br />
	<form method="get" action="<%=response.encodeURL("selectKeyColumn.jsp?error=nothingSelected")%>">	
	<input type="hidden" name="error" value="nothingSelected"/>
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
				</td>
				<td>
					<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
				</td>
				<td>
					<input type="submit" value="Weiter"/>	
				</td>
			</tr>
		</table>
	<%
	String error = request.getParameter("error");
	if (error != null) {
	%>
		<br />
		<div class="error">Bitte w&#x00E4;hlen Sie eine Tabelle aus!</div>
	<%}%>
	<br />
		<table class="table" align="center">					
		<tr align="center">
			<td>
				<jsp:include page="includes/selectColumn.jsp"/>
			</td>
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
				<input type="submit" value="Weiter"/>	
			</td>
		</tr>
		</table>
	</form>	
</center>
</body>
<!-- ingrid-iplug-admin-step2-dsc -->	
</html>