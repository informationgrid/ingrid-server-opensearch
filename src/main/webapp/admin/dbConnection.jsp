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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="de.ingrid.iplug.dsc.index.*"%>
<%@ page import="de.ingrid.iplug.util.*"%>
<%@ page import="de.ingrid.utils.PlugDescription" %>
<%@ include file="timeoutcheck.jsp"%>
<%!
public static String DBCONNECTION_ERROR = "dbConnectionError";
public static String MAPPING_ERROR = "mappingError";
%>
<%

	boolean submitted = WebUtil.getParameter(request, "submitted", null )!=null;
	String error = request.getParameter("error");
	
	PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");
	
	if(WebUtil.getParameter(request, "resetMapping", "false").equals("true")){
		description.put("construct", null);
		request.getSession().removeAttribute("construct");
	}
	
	DatabaseConnection  connection = (DatabaseConnection )description.getConnection();
	
	String dbType = "";
	String user = "";
	String connectionURL = "";
	String password = "";
	String schema = null;
	if(connection != null && connection.getSchema() != null && !connection.getSchema().equals("")){
		schema = connection.getSchema();
	}
		if(submitted){
			dbType = WebUtil.getParameter(request, "dbType", "");
			user = WebUtil.getParameter(request, "user", "");
			connectionURL = WebUtil.getParameter(request, "connectionURL", "");
			password = WebUtil.getParameter(request, "password", "");
		}else{
			if(connection!=null){
				dbType = connection.getDataBaseDriver();
				user = connection.getUser();
				connectionURL = connection.getConnectionURL();
				password = connection.getPassword();
			}
		}
	if(submitted){
		// first create the sql connect since we want to cache it anyway
		Connection sqlConnection = null;
		try{
			Class.forName(dbType);
			sqlConnection = DriverManager.getConnection(connectionURL, user, password);
			request.getSession().setAttribute("connection", sqlConnection);
			System.out.println("Schema: " +schema);
//			remove old connection before adding a new one
			if(description.getConnection() != null){
				description.removeConnection(description.getConnection());	
			}
			description.addConnection(new DatabaseConnection(dbType, connectionURL, user, password, schema));
		}catch(Exception e)
		{
			e.printStackTrace();
			error = DBCONNECTION_ERROR;
		}
		Construct construct = (Construct) request.getSession().getAttribute("construct");
		// check db consitence since we already have a construct
		if(construct!=null && sqlConnection!=null){
			try{
				RecordReader reader = new RecordReader(construct, sqlConnection, schema, connectionURL, user, password);
				reader.nextRecord();				
			} catch (Exception e)
			{
				error = MAPPING_ERROR;
			}
		}
		
		if(error==null && construct!=null){
			DBSchemaController controller = new DBSchemaController(sqlConnection);
			request.getSession().setAttribute("controller", controller);
			//System.out.println("schemas:" + java.util.Arrays.asList(controller.getSchemas()));
			String[] schemas = controller.getSchemas();
			if(schemas.length>0){
				request.getSession().setAttribute("schemas", schemas);
			}
			String mySchema = connection.getSchema();
			Table[] tables = null;
			if(mySchema != null){
				tables = controller.getTablesFromSchema(mySchema);
			}else if(mySchema == null && schemas.length>0){
				response.sendRedirect(response.encodeRedirectURL("selectSchema.jsp?mode=loadPreset"));
			}else{
				tables = controller.getTables();
			}
			request.getSession().setAttribute("tables", tables);
			response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
		}
		if(error==null && construct==null){
			DBSchemaController controller = new DBSchemaController(sqlConnection);
			request.getSession().setAttribute("controller", controller);
//			System.out.println("schemas:" + java.util.Arrays.asList(controller.getSchemas()));
			String[] schemas = controller.getSchemas();
			if(schemas.length>0){
				request.getSession().setAttribute("schemas", schemas);
				response.sendRedirect(response.encodeRedirectURL("selectSchema.jsp"));
			} else {
				Table[] tables = controller.getTables();
				request.getSession().setAttribute("tables", tables);
				response.sendRedirect(response.encodeRedirectURL("selectKeyColumn.jsp"));
			}
		}
	}
		
		
	%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Datenbankverbindung</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />

<script  language="javascript">
	function fillPreset(){
		var type = document.selectDb.dbType.options[document.selectDb.dbType.selectedIndex].value;
		if (type=='com.mysql.jdbc.Driver'){
			document.selectDb.connectionURL.value='jdbc:mysql://';
		}
		else if (type=='oracle.jdbc.driver.OracleDriver'){
			document.selectDb.connectionURL.value='jdbc:oracle:thin:@';
		}
		else if (type=='com.microsoft.jdbc.sqlserver.SQLServerDriver'){
			document.selectDb.connectionURL.value='jdbc:microsoft:sqlserver://';
		}
		else if (type=='com.microsoft.sqlserver.jdbc.SQLServerDriver'){
			document.selectDb.connectionURL.value='jdbc:sqlserver://';
		}
		else if (type=='org.postgresql.Driver'){
			document.selectDb.connectionURL.value='jdbc:postgresql://';
		}
		else{
			document.selectDb.connectionURL.value='jdbc:';
		}
	}
</script>

</head>
<body>
	<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Datenbankverbindung einrichten
		<br /><br />
		<span class="byline">
		Beispiele f&#x00FC;r die DB URL:<br />
		<b>MySql:</b> jdbc:mysql://&lt;host&gt;:&lt;port&gt;/&lt;databasename&gt; (Defaultport: 3306)<br />
		<b>Oracle:</b> jdbc:oracle:thin:@&lt;host&gt;:&lt;port&gt;:&lt;databasename&gt; (Defaultport:1521)<br />
		<b>MS SQL Server:</b> jdbc:microsoft:sqlserver://&lt;host&gt;:&lt;port&gt;;DatabaseName=&lt;databasename&gt; (Defaultport:1433)<br />
		<b>PostgreSQL:</b> jdbc:postgresql://&lt;host&gt;:&lt;port&gt;/&lt;databasename&gt; (Defaultport:5432)<br />
		</span>		
	</div>
	<br />
	<%
	if (error != null && error.equals(DBCONNECTION_ERROR)) {%>
		<div class="error">Datenbankverbindung konnte nicht hergestellt werden. Bitte &#x00FC;berpr&#x00FC;fen Sie Ihre Angaben!</div>
		<br />
	<%}%>
<%
	if (error != null && error.equals(MAPPING_ERROR)) {%>
		<div class="error">Mit der neuen Datenbankverbindung ist Ihr Mapping ung&#x00FC;ltig!<br />
		Sie k&#x00F6;nnen das Mapping zur&#x00FC;cksetzen oder die Verbindungsdaten korrigieren.
		<br /><br />
		<form method="post" action="<%=response.encodeURL("dbConnection.jsp")%>">			
			<input type="hidden" name="resetMapping" value="true">
			<input type="hidden" name="connectionURL"  style="width:100%" value="<%=connectionURL%>"/>
			<input type="hidden" name="dbType" style="width:100%" value="<%=dbType%>"/>
			<input type="hidden" name="user" style="width:100%" value="<%=user%>"/>
			<input type="hidden" name="password" style="width:100%" value="<%=password%>"/>
			<input type="hidden" name="submitted" value="true">
			<input type="submit"  value="Mapping zur&uuml;cksetzen"/> 
		</form>
		</div>
		<br />
	<%}%>
	<form name="selectDb" method="post" action="<%=response.encodeURL("dbConnection.jsp")%>">
		<table class="table" width="400" align="center">
			<tr>
				<td colspan="2" class="tablehead">Datenbank-Verbindung</td>
			</tr>
			<tr>
				<td class="tablecell" width="100">Typ:</td>
				<td class="tablecell">
					<select onChange=fillPreset() name="dbType">
						<option value="">bitte w&auml;hlen</option>
						<option value="com.mysql.jdbc.Driver" <%if(dbType.equals("com.mysql.jdbc.Driver")){ %>selected="selected"<%}%>>MySQL</option>
						<option value="oracle.jdbc.driver.OracleDriver" <%if(dbType.equals("oracle.jdbc.driver.OracleDriver")){ %>selected="selected"<%}%>>Oracle</option>
						<option value="com.microsoft.jdbc.sqlserver.SQLServerDriver" <%if(dbType.equals("com.microsoft.jdbc.sqlserver.SQLServerDriver")){ %>selected="selected"<%}%>>Microsoft SQL Server 2000</option>
						<option value="com.microsoft.sqlserver.jdbc.SQLServerDriver" <%if(dbType.equals("com.microsoft.sqlserver.jdbc.SQLServerDriver")){ %>selected="selected"<%}%>>Microsoft SQL Server 2005</option>
						<option value="org.postgresql.Driver" <%if(dbType.equals("org.postgresql.Driver")){ %>selected="selected"<%}%>>PostgreSQL</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="tablecell" width="100">DB URL:</td>
				<td class="tablecell">
					<input name="connectionURL" type="text" style="width:100%" value="<%=connectionURL%>"/>					
				</td>
			</tr>
			<tr>
				<td class="tablecell" width="100">Benutzername:</td>
				<td class="tablecell">
					<input name="user" type="text" style="width:100%" value="<%=user%>"/>					
				</td>
			</tr>
			<tr>
				<td class="tablecell" width="100">Passwort:</td>
				<td class="tablecell">
					<input name="password" type="password" style="width:100%" value="<%=password%>"/>					
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
						<input type="hidden" name="submitted" value="true"> 
						<input type="submit" value="Weiter"/>						
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
</html>
