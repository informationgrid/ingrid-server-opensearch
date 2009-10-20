<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<%
int columnId = Integer.parseInt(request.getParameter("columnId"));
Construct construct = (Construct)request.getSession().getAttribute("construct");
Column column = UiUtil.getColumnFromTables(construct.getTables(), columnId);
column.addToIndex(false);

response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
%>