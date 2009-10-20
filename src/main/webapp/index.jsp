<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*" %>
<%@ page import="de.ingrid.iplug.*" %>
<%@ page import="de.ingrid.iplug.dsc.schema.*" %>
<%@ page import="de.ingrid.utils.xml.*"%>
<%@ page import="de.ingrid.utils.PlugDescription" %>
<%@ page import="de.ingrid.utils.BeanFactory"%>
<%@ page import="de.ingrid.iplug.util.*"%>
<%
BeanFactory beanFactory = (BeanFactory) application.getAttribute("beanFactory");
File pd_file = (File) beanFactory.getBean("pd_file");
PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");

if(pd_file.exists()){
	InputStream in = new FileInputStream(pd_file);
	
	XMLSerializer serializer = new XMLSerializer();
	serializer.aliasClass(PlugDescription.class.getName(), PlugDescription.class );
	description = (PlugDescription)serializer.deSerialize(in);		
}

request.getSession().removeAttribute("description");
request.getSession().setAttribute("description", description);

description.setIPlugClass("de.ingrid.iplug.dsc.index.DSCSearcher");
Construct construct = (Construct) description.get("construct");
request.getSession().setAttribute("construct", construct);

String mode = WebUtil.getParameter(request, "mode", "editall");
if(mode.equals("editall")){
	response.sendRedirect(response.encodeRedirectURL("dbConnection.jsp"));
}else{
	response.sendRedirect(response.encodeRedirectURL("scheduler.jsp"));
}	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Index Mapping</title>
</head>
<body>
<center>Sie werden weitergeleitet...</center>
</body>
</html>
