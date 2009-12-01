<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
	%>
<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>

<%
Table[] tables = (Table[])request.getSession().getAttribute("tables");
int tableId = Integer.parseInt(request.getParameter("tableId"));

Construct  construct = (Construct) request.getSession().getAttribute("construct");
Table table = (Table)UiUtil.getUniqueObjectById(construct.getTables(), tableId);


%>	
<%
	Column[] columns = table.getColumns();
	for (int j = 0; j < columns.length; j++) {
		Column column = columns[j];
	%>		
	<tr>
		<td class="tablecell">
			&nbsp;
		</td>
		<td class="tablecell">
			<%=column.getColumnName() %>														
		</td>
		<td width="20" class="tablecell">							
			<input type="radio" name="leftColumnId" value="<%=column.getId()%>"/>							
		</td>
	</tr>
<%}%>					
				
	
	