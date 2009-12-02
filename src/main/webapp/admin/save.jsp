<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="de.ingrid.utils.xml.*" %>    
<%@ page import="de.ingrid.iplug.*"%>
<%@ page import="java.io.*"%>
<%@ page import="de.ingrid.utils.PlugDescription"%>
<%@ page import="de.ingrid.utils.BeanFactory"%>
<%@ include file="timeoutcheck.jsp"%>
<%
PlugDescription  description = (PlugDescription) request.getSession().getAttribute("description");

// INGRID-1343: look, if field buzzword is set, if not, it will set. ab
String[] fields = description.getFields();
boolean isSet = false;
String field = "";
for (int i=0; i < fields.length; i++){
	field = fields[i];
	if (field.equals("buzzword")){
		isSet=true;
	}
}
if (!isSet){
	description.addField("buzzword");
}
//end INGRID-1343 ab
java.net.URL url = this.getClass().getClassLoader().getResource("conf");
File folder  = null;
if(url !=null){
	String	path = url.getPath();
	boolean WINDOWS = System.getProperty("os.name").startsWith("Windows");
	if (WINDOWS && path.startsWith("/")){ // patch a windows bug
	    path = path.substring(1);
	}
	try {
	    path = java.net.URLDecoder.decode(path, "UTF-8"); // decode the url path
	} catch (UnsupportedEncodingException e) {
	}
	folder = new File(path);
} else {
	folder = description.getWorkinDirectory();
}

BeanFactory beanFactory = (BeanFactory) application.getAttribute("beanFactory");
File pd_file = (File) beanFactory.getBean("pd_file");

// add pd-location needed in DSCSearcher after indexing
description.put("PLUGDESCRIPTION_FILE", pd_file.getAbsolutePath());

XMLSerializer serializer = new XMLSerializer();
if (null == description) {
	System.out.println("step2/save.jsp: ERROR in step2/save.jsp: current values lost during session timeout, plugdescription from web container was <null> and was not written");
} else {
    serializer.serialize(description,pd_file);
}
response.sendRedirect(response.encodeRedirectURL("indexDatabaseQuestion.jsp"));
%>
