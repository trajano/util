<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.jms.*" %>
<h1>System Environment variables</h1>
<table border="1">
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

<h1>System Properties</h1>
<table border="1">
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


<h1>System Properties</h1>
<table border="1">
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
