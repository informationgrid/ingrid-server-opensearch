<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 - 2016 wemove digital solutions GmbH
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
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Felder f&#x00FC;r den Index ausw&#x00E4;hlen</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Felder f&#x00FC;r den Index ausw&#x00E4;hlen
		<br /><br />
		<span class="byline">
		F&#x00FC;r untenstehende Felder k&#x00F6;nnen durch das bisherige Mapping eindeutige Anfragen definiert werden.<br />
		Bitte w&#x00E4;hlen Sie ein oder mehrere Felder aus, deren Werte im Index hinterlegt werden sollen.
		</span>		
	</div>
	<br />
	
	<form method="post" action="<%=response.encodeURL("selectIndexFields.jsp")%>">
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
	<br />
	
	<%
	String[] fieldsToIndex = request.getParameterValues("fields")!=null?request.getParameterValues("fields"):new String[]{};
	if (fieldsToIndex.length > 0) {
		request.getSession().setAttribute("fields", fieldsToIndex);
		response.sendRedirect(response.encodeRedirectURL("nameIndexFields.jsp?start=true"));
	}
	%>
	
	
	<%
	String error = request.getParameter("error");
	if ((error != null) && (fieldsToIndex.length == 0)) {
	%>
		<div class="error">Bitte w&#x00E4;hlen Sie mindestens ein Feld aus, das im Index hinterlegt werden soll!</div>
		<br />
	<%}%>

	
	<%
	Construct construct = (Construct)request.getSession().getAttribute("construct");	
	Table[]  tables = construct.getTables();

		for(int i= 0; i < tables.length; i++	){
		Table table = tables[i];
	%>
			<table class="table">
				<tr>
					<td colspan="2" class="tablehead"><%=tables[i].getTableName()%></td>
				</tr>
				<%
				Column[] columns =  table.getColumns();
				for(int j = 0; j < columns.length; j++){
					Column column = columns[j];
					boolean toIndex = columns[j].toIndex();
					boolean unique = false;
				%>
				<tr>
					<td class="tablecell" width="20">
						<%if(toIndex!=true){ %>
							<p style="text-align:left">
								<input type="checkbox" name="fields" value="<%=column.getId()%>" />
							</p>							
						<%}else{%>
							<p style="text-align:left">
								<img src="<%=response.encodeURL("gfx/okay.gif")%>" border="0" title="wird indiziert" />
								</p>							
						<%} %>
					</td>
					<td class="tablecell">
						<%if (unique == true) { %>
						<p style="text-align:left">
								<img src="<%=response.encodeURL("gfx/primKey.gif")%>" border="0" alt="unique"/>
						</p>
					<%}%>
						<%=column.getColumnName() %>
						<%
						if (toIndex == true) {
						%>							
							<b>Index: <%=columns[j].getTargetName() %></b>
						<%} %>
					</td>
				</tr>
				<%} %>
			</table>
			<br />
		<%}%>
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
