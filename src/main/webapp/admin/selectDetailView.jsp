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
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ page import="de.ingrid.iplug.util.WebUtil"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ include file="timeoutcheck.jsp"%>
<%
String error = "";
String url = "";
PlugDescription description = (PlugDescription) request.getSession().getAttribute("description");

// radio selected and custom URL
if(WebUtil.getParameter(request, "submitted", null)!=null){
	String detailUrl = WebUtil.getParameter(request, "detailUrl", "");
	if(!detailUrl.equals("")){
		description.put("detailUrl", detailUrl);
		response.sendRedirect(response.encodeRedirectURL("scheduler.jsp"));
	} else {
		error = "urlEmpty";
	}
	url = detailUrl;
}

if(WebUtil.getParameter(request, "submitted", null)==null && description.get("detailUrl") != null){
	url = (String) description.get("detailUrl");
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
<title>Detailansicht</title>
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Detailansicht w&#x00E4;hlen
		<br /><br />
		<span class="byline">
		Bitte geben Sie für eine externe Webanwendung eine URL an, in der Sie als Platzhalter für Parameterwerte {Indexfeldnamen} geschweifte Klammern verwenden.
		<br /><br />
		Bsp.: http://www.meineUrl.com?id={t01_Object.obj_id}&template=mytemplate
		<br />
		</span>		
	</div>
	<br />
	<form method="post" action="<%=response.encodeURL("selectDetailView.jsp")%>">
		<table class="table" align="center">					
		<tr align="center">
			<td>
				<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
			</td>
			<td>
				<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
			</td>
			<td>
				<input type="hidden" name="submitted" value="true" name="cont"/>
				<input type="submit" value="Weiter" />
			</td>
		</tr>
		</table>
		<br />
		
		<%
		if (error.equals("urlEmpty")) {%>
			<div class="error">Url darf nicht leer sein.</div>
			<br />
		<%}%>
	
		<table class="table">
			<tr>
				<td class="tableHead" colspan="2">Detailansicht</td>
			</tr>		
				<tr>
				<td class="tablecell">Eigene, externe Detailanzeige verwenden
					<br />
					<input type="text" name="detailUrl" value="<%=url%>" style="width:100%" />
				</td>
			</tr>
		</table>
		<br />
		<hr/>
		<br />
		
		<%
		
		Construct construct = (Construct) request.getSession().getAttribute("construct");
		Column[] columns = construct.getColumns();
		
		%>
		
		Externe Anwendung: Folgende Indexfeldnamen stehen als Platzhalter f&#x00FC;r Parameterwerte zur Verf&#x00FC;gung:
		<br />
		<br />
		<table class="table">
			<tr>
				<td class="tableHead">Ihre Datenbank</td>
				<td class="tableHead">Platzhalter</td>
			</tr>
			<%		
			for(int i=0; i < columns.length; i++){
				if(columns[i].toIndex()){
				Column column = columns[i];
			%>
			<tr>
				<td class="tablecell"><%=column.toString()%></td>
				<td class="tablecell">{<%=column.getTargetName().toLowerCase()%>}</td>
			</tr>
			<%} %>
			<%} %>
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
					<input type="hidden" name="submitted" value="true" name="cont"/>
					<input type="submit" value="Weiter" />
				</td>
			</tr>
		</table>
	</form>	
</center>
</body>
<!-- ingrid-iplug-admin-step2-dsc -->
</html>
