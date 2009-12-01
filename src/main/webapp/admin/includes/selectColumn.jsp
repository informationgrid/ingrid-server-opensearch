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
