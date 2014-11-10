<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 wemove digital solutions GmbH
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
<%@ page import="de.ingrid.iplug.dsc.schema.RecordReader"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="de.ingrid.utils.dsc.*"%>
<%@ page import="de.ingrid.utils.dsc.Record"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ page import="de.ingrid.iplug.dsc.index.DatabaseConnection"%>
<%@ include file="timeoutcheck.jsp"%>
<%
PlugDescription description = (PlugDescription) request.getSession().getAttribute("description");
Construct construct = (Construct)request.getSession().getAttribute("construct");
java.sql.Connection connection = (java.sql.Connection)request.getSession().getAttribute("connection");
DatabaseConnection databaseConnection = (DatabaseConnection) description.getConnection();
String schema = databaseConnection.getSchema();
RecordReader reader = new  RecordReader(construct, connection, schema, databaseConnection.getConnectionURL(),
                      databaseConnection.getUser(), databaseConnection.getPassword());
%>

<%!
public void renderTable (RecordReader reader, java.io.PrintWriter printWriter)throws Exception{
	int count = 0;
	//StringBuffer buffer = new StringBuffer();
	Record record;
	HashSet targetNamesSet = new java.util.HashSet();
	
	while((record = reader.nextRecord())!=null){
		
		int num = record.numberOfColumns();
		if(count++>9){
			break;
		}
		for(int i=0; i < num; i++){
			Column column = record.getColumn(i);
			String targetName = column.getTargetName();
			
			if(column.toIndex()  && !targetNamesSet.contains(targetName)){
				targetNamesSet.add(targetName);
			}
		}		
		if(count==1){
			renderHeader(record, printWriter, targetNamesSet);
		}		
		renderRow(record, printWriter, targetNamesSet);		
	}	
	printWriter.flush();

}

public void renderHeader(Record record, java.io.PrintWriter printWriter, HashSet targetNamesSet)throws Exception{
	printWriter.write("<tr>");	
	java.util.Iterator itr = targetNamesSet.iterator();
	while (itr.hasNext()) {
		String myTargetName = itr.next().toString();
		printWriter.write("<td style=\"background-color:#959595;color:#FFFFFF;font-weight:bold\">");
		printWriter.write(myTargetName);
		printWriter.write("</td>");
	}
	Record[] subRecords  = record.getSubRecords();
	if (subRecords!=null && subRecords.length > 0) {
		printWriter.write("<td style=\"background-color:#959595;color:#FFFFFF;font-weight:bold\">Subrecords (1:n)</td>");
	}
	printWriter.write("</tr>");
	printWriter.flush();
	
}

public void getValuesFromRecord(Record record, java.io.PrintWriter printWriter, HashSet targetNamesSet) throws Exception {
	java.util.Iterator itr = targetNamesSet.iterator();	
	while (itr.hasNext()) {
		String myTargetName = itr.next().toString();
		boolean hasValue = false;
		String value = "";
		for(int i=0; i < record.numberOfColumns(); i++){		
			Column column = record.getColumn(i);
			String columnTargetName = column.getTargetName();

			if (columnTargetName.equals(myTargetName) && column.toIndex()){				
					 value = value +" "+record.getValueAsString(column);					
					if (value.length() > 100) {
						value = value.substring(0,100)+" ...";
					}
					//buffer.append("<td bgcolor=\"#FFFFFF\">" +java.net.URLEncoder.encode(value) +"&nbsp;</td>");					
					hasValue = true;
			}			
		}
		if(hasValue){
			printWriter.write(("<td bgcolor=\"#FFFFFF\">" +value +"&nbsp;</td>"));
		} else {				
			printWriter.write("<td bgcolor=\"#FFFFFF\">&nbsp;-&nbsp;</td>");
		}
		printWriter.flush();	
	}
	printWriter.flush();
	
}

public void renderRow(Record record, java.io.PrintWriter printWriter, HashSet targetNamesSet)throws Exception {
	printWriter.write("<tr>");	
	
	getValuesFromRecord(record, printWriter, targetNamesSet);
	
	Record[] subRecords  = record.getSubRecords();
	if(subRecords!=null && subRecords.length > 0){		
		printWriter.write("<td bgcolor=\"#FFFFFF\">");		
		printWriter.write("<table bgcolor=\"#F4F4F4\" cellpadding=\"2\" cellspacing=\"2\" style=\"border:1px solid #959595\"");
		
		HashSet subTargetNamesSet = new java.util.HashSet();
		getSubrecordsTargetNames(record, printWriter, subTargetNamesSet);		
		
		for(int j =0; j < subRecords.length; j++){
			Record oneRecord = subRecords[j];
			if (j == 0){
				renderHeader(oneRecord, printWriter, subTargetNamesSet);
			}						
			renderRow(oneRecord, printWriter, subTargetNamesSet);			
		}
		
		printWriter.write("</table>");
		printWriter.write("</td>");
	}
	printWriter.write("</tr>");
	printWriter.flush();
}

public HashSet getSubrecordsTargetNames(Record record, java.io.PrintWriter printWriter, HashSet subTargetNamesSet) throws Exception {
	//sub records
	Record[] subRecords  = record.getSubRecords();

	if(subRecords!=null && subRecords.length > 0){		
		// collect all possible targetNames
		for(int i =0; i < subRecords.length; i++){
			Record oneRecord = subRecords[i];
			int num = subRecords[i].numberOfColumns();
			for (int j=0; j < num; j++) {
				Column column = oneRecord.getColumn(j);
				String targetName = column.getTargetName();				
				if (column.toIndex() && !subTargetNamesSet.contains(targetName)) {
					subTargetNamesSet.add(targetName);
					printWriter.write(targetName);
				}
			}
		}
		
	}
	return subTargetNamesSet;	
}
%>
 
<% 
java.io.PrintWriter writer = response.getWriter();
writer.write("<div style=\"background-color:#F4F4F4\">");
writer.write("<br />");
writer.write("<b>Index-Vorschau:</b>");
writer.write("<table bgcolor=\"#F4F4F4\" cellpadding=\"2\" cellspacing=\"2\" style=\"border:1px solid #959595\">");
writer.flush();
try{
renderTable(reader, writer); 
} catch (Exception e) {
	e.printStackTrace();
}

writer.write("</table>");
writer.write("<br /><br />");
writer.write("</div>");
%>




<%reader.close(); %>
