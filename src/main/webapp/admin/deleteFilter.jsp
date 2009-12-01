<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.utils.dsc.Filter"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ include file="timeoutcheck.jsp"%>
<%
int filterIndex = Integer.parseInt(request.getParameter("filterIndex"));
int columnId = Integer.parseInt(request.getParameter("columnId"));
Construct construct = (Construct)request.getSession().getAttribute("construct");
Column column = UiUtil.getColumnFromTables(construct.getTables(), columnId);
Filter[] filters = column.getFilters();
for(int i=0; i<filters.length; i++){
	Filter filter = filters[i];
	if(i == filterIndex){
		column.removeFilter(filter);
	}
}
response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
%>