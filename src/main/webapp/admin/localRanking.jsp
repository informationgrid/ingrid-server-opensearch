<%--
  **************************************************-
  Ingrid Server OpenSearch
  ==================================================
  Copyright (C) 2014 - 2016 wemove digital solutions GmbH
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
<%@ page import="java.util.*"%>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ page import="de.ingrid.utils.dsc.UniqueObject"%>
<%@ page import="de.ingrid.iplug.dsc.util.UiUtil" %>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ include file="timeoutcheck.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Ranking</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
</head>
<body>
<%

Construct construct = (Construct) request.getSession().getAttribute("construct");
Column[] columns = construct.getColumns();
if(request.getParameter("process") != null) {
	Enumeration enumeration = request.getParameterNames();
	while(enumeration.hasMoreElements()){
		String key = (String) enumeration.nextElement();
		try{
			long longKey = Long.parseLong(key);
			Column column = (Column) UiUtil.getUniqueObjectById(columns, (int)longKey );
			float value =Float.parseFloat(request.getParameter(key));
			column.setBoost(value);
		}catch (Exception e )
		{
			// nothing
		}
	}
	response.sendRedirect(response.encodeRedirectURL("saveMapping.jsp"));
	}
%>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Ranking<br /><br />
		<span class="byline">
		Wenn Sie nicht w&#x00FC;nschen, dass die Inhalte aller Indexfelder w&#x00E4;hrend der Suche gleich gewichtet werden, k&#x00F6;nnen Sie die Rankingfaktoren f&#x00FC;r einzelne Felder anpassen.<br />
		Das Ranking eines Feldes mit einem Wert kleiner 1 bewirkt, dass dieses Feld im Vergleich zu den anderen Indexfeldern weniger Gewicht bei der Auswertung hat,<br />
		das Ranking mit einem Wert gr&#x00F6;&#x00DF;er 1 vergr&#x00F6;&#x00DF;ert die Wichtung dieses Feldes gegen&#x00FC;ber den anderen Indexfeldern. Bleiben die Rankingfaktoren unver&#x00E4;ndert, so wird allen <br />
		Indexfeldern w&#x00E4;hrend der Suche die gleiche Bedeutung zugemessen.
		</span>		
	</div>
	<br />
	<form method="post" action="<%=response.encodeURL("localRanking.jsp")%>">
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
				</td>
				<td>
					<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
				</td>
				<td>
					<input type="hidden" name="process" value="true"/>
					<input type="submit" value="Weiter" />
				</td>
			</tr>
		</table>
		<br />
		<table class="table">
			<tr>
				<td class="tablehead"/>Indexfeld</td>
				<td class="tablehead"/>Rankingfaktor</td>				
			</tr>
			<%
			for(int i = 0; i < columns.length; i++)  {
				Column column = columns[i];
				float boost = column.getBoost();
				if (column.toIndex()){
			%>
				<tr>
					<td class="tablecell">
						<%=column.getTargetName()%>
					</td>
					<td class="tablecell">
						<select name="<%=column.getId()%>">
							<option value="0.1" <%if(boost == 0.1f){%>selected="selected"<%}%>>0.1</option>
							<option value="0.2" <%if(boost == 0.2f){%>selected="selected"<%}%>>0.2</option>
							<option value="0.3" <%if(boost == 0.3f){%>selected="selected"<%}%>>0.3</option>
							<option value="0.4" <%if(boost == 0.4f){%>selected="selected"<%}%>>0.4</option>
							<option value="0.5" <%if(boost == 0.5f){%>selected="selected"<%}%>>0.5</option>
							<option value="0.6" <%if(boost == 0.6f){%>selected="selected"<%}%>>0.6</option>
							<option value="0.7" <%if(boost == 0.7f){%>selected="selected"<%}%>>0.7</option>
							<option value="0.8" <%if(boost == 0.8f){%>selected="selected"<%}%>>0.8</option>
							<option value="0.9" <%if(boost == 0.9f){%>selected="selected"<%}%>>0.9</option>
							<option value="1.0" <%if(boost == 1.0f || boost == 0f){%>selected="selected"<%}%>>1.0</option>
							<option value="2.0" <%if(boost == 2.0f){%>selected="selected"<%}%>>2.0</option>
							<option value="3.0" <%if(boost == 3.0f){%>selected="selected"<%}%>>3.0</option>
							<option value="4.0" <%if(boost == 4.0f){%>selected="selected"<%}%>>4.0</option>
							<option value="5.0" <%if(boost == 5.0f){%>selected="selected"<%}%>>5.0</option>
							<option value="6.0" <%if(boost == 6.0f){%>selected="selected"<%}%>>6.0</option>
							<option value="7.0" <%if(boost == 7.0f){%>selected="selected"<%}%>>7.0</option>
							<option value="8.0" <%if(boost == 8.0f){%>selected="selected"<%}%>>8.0</option>
							<option value="9.0" <%if(boost == 9.0f){%>selected="selected"<%}%>>9.0</option>
							<option value="10.0" <%if(boost == 10.0f){%>selected="selected"<%}%>>10.0</option>
						</select>					
					</td>
				</tr>
				<%} %>	
			<%} %>
		</table>
		<br />
		<table class="table" align="center">					
			<tr align="center">
				<td>
					<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
				</td>
				<td>
					<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
				</td>
				<td>
					<input type="hidden" name="process" value="true"/>
					<input type="submit" value="Weiter" />
				</td>
			</tr>
		</table>
	</form>
</center>
</body>
</html>
