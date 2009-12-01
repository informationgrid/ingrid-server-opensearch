<%@ include file="timeoutcheck.jsp"%>
<%
// delete Session attributes
request.getSession().removeAttribute("tables");
request.getSession().removeAttribute("construct");
request.getSession().removeAttribute("fields");
request.getSession().removeAttribute("connection");
request.getSession().removeAttribute("controller");

response.sendRedirect(response.encodeRedirectURL("dbConnection.jsp?reset=true"));
%>