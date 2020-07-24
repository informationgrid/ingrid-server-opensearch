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

<%@ page import="de.ingrid.utils.messages.*" %>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="java.util.*"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ page import="de.ingrid.iplug.util.WebUtil" %>
<%@ page import="java.io.InputStream" %>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Benennung der Indexfelder</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<center>
	<%
		InputStream resourceAsStream = getClass().getClassLoader().getResourceAsStream("/indexFieldNames.properties");
	
		HashSet hashSet = new HashSet();
		Construct construct = (Construct) request.getSession().getAttribute("construct");
		String[] fieldsToIndex = (String[])request.getSession().getAttribute("fields");
		String error = "";
		
		String ignoreDuplicates = WebUtil.getParameter(request, "ignoreDuplicates", "false");
		
		CategorizedKeys catKeys = CategorizedKeys.get("indexFieldNames.properties",resourceAsStream);
		String[] categories = catKeys.getCategories();
		
		if (request.getParameter("start")==null){
			
			Enumeration  enumeration = request.getParameterNames();			
			Column[]  columns = construct.getColumnsToIndex();
			for(int i=0; i<columns.length; i++){
				Column column = columns[i];
				String key = column.getTargetName();
				hashSet.add(key);
			}
			boolean duplicateNames = false;
			while(enumeration.hasMoreElements()){
				String key = (String)enumeration.nextElement();
				if(!key.equals("fields") && !key.equals("start") && !key.equals("ignoreDuplicates") && !key.endsWith("_indexfieldtype")){
					String[] values = request.getParameterValues(key);
					 String value = "";
					 for(int j=0; j<values.length; j++){
						 if(!values[j].equals("")){
							 value = values[j];
						 }
					 }
					//System.out.println("key "+key +" | value: "+value);
					if(value!=null && !value.equals("") && ignoreDuplicates.equals("false")){
						if(hashSet.contains(value)){
							error = "duplicateNames";
							duplicateNames = true;
							ignoreDuplicates = "true";
						} else {
							hashSet.add(value);
						}
					}
				}
			}
			
		if(!duplicateNames){
			enumeration = request.getParameterNames();			
			while(enumeration.hasMoreElements()){
				String key = (String)enumeration.nextElement();
				if(!key.equals("fields") && !key.equals("start") && !key.equals("ignoreDuplicates")){
					String[] values = request.getParameterValues(key);
					 String value = "";
					 for(int j=0; j<values.length; j++){
						 if(!values[j].equals("")){
							 value = values[j];
						 }
					 }
					 String[] types = request.getParameterValues(key + "_indexfieldtype");
					 String type = "";
 					 if(types != null) {
						 for(int j=0; j<types.length; j++){
							 if(!types[j].equals("")){
								 type = types[j];
							 }
						 }
					 }
					//System.out.println("key2 "+key +" | value2: "+value);
					if (value!=null && !value.equals("")) {
						if (!key.endsWith("_indexfieldtype")) {
							Column column = (Column)UiUtil.getUniqueObjectById(construct.getColumns(), Integer.parseInt(key));
							column.addToIndex(true);
							value = value.replaceAll(" ","_");							
							value = value.replaceAll("&#x00E4;","ae");
							value = value.replaceAll("&#x00F6;","oe");
							value = value.replaceAll("&#x00FC;","ue");
							value = value.replaceAll("&#x00C4;","Ae");
							value = value.replaceAll("&#x00D6;","Oe");
							value = value.replaceAll("&#x00DC;","Ue");
							value = value.replaceAll("&#x00DF;","ss");
							column.setTargetName(value);
							column.setType(type);
						}
					} else {
						error = "notAllSelected";
					}
				}
			}
		}
			if(error.equals("")){				
				response.sendRedirect(response.encodeRedirectURL("relationOverview.jsp"));
			}
		}
	%>
	
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Index-Feldnamen vergeben
		<br /><br />
		<span class="byline">
		Benennen Sie die Indexfelder! Die Werte der Felder werden im Index in einem Feld mit diesem Namen hinterlegt. <br /><br />
		Bitte vergeben Sie f&#x00FC;r eines Ihrer Datenbankfelder den Indexfeldnamen <b>"Allgemein --> Titel / &#x00DC;berschrift"</b>. 
		Empfohlen wird auch die Vergabe von <i>"Allgemein --> Zusammenfassung / Abstrakt"</i>. 
		Beide Felder dienen der sp&#x00E4;teren Darstellung in der Trefferliste des Portals.<br /><br />
		Bitte verwenden Sie <b>immer wenn m&#x00F6;glich UDK-Attributnamen</b>, da "Eigene Namen" nicht &#x00FC;ber den erweiterten Querysyntax des Portals abgedeckt werden k&#x00F6;nnen.		
		<br />
		Bitte beachten Sie, dass Sie bei der Vergabe von eigenen Indexfeldnamen keine Sonderzeichen zu verwenden. Umlaute und "&#x00DF;" werden ersetzt (&#x00E4;->ae, &#x00FC;->ue, &#x00F6;->oe, &#x00DF;->ss).
		<br />
		</span>		
	</div>
	<br />
	<form method="post" action="<%=response.encodeURL("nameIndexFields.jsp")%>">
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
			<input type="hidden" name="ignoreDuplicates" value="<%=ignoreDuplicates%>" />
		</td>
	</tr>
	</table>
	<br />	
	
	<%
	if (error.equals("notAllSelected")) {
	%>
		<br />
		<div class="error">Bitte vergeben Sie f&#x00FC;r jedes Feld einen Namen!</div>
		<br />
	<%}%>
	<%
	if (error.equals("duplicateNames")) {
	%>
		<br />
		<div class="error">
			Sie hinterlegen verschiedene Datenbankfelder in Indexfeldern gleichen Namens.
			Sie k&#x00F6;nnen Ihre Eingaben korrigieren oder trotzdem speichern, wenn dies gewollt ist.<br />		
		 </div>
		<br />
	<%}%>
	
	<table class="table">
			<tr>
				<td class="tablehead"/>Feld</td>
				<td class="tablehead"/>Name</td>
				<td class="tablehead"/>Typ</td>
				<td class="tablehead"/>oder Eigener Name</td>
			</tr>
			<%			
			for(int i=0; i < fieldsToIndex.length; i++){
				Column column = (Column)UiUtil.getUniqueObjectById(construct.getColumns(), Integer.parseInt(fieldsToIndex[i]));
			%>
			<tr>
				<td class="tablecell" style="white-space:no-wrap">
					<%=column.toString()%>
				</td>
				<td class="tablecell">
					<%
					String[] myValues = request.getParameterValues(fieldsToIndex[i]);					
					String myValue = "";
					if(myValues != null) {
						for (int j=0; j < myValues.length; j++){
							if (!myValues[j].equals("")){
								myValue = myValues[j];
							}
						}
					}
										
					%>
					<select name="<%=fieldsToIndex[i]%>">
						<option value="">--bitte w&#x00E4;hlen--</option>
						<optgroup label="Allgemein">
							<option value="title" style="color:#176798;font-weight:bold" <%if(myValue.equals("title")){%> selected="selected"<%}%>>Titel, &#x00DC;berschrift</option>
							<option value="summary" style="color:#176798;font-weight:bold" <%if(myValue.equals("summary")){%> selected="selected"<%}%>>Zusammenfassung, Abstrakt</option>
						</optgroup>
					<%
						for(int k=0;k < categories.length; k++){
							String category = categories[k];
							String[] keys = catKeys.getKeysForCategory(category);
						%>
						
							<optgroup label="<%=category %>">
								<%
								for(int l=0; l < keys.length; l++){
									String key = keys[l];
								%>
								<option value="<%=key%>" <%if(myValue.equals(key)){%> selected="selected"<%}%>><%=catKeys.getString(key)%></option>
								<%}%>
							</optgroup>
						<%}%>
					</select>
				</td>
				<td class="tablecell">
					<%
					String[] myTypes = request.getParameterValues(fieldsToIndex[i] + "_indexfieldtype");
					String myType = "";
					if(myTypes != null) {
						for (int j=0; j < myTypes.length; j++){
							if (!myTypes[j].equals("")){
								myType = myTypes[j];
							}
						}
					}
					%>
					<select name="<%=fieldsToIndex[i] + "_indexfieldtype"%>">
							<option value="<%=Column.TEXT%>" <%if(myType.equals(Column.TEXT)){ %> selected="selected"<%}%>>Text</option>
					        <option value="<%=Column.KEYWORD%>" <%if(myType.equals(Column.KEYWORD)){ %> selected="selected"<%}%>>Keyword</option>
    			            <option value="<%=Column.DATE%>" <%if(myType.equals(Column.DATE)){ %> selected="selected"<%}%>>Date</option>	        	    		
	                </select>
				</td>
				<td class="tablecell">
					<%
					String[] myCustomValues = request.getParameterValues(fieldsToIndex[i]);
					String myCustomValue = "";
					if(myCustomValues != null){
						for(int k=0; k < myCustomValues.length; k++){
							if(!myCustomValues[k].equals("") && catKeys.getString(myCustomValues[k]) == null ) {
								myCustomValue = myCustomValues[k];
							}
						}
					}
					%>
					<input type="text" name="<%=fieldsToIndex[i]%>" value="<%=myCustomValue%>"/>
				</td>
			</tr>			
			<%}%>		
		</table>
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
					<input type="hidden" name="ignoreDuplicates" value="<%=ignoreDuplicates%>" />
				</td>
			</tr>
		</table>
	</form>
</center>
</body>
</html>
