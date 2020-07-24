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
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="de.ingrid.iplug.dsc.index.*" %>
<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="de.ingrid.iplug.*"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<%!
private static IndexRunner fIndexRunner;
class IndexRunner extends Thread{
	private boolean fIndexing = true;
 
	private PlugDescription fDescription;
	public IndexRunner(PlugDescription description){
		fDescription = description;
	}
	public void run(){
		try{

		File indexFolder = new File((String)fDescription.get("workingDirectory"));
		
		indexFolder.mkdirs();
		DatabaseConnection  connectionDesc = (DatabaseConnection) fDescription.getConnection();
		
		String 	connectionURL = connectionDesc.getConnectionURL();
		String dbType = connectionDesc.getDataBaseDriver();
		String user = connectionDesc.getUser();
		String password = connectionDesc.getPassword();
		String schema = connectionDesc.getSchema();
		Construct construct = (Construct) fDescription.get("construct");
		Class.forName(dbType);
		Connection connection = DriverManager.getConnection(connectionURL, user, password);
		
		RecordReader  reader = new RecordReader(construct, connection, schema, connectionURL, user, password);
		System.err.println("target: " +indexFolder.getAbsolutePath());
		Indexer indexer = new Indexer(indexFolder, reader);
		indexer.index();
		indexer.close();
		fIndexing= false;
		} catch (Exception e ){
			e.printStackTrace();
		}
	}
	
	public boolean isIndexing(){
		return fIndexing;
	}
}

%>
<%
if(fIndexRunner == null){
	PlugDescription   description = (PlugDescription)  request.getSession().getAttribute("description");
	fIndexRunner = new IndexRunner(description);
	fIndexRunner.start();
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Datenbank indizieren</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
<%
if(fIndexRunner!=null && fIndexRunner.isIndexing()){
%>
<meta http-equiv="refresh" content="5;">
<%} %>
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a>
		<br />Indizierung der Daten<br /><br />
		<span class="byline">Die Datenbank wird indiziert. Abh&#x00E4;ngig von der Menge der Daten kann dieser Prozess einige Zeit dauern.</span>
	</div>
	<br />

	<%
	if(fIndexRunner!=null && !fIndexRunner.isIndexing()){
		fIndexRunner = null;
	%>
		<table class="table" align="center">
			<tr align="center">
				<td align="center">
					<br />Indizierung abgeschlossen.<br />
				</td>
			</tr>
		</table>
	<%}else{ %>
		<table>
			<tr>
				<td align="center">
					Bitte haben Sie Geduld ...<br />
					<img src="<%=response.encodeURL("gfx/progressbar_anim.gif")%>"/>
				</td>
			</tr>
		</table>	
	<%} %>
	<br />
	<form  method="post" action="<%=response.encodeURL("search.jsp")%>">
	<table class="table" align="center">					
		<tr align="center">
			<td>
				<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
			</td>
			<td>
				<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
			</td>
			<td>
				<input type="submit" value="Weiter" />
			</td>
		</tr>
	</table>
	</form>
</center>
</body>
<!-- ingrid-iplug-admin-step2-dsc -->
</html>
