<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 - 2018 wemove digital solutions GmbH
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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="de.ingrid.iplug.util.*" %>   
<%@ page import="de.ingrid.iplug.dsc.index.*" %>
<%@ page import="de.ingrid.utils.dsc.*" %>
<%@ page import="de.ingrid.iplug.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="de.ingrid.utils.*"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<%
IngridHits documents = null;
String query = WebUtil.getParameter(request, "query", "");
String subrecordsParam = WebUtil.getParameter(request, "subrecordsParam", "");
AbstractSearcher searcher = AbstractSearcher.getInstance();
PlugDescription description = null;
if(searcher == null) {
	searcher = new DSCSearcher();
	BeanFactory beanFactory = (BeanFactory) application.getAttribute("beanFactory");
	File pd_file = (File) beanFactory.getBean("pd_file");
	description = PlugServer.getPlugDescription(pd_file.getAbsolutePath());
	description.put("PLUGDESCRIPTION_FILE", pd_file.getAbsolutePath());
} else {
	description = searcher.refresh();
}

searcher.configure(description);
if(!query.equals("")){
	documents =  searcher.search(de.ingrid.utils.queryparser.QueryStringParser.parse(query),0, 10);	
}
%>

<%!
public String k (Record record, String buffer, String subrecordsParam) throws Exception{
	// int count = 0;
	HashSet targetNamesSet = new java.util.HashSet();
	int num = record.numberOfColumns();
		for(int i=0; i < num; i++){
			Column column = record.getColumn(i);
			String targetName = column.getTargetName();
			
			if(column.toIndex() && !targetNamesSet.contains(targetName)){
				targetNamesSet.add(targetName);
			}
		}		
	renderHeader(record, buffer, targetNamesSet, subrecordsParam);
	renderRow(record, buffer, targetNamesSet, subrecordsParam);		
	return	buffer.toString();
}

public void renderHeader(Record record, String buffer, HashSet targetNamesSet, String subrecordsParam){
	buffer.concat("<tr>");	
	java.util.Iterator itr = targetNamesSet.iterator();
	
	Record[] subRecords  = record.getSubRecords();
	
	float columnWidth = 100 / targetNamesSet.size();
	if (subRecords!=null && subRecords.length > 0 && !subrecordsParam.equals("") ) {
		columnWidth = 100 / (targetNamesSet.size()+1);
	}
	
	while (itr.hasNext()) {
		String myTargetName = itr.next().toString();
		buffer.concat("<td style=\"background-color:#959595;color:#FFFFFF;font-weight:bold;width:"+columnWidth+"%\">");
		buffer.concat(myTargetName);
		buffer.concat("</td>");
	}
	
	if (subRecords!=null && subRecords.length > 0 && !subrecordsParam.equals("") ) {
		buffer.concat("<td style=\"background-color:#959595;color:#FFFFFF;font-weight:bold;width:"+columnWidth+"%\">Subrecords (1:n)</td>");
	}
	buffer.concat("</tr>");	
}

public void getValuesFromRecord(Record record, String buffer, HashSet targetNamesSet) {
	java.util.Iterator itr = targetNamesSet.iterator();	
	while (itr.hasNext()) {
		String myTargetName = itr.next().toString();
		boolean hasValue = false;
		for(int i=0; i < record.numberOfColumns(); i++){		
			Column column = record.getColumn(i);
			String columnTargetName = column.getTargetName();
			
						
			if (columnTargetName.equals(myTargetName)){				
					String value = record.getValueAsString(column);					
					if (value.length() > 100) {
						value = value.substring(0,100)+" ...";
					}
					buffer.concat("<td bgcolor=\"#FFFFFF\">" +value +"&nbsp;</td>");
					hasValue = true;
			}			
		}
		
		if (hasValue == false){				
			buffer.concat("<td bgcolor=\"#FFFFFF\">&nbsp;-&nbsp;</td>");
		}
		
	}
}

public void renderRow(Record record, String buffer, HashSet targetNamesSet, String subrecordsParam) {
	buffer.concat("<tr>");	
	
	getValuesFromRecord(record, buffer, targetNamesSet);
	
	Record[] subRecords  = record.getSubRecords();
	if(subRecords!=null && subRecords.length > 0 && !subrecordsParam.equals("")){		
		buffer.concat("<td bgcolor=\"#FFFFFF\">");		
		buffer.concat("<table bgcolor=\"#F4F4F4\" cellpadding=\"2\" cellspacing=\"2\" style=\"border:1px solid #959595\"");
		
		HashSet subTargetNamesSet = new java.util.HashSet();
		getSubrecordsTargetNames(record, buffer, subTargetNamesSet, subrecordsParam);		
		
		for(int j =0; j < subRecords.length; j++){
			Record oneRecord = subRecords[j];
			if (j == 0){
				renderHeader(oneRecord, buffer, subTargetNamesSet, subrecordsParam);
			}						
			renderRow(oneRecord, buffer, subTargetNamesSet, subrecordsParam);			
		}
		
		buffer.concat("</table>");
		buffer.concat("</td>");
	}
	buffer.concat("</tr>");
}

public HashSet getSubrecordsTargetNames(Record record, String buffer, HashSet subTargetNamesSet, String subrecordsParam) {
	//sub records
	Record[] subRecords  = record.getSubRecords();

	if(subRecords!=null && !subrecordsParam.equals("")){		
		// collect all possible targetNames
		for(int i =0; i < subRecords.length; i++){
			Record oneRecord = subRecords[i];
			int num = subRecords[i].numberOfColumns();
			for (int j=0; j < num; j++) {
				Column column = oneRecord.getColumn(j);
				String targetName = column.getTargetName();				
				if (column.toIndex() && !subTargetNamesSet.contains(targetName)) {
					subTargetNamesSet.add(targetName);
					buffer.concat(targetName);
				}
			}
		}
		
	}
	return subTargetNamesSet;	
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="de.ingrid.utils.xml.XMLSerializer"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Suchen</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a>
		<br />Index testen<br /><br />
		<span class="byline">Sie k&#x00F6;nnen Suchabfragen formulieren, um den Index zu testen. Es werden nur die ersten 10 Treffer dargestellt.</span>
</div>
<br />
<form method="post" action="<%=response.encodeURL("finish.jsp")%>" name="finish">
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
<form method="post" action="<%=response.encodeURL("search.jsp")%>" name="search">
	<input type="text" name="query" value="<%=query%>"/>	
	<input type="submit" value="Suchen"/>
	<!--<br /><input type="checkbox" name="subrecordsParam" value="true" <%if(!subrecordsParam.equals("")){%>checked="checked"<%}%>/> 
	<span class="metadata">Subrecords (1:n) darstellen</span> -->
</form>
</center>
<%
PlugDescription descrition = (PlugDescription) request.getSession().getAttribute("description");
%>
<!--
<table class="table" align="center">					
	<tr align="center">
		<td>
			<font color="#CCCCCC">
			Indextest f&#x00FC;r : 
			<%=description.getDataSourceName() %><br />
			<%=description.getDataSourceDescription() %><br />
			<%=description.getOrganisation() %>
			</font>
			<br />
		</td>
	</tr>
</table>
-->
<%
if(documents!=null){
	%>
	<div style="text-align:center;font-weight:bold">Treffer: <%=documents.length() %></div><br /><br />
	<table align="center"><tr><td>
	<%
	IngridHit[] hits = documents.getHits();
	
	for(int i  = 0; i < hits.length; i++){		
		IngridHit hit = hits[i];
		IngridHitDetail detail = searcher.getDetail(hit,de.ingrid.utils.queryparser.QueryStringParser.parse(query), new String[0]);
		int docId = detail.getDocumentId();
		String plugId = descrition.getPlugId();
		String url = (String) detail.get("url");
	%>	
		<%if(url==null){ %>
			<b><%=i+1%>. <a href="<%=response.encodeURL("searchDetails.jsp?plugId="+plugId+"&docId="+docId)%>"><b><%=detail.getTitle() %></b></a><br /></b><br />
		<%}else{ %>
			<b><%=i+1%>. <a href="<%=response.encodeURL(url)%>" target="_blank"><%=detail.getTitle() %></b></a><br /></b><br />
		<%} %>
		<%=detail.getSummary() %><br />
		<font color="#959595"><b>Ranking:</b> <%=detail.getScore() %>, <b>Dokument Id:</b> <%=detail.getDocumentId() %></font><br /><br />

	<%}%>
	</td></tr></table>
<%}%>

<br />
<br />
<center>
<form method="post" action="<%=response.encodeURL("finish.jsp")%>" name="finish">
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
</center>
</body>
</html>
