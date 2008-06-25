<?xml version="1.0" encoding="UTF-8"?>
<jsp:root version="2.0"
	xmlns:c="http://java.sun.com/jsp/jstl/core"
	xmlns="http://www.w3c.org/1999/xhtml"
	xmlns:jsp="http://java.sun.com/JSP/Page">
	<jsp:directive.page 
		contentType="text/html"
		import="javax.naming.*,javax.sql.*,java.sql.*,java.io.*" 
		isErrorPage="false" 
		isThreadSafe="true"
		session="true" />
	<jsp:declaration><![CDATA[
		private String getRequestParameter(final HttpServletRequest request, final String key) {
			return (request.getParameter(key) == null ? "" : request.getParameter(key));
		}
		private String escapeXml(final String string) {
			return string.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&lt;");
		}
	]]></jsp:declaration>
<jsp:scriptlet>
	String name = getRequestParameter(request,"name");
	String sql = getRequestParameter(request,"sql");
	String sqlTextArea = getRequestParameter(request,"sqltextarea");
	String type = request.getParameter("type");
</jsp:scriptlet>
<html>
<body>
<form>
	Name: <jsp:element name="input">
		<jsp:attribute name="name">name</jsp:attribute>
		<jsp:attribute name="size">100</jsp:attribute>
		<jsp:attribute name="value"><jsp:expression>escapeXml(name)</jsp:expression></jsp:attribute></jsp:element><br/>
	SQL: <jsp:element name="input">
		<jsp:attribute name="name">sql</jsp:attribute>
		<jsp:attribute name="size">100</jsp:attribute>
		<jsp:attribute name="value"><jsp:expression>escapeXml(sql)</jsp:expression></jsp:attribute></jsp:element><br/>
	The contents of text area is ignored if there is some content in the line above.<br />
	<textarea name="sqltextarea" rows="5" cols="80"><jsp:expression  name="value">escapeXml(sqlTextArea)</jsp:expression></textarea><br />
	<input name="type" type="radio" size="100" checked="checked" value="query" />query<br />
	<input name="type" type="radio" size="100" value="update" />update <br />
	<input type="submit" />
</form>
<jsp:scriptlet><![CDATA[
	if (!"".equals(name) && !("".equals(sql) && "".equals(sqlTextArea) )) {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup(name);
		Connection conn = ds.getConnection();
		if ("".equals(sql)) {
		   sql = sqlTextArea;
		}
		PreparedStatement statement = conn.prepareStatement(sql);
		if ("query".equals(type)) {
			ResultSet rs = statement.executeQuery();
			out.print("<table border='1'>");
			{
				int x=1;
	             out.println("<tr>");
	             while(x!=-1) {
	                 if(rs.getMetaData().getColumnCount()<x) {
	                     x=-1;
	                 } else {
	                     out.println("<th>" + rs.getMetaData().getColumnLabel(x) + "</th>");
	                     x++;
	                 }
	             }
	             out.println("</tr>");
			}			
			while (rs.next()) {
			    int x=1;
	             out.println("<tr>");
	             while(x!=-1) {
	                 if(rs.getMetaData().getColumnCount()<x) {
	                     x=-1;
	                 } else if (rs.getMetaData().getColumnType(x) == Types.CLOB)  {
	                 	 final Reader reader = new BufferedReader(rs.getClob(x).getCharacterStream());
	                     out.print("<td><pre>");
	                 	 int c = reader.read();
	                 	 while (c != -1) {
	                 	 	if (c == '>') {
	                 	 		out.print("&amp;gt;");
	                 	 	} else if (c == '<') {
	                 	 		out.print("&amp;lt;");
	                 	 	} else if (c == '&') {
								out.print("&amp;amp;");
							} else {
								out.print((char)c);
							}
							c = reader.read();
	                 	 }
	                 	 reader.close();
						out.println("</pre></td>");
						x++;
	                 } else {
	                     out.println("<td>" + rs.getString(x) + "</td>");
	                     x++;
	                 }
	             }
	             out.println("</tr>");
			}
			out.print("</table>");
		}
		else {
			out.print("result: " + statement.executeUpdate());
		}
	}
]]></jsp:scriptlet>
</body>
</html>
</jsp:root>