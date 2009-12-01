<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<%
int relationId = Integer.parseInt(request.getParameter("relationId"));
int tableId= Integer.parseInt(request.getParameter("tableId"));
Construct construct = (Construct)request.getSession().getAttribute("construct");
Table table = (Table)UiUtil.getUniqueObjectById(construct.getTables(), tableId);
Relation relation = (Relation)UiUtil.getUniqueObjectById(table.getRelations(),relationId ); 
table.removeRelation(relation);

response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
%>