<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.iplug.*"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<%
Construct construct = (Construct)request.getSession().getAttribute("construct");
PlugDescription  description = (PlugDescription)request.getSession().getAttribute("description");

Column[] columnsToIndex = (Column[])construct.getColumnsToIndex();
for(int i = 0; i < columnsToIndex.length;i++){
	description.addField(columnsToIndex[i].getTargetName());
}

description.put("construct", construct);
response.sendRedirect(response.encodeRedirectURL("selectDetailView.jsp"));
%>
