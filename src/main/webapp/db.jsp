<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.sql.*" %>
<%
	String name = (request.getParameter("name") == null ? "" : request.getParameter("name"));
	String sql = (request.getParameter("sql") == null ? "" : request.getParameter("sql"));
	String sqlTextArea = (request.getParameter("sqltextarea") == null ? "" : request.getParameter("sqltextarea"));
	String type = request.getParameter("type");
%>
<form>
	Name: <input name="name" size="100" value="<%= name.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&lt;") %>" /><br/>
	SQL: <input name="sql" size="100" value="<%= sql.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&lt;") %>" /><br />
	The contents of text area is ignored if there is some content in the line above.<br />
	<textarea name="sqltextarea" rows="5" cols="80"><%= sqlTextArea.replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&lt;") %></textarea><br />
	<input name="type" type="radio" size="100" checked="checked" value="query" />query<br />
	<input name="type" type="radio" size="100" value="update" />update <br />
	<input type="submit" />
</form>
<%
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
	                 } else if (rs.getMetaData().getColumnType(x) == java.sql.Types.CLOB)  {
	                     out.println("<td><pre>" + rs.getClob(x).getSubString(0, rs.getClob(x).length()).replaceAll("&", "&amp;").replaceAll(">", "&gt;").replaceAll("<", "&lt;") + "</pre></td>");
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
%>
