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
    pageEncoding="utf-8"
	%>
<%@ page import="de.ingrid.iplug.dsc.schema.Table" %>
<%@ page import="de.ingrid.utils.dsc.Column"%>

<%
Table[] tables =  (Table[])request.getSession().getAttribute("tables");
%>	
		<%
		for (int i = 0; i < tables.length; i++) {
			Table table = tables[i];
		%>				
				<table class="table">
					<tr>
						<td colspan="2" class="tablehead">
							<%=table.getTableName()%>
						</td>
					</tr>
					<%
					Column[] columns = table.getColumns();
					for (int j = 0; j < columns.length; j++) {
						Column column = columns[j];
					%>		
					<tr>
						<td width="20" class="tablecell">							
							<input type="radio" name="columnId" value="<%=column.getId()%>"/>	
						</td>
						<td class="tablecell">
							<%=column.getColumnName()%>																					
						</td>
					</tr>
					<%}%>					
				</table>
				<br />				
		<%}%>		
