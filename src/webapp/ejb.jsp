<%@ page import="javax.naming.*" %>
<%@ page import="java.lang.reflect.*" %>
<%
	String ejbName = request.getParameter("ejb");
	Method[] homeMethods = null;
	Method[] objectMethods = null;

	if (ejbName != null) {
		Context ctx = new InitialContext();
		Object home = ctx.lookup(ejbName);
		homeMethods = home.getClass().getMethods();
		Object object = home.getClass().getMethod("create", new Class[]{} ).invoke(home, new Object[]{} );
		objectMethods = object.getClass().getMethods();		
	}

%>
<form>
	EJB Home: <input name="ejb" size="100" value="<%= ejbName == null ? "" : ejbName %>" /><br/>
	<% if (homeMethods != null && objectMethods != null) {%>
	<h2>Home Methods</h2>
	<table>
	<thead>
		<tr>
			<th>Method</th>
			<th>Declaring class</th>
		</tr>
	</thead>
	<tbody>
		<% for (int i = 0; i < homeMethods.length; ++i) {
			Method method = homeMethods[i];
			if (!homeMethods[i].getDeclaringClass().getName().startsWith("java") &&
			    !homeMethods[i].getDeclaringClass().getName().startsWith("org.omg")) { %>
		<tr><td><%=method%></td><td><%=method.getDeclaringClass().getName()%></td></tr>
		<% } } %>
	</tbody>
	</table>
	<h2>Object Methods</h2>
	<table>
	<thead>
		<tr>
			<th>Method</th>
			<th>Declaring class</th>
		</tr>
	</thead>
	<tbody>
		<% for (int i = 0; i < objectMethods.length; ++i) {
			Method method = objectMethods[i];
			if (!objectMethods[i].getDeclaringClass().getName().startsWith("java") &&
			    !objectMethods[i].getDeclaringClass().getName().startsWith("org.omg")) { %>
		<tr><td><%=method%></td><td><%=method.getDeclaringClass().getName()%></td></tr>
		<% } } %>
	</tbody>
	</table>
	<% } %>
	<input type="submit" />
</form>
<%
%>
