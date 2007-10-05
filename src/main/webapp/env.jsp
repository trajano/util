<%@ page import="java.util.*" %>

<ul>
<!--<li><a href="#env">System Environment Variables</a></li> -->
<li><a href="#prop">System Properties</a></li>
<li><a href="#session">Session Attributes</a></li>
<li><a href="#cookie">Cookies</a></li>
</ul>
<%--
This block is commented out since getenv() is only available on JDK 1.5.

<h1><a name="env">System Environment Variables</a></h1>
<table border="1">
<tr><th>Name</th><th>Value</th></tr>
<%
	final Map env = System.getenv();
	final Set envSet = new TreeSet(env.keySet());
	for (Iterator i = envSet.iterator(); i.hasNext();) {
            final Object next = i.next();
%>
<tr><td><%=next%></td><td><%=env.get(next)%></td></tr>
<%
	}
%>
</table>
--%>
<h1><a name="System Properties">System Properties</a></h1>
<%
try {
%>
<table border="1">
<tr><th>Name</th><th>Value</th></tr>
<%
        final Properties props = System.getProperties();
        final Set propsSet = new TreeSet(props.keySet());
        for (Iterator i = propsSet.iterator(); i.hasNext();) {
            final Object next = i.next();
%>
<tr><td><%=next%></td><td><%=props.get(next)%></td></tr>
<%
	}
%>
</table>
<%
	} catch (Exception e) {
%>
	<p><i>not available</i></p>
<%
	}
%>

<h1><a name="session">Session Attributes</a></h1>
<%
try {
%>
<table border="1">
<tr><th>Name</th><th>Value</th></tr>
<%
        final Enumeration sessionAttributeNames = request.getSession().getAttributeNames();
        while (sessionAttributeNames .hasMoreElements()) {
            final String next = (String)sessionAttributeNames .nextElement();
%>
<tr><td><%=next%></td><td><%=request.getSession().getAttribute(next)%></td></tr>
<%
	}
%>
</table>
<%
	} catch (Exception e) {
%>
	<p><i>not available</i></p>
<%
	}
%>


<h1><a name="cookies">Cookies</a></h1>
<table border="1">
<tr><th>Name</th><th>Value</th></tr>
<%
	Cookie[] cookies = request.getCookies();
        for (int i = 0; i < cookies.length; ++i) {
%>
<tr><td><%=cookies[i].getName()%></td><td><%=cookies[i].getValue()%></td></tr>
<%
	}
%>
</table>
