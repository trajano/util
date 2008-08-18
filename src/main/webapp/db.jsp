<?xml version="1.0" encoding="UTF-8"?>
<jsp:root
	xmlns:jsp="http://java.sun.com/JSP/Page"
	xmlns:sql="http://java.sun.com/jstl/sql_rt"
	xmlns="http://www.w3c.org/1999/xhtml"
	xmlns:c="http://java.sun.com/jstl/core_rt"
	version="2.0">
<jsp:directive.page 
		contentType="text/html"
		import="javax.naming.*,javax.sql.*,java.sql.*,java.io.*,java.util.*" 
		isErrorPage="false" 
		isThreadSafe="true"
		session="true" />
	<jsp:useBean id="utilPreviousSqls" class="java.util.LinkedList" scope="session" />
	<jsp:declaration><![CDATA[
		private String getRequestParameter(final HttpServletRequest request, final String key) {
			return (request.getParameter(key) == null ? "" : request.getParameter(key));
		}
	]]></jsp:declaration>
<jsp:scriptlet><![CDATA[
	String name = getRequestParameter(request,"name");
	String sql = getRequestParameter(request,"sql");
	String sqlTextArea = getRequestParameter(request,"sqltextarea");
	if (!"".equals(sqlTextArea) && !utilPreviousSqls.contains(sqlTextArea)) {
		utilPreviousSqls.add(sqlTextArea);
	}
	String type = request.getParameter("type");
	session.setAttribute("utilPreviousSqls", utilPreviousSqls);
]]></jsp:scriptlet>
<html>
	<style>
			.clob_toggle {
				display: block;
			}   
			.clob {
				display: none;
				text-decoration: none;
			}   
	</style>
	<script><![CDATA[
		function toggle(ref) {
			var v = ref.nextSibling;
			while(v.nodeType == 3) {
  				v = v.nextSibling;
  			}
  			v.style.display = "block";
  			ref.style.display = "none";
		}
		function untoggle(ref) {
			var v = ref.previousSibling;
			while(v.nodeType == 3) {
  				v = v.previousSibling;
  			}
  			v.style.display = "block";
  			ref.style.display = "none";
		}
	]]></script>
	<noscript>
		<style>
			.clob_toggle {
				display: none;
			}   
			.clob {
				display: block;
			}   
		</style>
	</noscript>
<body>

<form>
	JNDI Connection Name: <jsp:element name="input">
		<jsp:attribute name="name">name</jsp:attribute>
		<jsp:attribute name="size">100</jsp:attribute>
		<jsp:attribute name="value"><c:out value="${param.name}" /></jsp:attribute></jsp:element><br/>

	SQL: <br />
	<textarea name="sqltextarea" rows="5" cols="80"><c:out value="${param.sqltextarea}" /></textarea><br />

	Previous SQLs: 
		<select onchange="sqltextarea.value=previousSql.options[previousSql.selectedIndex].value" id="previousSql">
			<option> </option>
			<c:forEach var="previousSql" items="${sessionScope.utilPreviousSqls}">
			<option><c:out escapeXml="true" value="${previousSql}"/></option>
			</c:forEach>
		</select><br />

	<input name="type" type="radio" size="100" checked="checked" value="query" />query<br />
	<input name="type" type="radio" size="100" value="queryTable" />query table data<br />
	<input name="type" type="radio" size="100" value="update" />update <br />
	<input type="submit" />
</form>
<c:if test="${!empty(param.name) and !empty(param.sqltextarea)}">
<c:choose>
	<c:when test="${param.type == 'query'}">
	</c:when>
	<c:when test="${param.type == 'queryTable'}">
	</c:when>
	<c:when test="${param.type == 'update'}">
	</c:when>
</c:choose>
</c:if>
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
				Clob clob = rs.getClob(x);
	                 	final Reader reader = new BufferedReader(clob.getCharacterStream());
				out.print("<td><a href='#' onclick='toggle(this)' class='clob_toggle'>View CLOB</a><a href='#' onclick='untoggle(this)' class='clob'><pre>");
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
				out.println("</pre></a></td>");
				x++;
	                 } else if (rs.getObject(x) == null) {
				out.println("<td><em>null</em></td>");
				x++;
			} else {
				out.println("<td>" + rs.getString(x) + "</td>");
				x++;
	                 }
	             }
	             out.println("</tr>");
			}
			out.print("</table>");
			rs.close();
		}
		else if ("queryTable".equals(type)) {
			ResultSet rs = statement.executeQuery();
			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<th>Column Label</th>");
			out.println("<th>Column Table</th>");
			out.println("<th>Column Name</th>");
			out.println("<th>Column Type Name</th>");
			out.println("<th>Size</th>");
			out.println("<th>Nullable</th>");
			out.println("</tr>");
			out.flush();
			{
				int x=1;
				while(x!=-1) {
					if (rs.getMetaData().getColumnCount() < x) {
						x=-1;
					} else {
						out.println("<tr>");
						out.println("<td>" + rs.getMetaData().getColumnLabel(x) + "</td>");
						out.println("<td>" + rs.getMetaData().getTableName(x) + "</td>");
						out.println("<td>" + rs.getMetaData().getColumnName(x) + "</td>");
						out.println("<td>" + rs.getMetaData().getColumnTypeName(x) + "</td>");
						if (rs.getMetaData().getScale(x) != 0) {
							out.println("<td>" + rs.getMetaData().getPrecision(x) + "," + rs.getMetaData().getScale(x) + "</td>");
						} else {
							out.println("<td>" + rs.getMetaData().getPrecision(x) + "</td>");
						}
						out.println("<td>" + rs.getMetaData().isNullable(x) + "</td>");
						out.println("</tr>");
						x++;
					}					
				}
	                 }
			out.print("</table>");
			rs.close();
		}
		else {
			out.print("result: " + statement.executeUpdate());
		}
	}
]]></jsp:scriptlet>
</body>
</html>
</jsp:root>