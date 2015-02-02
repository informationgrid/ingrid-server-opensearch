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
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.utils.dsc.Filter"%>
<%@ page import="de.ingrid.utils.dsc.Column" %>
<%@ page import="de.ingrid.iplug.util.*" %>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Filter definieren</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>

<body>
<%
Construct construct = (Construct)request.getSession().getAttribute("construct");
int tableId = Integer.parseInt(request.getParameter("tableId"));
Table table = (Table)UiUtil.getUniqueObjectById(construct.getTables(), tableId);
int columnId =  -1;

if(request.getParameter("columnId")!=null){
	columnId  =	Integer.parseInt(request.getParameter("columnId"));
}

if (request.getParameter("process")!=null) {
	
	Column column = (Column)UiUtil.getUniqueObjectById(construct.getColumns(), columnId);
	String filterValue = request.getParameter("filterValue");
	String required = WebUtil.getParameter(request, "required", "");
	int filterCondition = Integer.parseInt(request.getParameter("filterCondition")) ;
	Filter filter = new Filter(filterCondition, filterValue );
	column.addFilter(filter);
	if(required.equals("true")){
		column.setFilterIsRequired(true);
	}
	if(required.equals("false")){
		column.setFilterIsRequired(false);
	}

	response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));	
}
%>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Filter hinzuf&#x00FC;gen<br /><br />
		<span class="byline">
		Zus&#x00E4;tzlich zu den Relationen k&#x00F6;nnen Sie Filter definieren, die das Ergebnis auf Felder beschr&#x00E4;nken, die einen definierten Wert haben.
		</span>		
	</div>
	<br />
	
	<%
	String error = request.getParameter("error");
	if (error != null) {
	%>
		<br />
		<div class="error">Bitte definieren Sie einen Filterwert!</div>
		<br />
	<%}%>
	
			<form method="post" action="<%=response.encodeURL("addFilter.jsp")%>">							
			<table class="table" style="width:auto">
					<tr>
						<td class="tablehead" colspan="2">
							<%=table.getTableName()%>
						</td>
					</tr>					
					<%
					Column[] columns = table.getColumns();
					for (int j = 0; j < columns.length; j++) {
						Column column = columns[j];						
					%>		
					<tr>
						<td class="tablecell">							
							<%=column.getColumnName() %>														
						</td>
						<%if (columnId == -1) { %>							
							<td>
							<%
							Filter[] filters = column.getFilters();
							if(filters.length > 0){
								for(int k=0; k<filters.length; k++){
									Filter filter = filters[k];
							%>
								<b>Filter: <%=filter.getCompareSymbol()%> <%=filter.getFilterValue()%></b>
								<%if(k != filters.length-1 && column.filterIsRequired() == true){ %>
								 UND
								<%}%>
								<%if(k != filters.length-1 && column.filterIsRequired() == false){ %>
								 ODER
								<%}%>
								<br />
								<%}%>
							<%}%>
								<form method="post" action="<%=response.encodeURL("addFilter.jsp")%>">
									<input type="hidden" name="tableId" value="<%=table.getId()%>"/>
									<input type="hidden" name="columnId" value="<%=column.getId()%>"/>
									<input type="submit" value="Filter definieren"/>
								</form>
							</td>
						<%}else{%>
							<%if (columnId == column.getId()) {%>							
								<td class="tablecell">
									Mehrere Filter f&#x00FC;r diese Spalte werden verkn&#x00FC;pft mit:
									<select name="required">
										<option value="true" <%if(column.filterIsRequired() == true){ %> selected<%}%>>UND</option>
										<option value="false" <%if(column.filterIsRequired() == false){ %> selected<%}%>>ODER</option>
									</select>
									<br /><br />
									<select name="filterCondition" >
										<option value="0">ist gleich</option>
										<option value="3">ist ungleich</option>
										<option value="1">ist gr&#x00F6;&#x00DF;er als</option>
										<option value="2">ist kleiner als</option>
									</select>
									<input name="filterValue" type="text" size="20" value=""/>
									<input type="hidden" name="process" value="true"/>
									<input type="hidden" name="tableId" value="<%=table.getId()%>"/>
									<input type="hidden" name="columnId" value="<%=column.getId()%>"/>
									<input type="hidden" name="error" value="uncompleted"/>
									<input type="submit" value="Anlegen und weiter"/>	
								</td>
							<%}else{%>
								<td colspan="2" class="tablecell">&nbsp;</td>
							<%} %> 
						<%} %>
					</tr>
					<%}%>													
				</table>
				<table class="table" align="center">					
					<tr align="center">
						<td>
							<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
						</td>
						<td>
							<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
						</td>
					</tr>
				</table>
			</form>
</center>
</body>
<!-- ingrid-iplug-admin-step2-dsc -->
</html>
