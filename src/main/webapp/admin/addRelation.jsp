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
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="de.ingrid.utils.dsc.*"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.utils.PlugDescription" %>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Relation zuf&#x00FC;gen</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Relation hinzuf&#x00FC;gen<br /><br />
		<span class="byline">
<!--		
		<div style="text-align:right">
			<form method="get" action="<%=response.encodeURL("relationOverview.jsp")%>">
				<input type="submit" value="Abbrechen" class="button"/>
			</form>			
		</div>
-->		
		Bitte definieren Sie f&#x00FC;r beide Seiten, wie Sie diese verkn&#x00FC;pfen m&#x00F6;chten.
		</span>		
	</div>
	<br />
	<%
	Construct construct = (Construct)request.getSession().getAttribute("construct");	
	Table[] tables = (Table[])request.getSession().getAttribute("tables");	

	int tableId = Integer.parseInt(request.getParameter("tableId")); 	
	Table table = (Table)UiUtil.getUniqueObjectById(construct.getTables(), tableId);
	if(table == null){
		table = construct.getRootTable();
	}
	
	if (request.getParameter("leftColumnId") != null && request.getParameter("columnId") != null && request.getParameter("relation") != null) {
		
		int leftColumnId = Integer.parseInt(request.getParameter("leftColumnId"));
		int rightColumnId = Integer.parseInt(request.getParameter("columnId"));
		Table leftTable =  UiUtil.getTableContainsColumn(construct.getTables(), leftColumnId);
		if(construct.getTables().length==1){
			leftTable  = construct.getRootTable();
		} 

		
		Column leftColumnOrg = UiUtil.getColumnFromTables(construct.getTables(), leftColumnId);
		Column rightColumnOrg = UiUtil.getColumnFromTables(tables, rightColumnId);
		
		Table rightTable =(Table) UiUtil.deepClone(UiUtil.getTableContainsColumn(tables, rightColumnId));
		Column rightColumn =  rightTable.getColumnByName(rightColumnOrg.getColumnName());
		Column leftColumn = leftTable.getColumnByName(leftColumnOrg.getColumnName());
		
		// relation
		int relationType = Relation.ONE_TO_ONE;
		if (request.getParameter("relation").equals("oneToMany")) {
			relationType = Relation.ONE_TO_MANY;
		}
		
		
		Relation relation = new Relation(leftColumn, rightTable, rightColumn, relationType);
		leftTable.addRelation(relation);
		response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
	}
	%>
	
	<%
	String error = request.getParameter("error");
	if (error != null) {
	%>
		<br />
		<div class="error">Bitte w&#x00E4;hlen Sie auf beiden Seiten die Verkn&#x00FC;pfung aus!</div>
	<%}%>	
	<br />
	<form method="get" action="<%=response.encodeURL("addRelation.jsp?error=nothingSelected")%>">
	<input type="hidden" name="error" value="nothingSelected"/>	
	<input type="hidden" name="tableId" value="<%=tableId%>"/>	
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
	<br />
	<input type="hidden" name="error" value="nothingSelected"/>	
	<input type="hidden" name="tableId" value="<%=tableId%>"/>	
	<table width="860">
		<tr>
			<td width="400" class="tablehead" align="center"><br />Linke Seite<br /><br /></td>
			<td width="60" align="center"><img src="<%=response.encodeURL("gfx/chain.gif")%>"/></td>
			<td width="400" class="tablehead" align="center"><br />Rechte Seite<br /><br /></td>
		</tr>
		<tr>
			<td width="400" valign="top">
				<br />
				<table class="table">
					<tr>

						<td class="tablehead" colspan="3"><%=table.getTableName() %></td>
					</tr>						
					<jsp:include page="includes/getColumnsFromTableForm.jsp">
						<jsp:param name="tableId" value="<%=tableId%>"/>
					</jsp:include>
				</table>			
			</td>
			<td width="60" valign="top">
				<select name="relation">
					<option value="oneToOne">1:1</option>
					<option value="oneToMany">1:n</option>
				</select> 
			</td>
			<td width="400">
				<br />
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
					<input type="submit" value="Weiter" />
				</td>
			</tr>
		</table>
	</form>
	<br />
</center>
</body>
<!-- ingrid-iplug-admin-step2-dsc -->
</html>
