<%@ page import="java.io.*" %>
<%
	String name = (request.getParameter("name") == null ? "" : request.getParameter("name") );
	if (name != "") {
		File file = new File(name);
		if (file.isDirectory()) {
%><h1><%=file%></h1><ul><%
			String[] files = file.list();
			for (int i = 0; i < files.length; ++i) {
				%><li><a href="getfile.jsp?name=<%= new File(file, files[i]).toString() %>"><%= files[i] %></a></li><%
			}
%></ul><%
		} else  if (file.exists()) {
			response.setContentType("text/plain");
			InputStream is = new FileInputStream(file);
			byte[] buf = new byte[10240];
			int c =is.read(buf);
			while (c >= 0) {
				out.write(new String(buf, 0, c));
				c =is.read(buf);
			}
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
