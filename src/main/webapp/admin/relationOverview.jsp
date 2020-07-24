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
<%@ page import="de.ingrid.utils.dsc.*"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.utils.dsc.Filter"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ page import="de.ingrid.iplug.util.WebUtil"%>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Mapping-&#x00DC;bersicht</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>

<%

	Construct construct = (Construct) request.getSession().getAttribute("construct");
	
	String finishMapping = "false";
	if(request.getParameter("finishMapping") != null && request.getParameter("finishMapping").equals("true")){
		finishMapping = "true";
	} 
	String error = "";
	if (finishMapping.equals("true")){		
		// check, if a mandatory title field is given
		boolean constructContainsTitle = false;
		for (int i = 0; i < construct.getColumnsToIndex().length; i++){
			String fieldName = construct.getColumnsToIndex()[i].getTargetName();
			if (fieldName.equals("title")){
				constructContainsTitle = true;
			}
		}
		
		if (constructContainsTitle == true){
			response.sendRedirect(response.encodeRedirectURL("localRanking.jsp"));
		}else{
			error = "noTitleField";
		}
	}
%>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Mapping-&#x00DC;bersicht
		<br /><br />
		<span class="byline">		
		Sie sehen den Zwischstand des bisher get&#x00E4;tigten Mappings.<br />
		F&#x00FC;gen Sie solange weitere Tabellen hinzu, bis Sie alle Spalten gelistet haben, die Sie indizieren m&#x00F6;chten.<br />
		Danach k&#x00F6;nnen Sie die zu indizierenden Felder ausw&#x00E4;hlen und benennen. Speichern Sie das Mapping, wenn die Vorschau dem zu erwartenden Ergebnis entspricht.	
		</span>		
	</div>
	<br />
	<form method="post" action="<%=response.encodeURL("relationOverview.jsp")%>" name="localranking">
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
				</td>
				<td>
					<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
				</td>
				<td>
				<%if(construct.getColumnsToIndex().length > 0){ %>
				<td>
					<input type="hidden" name="finishMapping" value="true"/>
					<input type="submit" value="Weiter"/>
				</td>
				<%}%>
				</td>
			</tr>
		</table>	
	</form>	
	<%
	if (error.equals("noTitleField")){
	%>
	<br />
	<div class="error">
		Bitte vergeben Sie f&#x00FC;r eines der Indexfelder den Feldnamen "Allgemein --&gt; Titel, &#x00DC;berschrift", damit der Suchtreffer sp&#x00E4;ter korrekt dargestellt werden kann.<br />
		Empfehlenswert, aber optional ist auch die Vergabe von "Allgemein --&gt; Zusammenfassung, Abstrakt".
	</div>
	<br />
	<%}%>
	
	<%!
	public String renderTable(Table table, String relationString, int level, int motherTableId, int relationId, HttpServletResponse response){
		String  buffer = new String();
		buffer.concat("<table class=\"tableshort\" align=\"left\"");
		if (level%2 == 1) {
			buffer.concat(" bgcolor=\"#EEFAFF\"");	
		}else{
			buffer.concat(" bgcolor=\"#FFFFFF\"");
		}
		buffer.concat(">");

		// delete Relation Button
		if(table.getRelations().length == 0 && level > 0){
			buffer.concat("<tr><td align=\"center\">");
			buffer.concat("<form method=\"post\" action=\"");
			buffer.concat(response.encodeURL("deleteRelation.jsp"));
			buffer.concat("\">");
			buffer.concat("<input type=\"submit\" value=\"Relation l&#x00F6;schen\" class=\"button\"/>");
			buffer.concat("<input type=\"hidden\" name=\"tableId\" value=\"" +motherTableId +"\"/>");
			buffer.concat("<input type=\"hidden\" name=\"relationId\" value=\"" +relationId +"\"/>");								
			buffer.concat("</form>");
			buffer.concat("</td></tr>");
		}
		
		//		Print Relation
		if (relationString != null){
			buffer.concat("<tr><td class=\"relation\">" +relationString +"</td></tr>");
		}
		// Table Head
		buffer.concat("<tr><td class=\"tablehead\">"+table.getTableName()+"</td></tr>");
		// Columns of Table 		
		Column[] columns = table.getColumns();
		for (int i = 0; i < columns.length; i++) {
			String columnName = columns[i].getColumnName();
			buffer.concat("<tr><td class=\"tablecell\">");
			buffer.concat(columnName);			
			//Filter
			Filter[] filters = columns[i].getFilters();
			
			if(filters.length > 0){
				for(int j=0; j<filters.length; j++){
					Filter filter = filters[j];					
					buffer.concat("<form method=\"post\" action=\"");
					buffer.concat(response.encodeURL("deleteFilter.jsp"));
					buffer.concat("\">");
					buffer.concat("<input type=\"hidden\" name=\"columnId\" value=\""+columns[i].getId() +"\"/>");
					buffer.concat("<b>Filter: " +filter.getCompareSymbol() +" " +filter.getFilterValue() +"</b>&nbsp;");
					if(columns[i].filterIsRequired() == true && j < filters.length-1){
						buffer.concat("UND&nbsp;&nbsp;");
					}
					if(columns[i].filterIsRequired() == false && j < filters.length-1){
						buffer.concat("ODER&nbsp;&nbsp;");
					}
					buffer.concat("<input type=\"hidden\" name=\"filterIndex\" value=\""+j+"\"/>");
					buffer.concat("<input type=\"image\" src=\"");
					buffer.concat(response.encodeURL("gfx/delete.gif"));
					buffer.concat("\" title=\"Filter l&#x00F6;schen\" border=\"0\"/>");
					buffer.concat("</form>");
				}	
			}
			//	show targetName if it is a field for index
			if(columns[i].toIndex()){
				buffer.concat("<form method=\"post\" action=\"");
				buffer.concat(response.encodeURL("deleteFieldToIndex.jsp"));
				buffer.concat("\">");
				buffer.concat("<img src=\"");
				buffer.concat(response.encodeURL("gfx/okay.gif"));
				buffer.concat("\" border=\"0\" title=\"wird indiziert\" />");
				buffer.concat("<b>Index: " +columns[i].getTargetName() +"</b>&nbsp;");
				buffer.concat("<input type=\"hidden\" name=\"columnId\" value=\""+columns[i].getId() +"\"/>");
				buffer.concat("<input type=\"image\" src=\"");
				buffer.concat(response.encodeURL("gfx/delete.gif"));
				buffer.concat("\" title=\"Indexfeld l&#x00F6;schen\" border=\"0\"/>");
				buffer.concat("</form>");
			}
		
			
			buffer.concat("</td></tr>");
		}				
		buffer.concat("<tr><td align=\"center\">");
		
		// Filter Button
		buffer.concat("<form method=\"post\" action=\"");
		buffer.concat(response.encodeURL("addFilter.jsp"));
		buffer.concat("\">");
		buffer.concat("<input type=\"submit\" value=\"Filter hinzuf&#x00FC;gen\" class=\"button\"/>");
		buffer.concat("<input type=\"hidden\" name=\"tableId\" value=\"" +table.getId() +"\"/>");								
		buffer.concat("</form>");	
		
		// "weitere Tabellen" Button
		buffer.concat("<br /><form method=\"post\" action=\"");
		buffer.concat(response.encodeURL("addRelation.jsp"));
		buffer.concat("\" name=\"addRelation\">");				
		buffer.concat("<input style=\"font-size:x-small\" type=\"submit\" value=\"Weitere Tabelle mit dieser verkn&#x00FC;pfen\"/>");
		buffer.concat("<input type=\"hidden\" name=\"tableId\" value=\"" +table.getId() +"\"/>");
		buffer.concat("</form>&nbsp;");
		
		buffer.concat("</td></tr>");
		buffer.concat("<tr><td align=\"center\">");
		level = level +1; 
		// Child Tables
		Relation[] relations = table.getRelations();
		buffer.concat("<table><tr>");	
		for(int i=0; i< relations.length; i++){
				buffer.concat("<td valign=\"top\">&nbsp;");
				Relation relation = relations[i];
				Table rightTable = 	relation.getRightTable();
				
				String relationType = "";
				if (relation.getRelationType() == 0){
					relationType = "1:1";
				}else{
					relationType = "1:n";
				}
				relationString = "<div style=\"float:left\"><br />"+relationType+"</div>" +"<img src=\""+response.encodeURL("gfx/chainvertical.gif")+"\" align=\"left\"/>" +relation.getLeftColumn().toString() +" <br />=<br /> " +relation.getRightColumn().toString();
				
				buffer.concat(renderTable(rightTable, relationString, level, table.getId(), relation.getId(), response));
				buffer.concat("&nbsp;<td>");
			}
		buffer.concat("</tr></table>");
		buffer.concat("</td></tr></table>");
		return buffer.toString();	
	}
	%>
	
	<table>
		<tr>
			<td align="center" style="white-space:nowrap">
			<%=renderTable(construct.getRootTable(), null, 0, 0, 0, response)%>
			</td>
		</tr>
	</table>
	<form method="post" action="<%=response.encodeURL("selectIndexFields.jsp")%>" name="selectIndexFields">
		<input type="hidden" name="finishMapping" value="true"/>
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="submit" value="Indexfelder ausw&#x00E4;hlen und benennen"/>
				</td>
			</tr>
		</table>
	</form>
	<br />
	<form method="post" action="<%=response.encodeURL("localRanking.jsp")%>" name="localranking">
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
				</td>
				<td>
					<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
				</td>
				<td>
				<%if(construct.getColumnsToIndex().length > 0){ %>
				<td>
					<input type="hidden" name="finishMapping" value="true"/>
					<input type="submit" value="Weiter"/>
				</td>
				<%}%>
				</td>
			</tr>
		</table>	
	</form>
	<%if(construct.getColumnsToIndex().length > 0){ %>
		<br />
		<br />
		<% response.getWriter().flush(); %>
		<jsp:include page="sqlPreview.jsp"/>
		<% response.getWriter().flush(); %>
	
		<br />
		<br />
		<form method="post" action="<%=response.encodeURL("localRanking.jsp")%>" name="localranking">
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
				</td>
				<td>
					<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
				</td>
				<td>
				<%if(construct.getColumnsToIndex().length > 0){ %>
				<td>
					<input type="hidden" name="finishMapping" value="true"/>
					<input type="submit" value="Weiter"/>
				</td>
				<%}%>
				</td>
			</tr>
		</table>	
		</form>		
	<%}	%>	
</center>
</body>
<!-- ingrid-iplug-step2-dsc -->
</html>
