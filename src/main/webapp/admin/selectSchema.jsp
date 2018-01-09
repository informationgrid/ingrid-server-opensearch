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
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="de.ingrid.iplug.dsc.schema.DBSchemaController" %>
<%@ page import="de.ingrid.iplug.dsc.schema.Table" %>
<%@ page import="de.ingrid.iplug.*" %>
<%@ page import="de.ingrid.iplug.dsc.index.*" %>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Schema w&#x00E4;hlen</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Schema ausw&#x00E4;hlen<br /><br />	
	</div>

<br />

<%
String error = request.getParameter("error");
if (error != null) {
%>
	<br />
	<div class="error">Bitte w&#x00E4;hlen Sie ein Schema!</div>
	<br />
<%}%>

<%
String mode = "";
if(request.getParameter("mode") != null) {
	mode = request.getParameter("mode");
}
%>

<%
String selectedSchemaName = request.getParameter("schemaName");
if (selectedSchemaName != null){
	DBSchemaController controller = (DBSchemaController)request.getSession().getAttribute("controller");	
	Table[] tables =controller.getTablesFromSchema(selectedSchemaName);
	
	PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");
	DatabaseConnection oldConnection = (DatabaseConnection)description.getConnection();
	
	DatabaseConnection  connectionDesc = new   DatabaseConnection(oldConnection.getDataBaseDriver(), oldConnection.getConnectionURL(), oldConnection.getUser(), oldConnection.getPassword(), selectedSchemaName);
	//remove old connection befor added a new one
	description.removeConnection(oldConnection);
	description.addConnection(connectionDesc);
	request.getSession().setAttribute("tables", tables);
	if(!mode.equals("loadPreset")){
		response.sendRedirect(response.encodeRedirectURL("selectKeyColumn.jsp"));
	}else{
		response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
	}
}
%>

<%
String[] schemas = (String[])request.getSession().getAttribute("schemas");
%>
<form method="post" action="<%=response.encodeURL("selectSchema.jsp")%>">
	<input type="hidden" name="error" value="nothingSelected"/>
	<%
	if("loadPreset".equals(mode)){ 
	%>
		<input type="hidden" name="mode" value="loadPreset"/>
	<%}%>
	<table class="table" align="center">
		<tr>
			<td colspan="2" class="tableHead">Schema w&#x00E4;hlen</td>
		</tr>
		<%
		for(int i= 0; i < schemas.length; i++){
		    String schemaName = schemas[i];
		%>
			<tr>
				<td witdh="30" align="center" class="tableCell">
					<input type="radio" name="schemaName" value="<%=schemaName%>"/>
				</td>
				<td class="tableCell"><%=schemaName%>&nbsp;</td>
			</tr>	
		<%}%>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit"/></td>
		</tr>	
	</table>
</form>
</center>
</body>
</html>
