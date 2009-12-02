<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="de.ingrid.iplug.dsc.index.*"%>
<%@ page import="de.ingrid.iplug.util.*"%>
<%@ page import="de.ingrid.utils.PlugDescription" %>
<%@ page import="org.apache.commons.configuration.PropertiesConfiguration" %>
<%@ include file="timeoutcheck.jsp"%>
<%@page import="java.io.File"%>
<%!
private final String SERVER_PORT    = "server.port";
private final String PROXY_URL      = "proxy.url";
private final String DETAILS_URL    = "metadata.details.url";

private final String ERROR_PORT     = "error.port";
%>
<%

	boolean submitted = WebUtil.getParameter(request, "submitted", null )!=null;
	String error = request.getParameter("error");
	PropertiesConfiguration properties = new PropertiesConfiguration("conf/ingrid-opensearch.properties");
	
	if(submitted){
	    String port = request.getParameter("port");
	    
	    // save back in properties file
        properties.setProperty(SERVER_PORT, port);
        properties.setProperty(PROXY_URL,   request.getParameter("extUrl"));
        properties.setProperty(DETAILS_URL, request.getParameter("detailUrl"));
        
        // check if port is correct
	    if (!port.matches("[1-9][0-9]+")) {
	        error = ERROR_PORT;
	    } else {
		    properties.save();
		    
		    // write working directory into PD which is also needed for indexing
		    PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");
		    description.setWorkinDirectory(new File("index/"));
		    System.out.println("WorkingDir: " + (new File("index/")).getAbsolutePath());
		    
		    // redirect to the next page
		    response.sendRedirect(response.encodeRedirectURL("dbConnection.jsp"));
	    }
	} 
		
	String port        = properties.getString(SERVER_PORT);
    String extUrl      = properties.getString(PROXY_URL);
    String detailUrl   = properties.getString(DETAILS_URL);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Opensearch Server - Administration</title>
<link href="<%=response.encodeURL("css/admin.css")%>" rel="stylesheet" type="text/css" />

<script  language="javascript">

</script>

</head>
<body>
	<center>
	<div class="headline"><a class="logout" href="login.jsp?logout=true">abmelden</a><br />
		Opensearch Einstellungen
		<br /><br />	
	</div>
	<br />
	<form name="osSettings" method="post" action="<%=response.encodeURL("osSettings.jsp")%>">
		<table class="table" width="400" align="center">
			<tr>
				<td colspan="2" class="tablehead">Einstellungen</td>
			</tr>
			<tr>
				<td class="tablecell" width="160">Opensearch-Server Port:</td>
				<td class="tablecell">
				    <input name="port" type="text" style="width:100%" value="<%=port%>"/>
				    <% if (error != null && error.equals(ERROR_PORT)) { %>
				    <div class="error">Der Port muss mindestens zweistellig sein und nur aus Zahlen bestehen!</div>
				    <% } %>				
				</td>
			</tr>
			<tr>
                <td class="tablecell" width="160">Externe URL des Dienstes:</td>
                <td class="tablecell"><input name="extUrl" type="text" style="width:100%" value="<%=extUrl%>"/></td>
            </tr>
            <tr>
                <td class="tablecell" width="160">Detail URL:</td>
                <td class="tablecell"><input name="detailUrl" type="text" style="width:100%" value="<%=detailUrl%>"/></td>
            </tr>
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
						<input type="hidden" name="submitted" value="true"> 
						<input type="submit" value="Weiter"/>						
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
</html>