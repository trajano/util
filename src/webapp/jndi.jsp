<%@ page import="javax.ejb.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.jms.*" %>
<%
	Context ctx = new InitialContext();
	String name = request.getParameter("name");
	if (name == null) {
		name = "";
	}
	Object o = ctx.lookup(name);
	Class clazz = o.getClass();
	Class[] interfaces = clazz.getInterfaces();
	if (o instanceof Context) {
		NamingEnumeration namingEnumeration = ctx.list(name);
		out.println("<h1>" + name + "</h1>");
		out.println("<ul>");
		while (namingEnumeration.hasMoreElements()) {
			NameClassPair element = (NameClassPair)namingEnumeration.nextElement();
			String href = request.getRequestURI() + "?name=" + name;
			if (name.length() > 0 && !name.endsWith(":")) {
				href += "/";
			}
			href += element.getName() ;
			
			%><li><a href="<%=href %>"><%=element %></li><%
		}
		out.println("</ul>");
	}
	else {
		%><h1><%=o.getClass()%></h1>
		<%
		  if (interfaces.length > 0) {
		%>
			<ul>
			<%
				for (int i = 0; i < interfaces.length; ++i) {
			%>
				<li><%=interfaces[i]%></li>
			<%
				}
			%>
			</ul>
		<%
		  } 
		%>
		<%=o%><%
	}
%>
<%
	if (o instanceof EJBHome) {
%>
	<p><a href="ejb.jsp?ejb=<%=name%>">EJB Home Viewer</a></p>
<%
	}
%>
<%
	if (o instanceof DataSource) {
%>
	<p><a href="db.jsp?name=<%=name%>">JDBC Viewer</a></p>
<%
	}
%>
<%
	if (o instanceof QueueConnectionFactory) {
%>
	<p><a href="jms.jsp?queueConnectionFactory=<%=name%>">JMS Sender</a></p>
	<p><a href="jmsbrowser.jsp?queueConnectionFactory=<%=name%>">JMS Viewer</a></p>
<%
	}
%>
<%
	if (o instanceof Queue) {
%>
	<p><a href="jms.jsp?queue=<%=name%>">JMS Sender</a></p>
	<p><a href="jmsbrowser.jsp?queue=<%=name%>">JMS Viewer</a></p>
<%
	}
%>
<form>
	<input name="name" size="100" value="<%= name %>" />
</form>

