<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="de.ingrid.iplug.dsc.schema.*"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ page import="de.ingrid.iplug.util.WebUtil"%>
<%@ page import="de.ingrid.utils.dsc.Column"%>
<%@ include file="timeoutcheck.jsp"%>
<%
String error = "";
String url = "";
String customDetail = "true";
PlugDescription description = (PlugDescription) request.getSession().getAttribute("description");

// no radio selected
if(WebUtil.getParameter(request, "customDetail", "").equals("") && WebUtil.getParameter(request, "submitted", null)!=null){
	error = "pleaseMakeASelection";
}

// radio selected and custom URL
if(WebUtil.getParameter(request, "submitted", null)!=null && WebUtil.getParameter(request, "customDetail", "").equals("true")){
	String detailUrl = WebUtil.getParameter(request, "detailUrl", "");
	if(!detailUrl.equals("")){
		description.put("detailUrl", detailUrl);
		response.sendRedirect(response.encodeRedirectURL("scheduler.jsp"));
	} else {
		error = "urlEmpty";
	}
}

//radio selected and no custom URL
if(WebUtil.getParameter(request, "submitted", null)!=null && WebUtil.getParameter(request, "customDetail", "").equals("false")){
	description.remove("detailUrl");
	response.sendRedirect(response.encodeRedirectURL("scheduler.jsp"));
	customDetail = WebUtil.getParameter(request, "customDetail", "");
}
if(WebUtil.getParameter(request, "submitted", null)!=null ){
	url = WebUtil.getParameter(request, "detailUrl", "");
}

if(WebUtil.getParameter(request, "submitted", null)==null && description.get("detailUrl") != null){
	url = (String) description.get("detailUrl");
	customDetail = "true";
} else {
	customDetail = "false";
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />
<title>Detailansicht</title>
</head>
<body>
<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Detailansicht w&#x00E4;hlen
		<br /><br />
		<span class="byline">
		Bitte w&#x00FC;hlen Sie, ob die Detailansicht eines Treffers im Portal angezeigt werden soll oder ob es bereits eine externe Webanwendung gibt, auf die Sie verlinken m&#x00F6;chten.<br />
		F&#x00FC;r eine externe Webanwendung k&#x00F6;nnen Sie eine URL angeben, in der Sie als Platzhalter f&#x00FC;r Parameterwerte {Indexfeldnamen} geschweifte Klammern verwenden.
		<br /><br />
		Bsp.: http://www.meineUrl.com?id={t01_Object.obj_id}&template=mytemplate
		<br />
		</span>		
	</div>
	<br />
	<form method="post" action="<%=response.encodeURL("selectDetailView.jsp")%>">
	<table class="table" align="center">					
	<tr align="center">
		<td>
			<input type="button" name="back" value="Zur&#x00FC;ck" onclick="history.back()"/>
		</td>
		<td>
			<input type="button" name="cancel" value="Abbrechen" onclick="window.location.href='<%=response.encodeURL("index.jsp")%>'"/>						
		</td>
		<td>
			<input type="hidden" name="submitted" value="true" name="cont"/>
			<input type="submit" value="Weiter" />
		</td>
	</tr>
	</table>
	<br />
	
	<%
	if (error.equals("pleaseMakeASelection")) {%>
		<div class="error">Bitte treffen Sie eine Auswahl!</div>
		<br />
	<%}%>
	<%
	if (error.equals("urlEmpty")) {%>
		<div class="error">Url darf nicht leer sein.</div>
		<br />
	<%}%>

	<table class="table">
		<tr>
			<td class="tableHead" colspan="2">Detailansicht</td>
		</tr>		
		<tr>
			<td class="tablecell">
				<input type="radio" name="customDetail" value="false" <%if(customDetail.equals("false")){ %>checked<%}%>/>
			</td>
			<td class="tablecell">Detailanzeige des Portals verwenden</td>
		</tr>
			<tr>
			<td class="tablecell">
				<input type="radio" name="customDetail" value="true" <%if(customDetail.equals("true")){ %>checked<%}%>/>
			</td>
			<td class="tablecell">Eigene, externe Detailanzeige verwenden
				<br />
				<input type="text" name="detailUrl" value="<%=url%>" style="width:100%" />
			</td>
		</tr>
	</table>
	<br />
	<hr/>
	<br />
	
	<%
	
	Construct construct = (Construct) request.getSession().getAttribute("construct");
	Column[] columns = construct.getColumns();
	
	%>
	
	Externe Anwendung: Folgende Indexfeldnamen stehen als Platzhalter f&#x00FC;r Parameterwerte zur Verf&#x00FC;gung:
	<br />
	<br />
	<table class="table">
		<tr>
			<td class="tableHead">Ihre Datenbank</td>
			<td class="tableHead">Platzhalter</td>
		</tr>
		<%		
		for(int i=0; i < columns.length; i++){
			if(columns[i].toIndex()){
			Column column = columns[i];
		%>
		<tr>
			<td class="tablecell"><%=column.toString()%></td>
			<td class="tablecell">{<%=column.getTargetName().toLowerCase()%>}</td>
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
				<input type="hidden" name="submitted" value="true" name="cont"/>
				<input type="submit" value="Weiter" />
			</td>
		</tr>
	</table>
</form>	
</center>
</body>
<!-- ingrid-iplug-admin-step2-dsc -->
</html>