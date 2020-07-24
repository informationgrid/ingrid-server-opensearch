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
<%@ page import="de.ingrid.utils.*"%>
<%@ page import="de.ingrid.utils.dsc.Record" %>
<%@ page import="de.ingrid.utils.dsc.Column" %>
<%@ page import="de.ingrid.utils.messages.*"%>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="de.ingrid.utils.dsc.*"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Details</title>
</head>
<body>



<%!
public String renderDetails (Record record, String buffer)throws Exception{
	
	CategorizedKeys catKeys = CategorizedKeys.get("/indexFieldNames.properties");
	int num = record.numberOfColumns();
	for(int i=0; i<num; i++){
		Column column = record.getColumn(i);
		String fieldName = catKeys.getString(column.getTargetName());
		// custom field names
		if(fieldName == null){
			fieldName = column.getTargetName();
		}

		if(column.toIndex()){
			buffer.concat("<tr>");
				buffer.concat("<td bgcolor=\"#F4F4F4\" style=\"font-face:Arial;font-size:12pt\">");
					buffer.concat(fieldName+":");
				buffer.concat("</td>");
				buffer.concat("<td bgcolor=\"#F4F4F4\" style=\"font-face:Arial;font-size:12pt\">");
					buffer.concat(record.getValueAsString(column)+"&nbsp;");
				buffer.concat("</td>");
			buffer.concat("</tr>");
		}		
	}	
	
	Record[] subRecords = record.getSubRecords();
	
	if(subRecords != null && subRecords.length > 0){		
		for(int j=0; j < subRecords.length; j++){
			buffer.concat("<tr><td colspan=\"2\">&nbsp;</td></tr>");
			renderDetails(subRecords[j], buffer);
		}		
	}
	
	return	buffer.toString();
}
%>



<%
//parameter
String plugId = "";
	if (request.getParameter("plugId")!= null){
		plugId = request.getParameter("plugId");
	}
int docId = 0;
	if (request.getParameter("docId")!= null){
		docId = Integer.parseInt(request.getParameter("docId"));
	}

// IngridHit	
IngridHit hit = new IngridHit();
hit.setDocumentId(docId);
hit.setPlugId(plugId);

Construct construct = (Construct)request.getSession().getAttribute("construct");
java.sql.Connection connection = (java.sql.Connection)request.getSession().getAttribute("connection");
PlugDescription   description = (PlugDescription)  request.getSession().getAttribute("description");
de.ingrid.iplug.dsc.index.DSCSearcher searcher = new de.ingrid.iplug.dsc.index.DSCSearcher();
searcher.configure(description);
Record record = searcher.getRecord(hit);


String buffer = new String();
%>
	
	<br />
	<table cellpadding="2" cellspacing="2" style="border:1px solid #959595" align="center">
		<%=renderDetails(record, buffer) %>
	</table>	

</body>
</html>
