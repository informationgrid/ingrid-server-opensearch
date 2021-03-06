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
