<%@ page import="javax.naming.*" session="false"%>
<%@ page import="java.util.*"%>
<%
    String name = request.getParameter("name");
    String contextFactory = request.getParameter("contextFactory");
    String providerUrl = request.getParameter("providerUrl");
    String securityPrincipal = request
            .getParameter("securityPrincipal");
    String securityCredentials = request
            .getParameter("securityCredentials");
    if (name == null) {
        name = "";
    }
    if (contextFactory == null) {
        contextFactory = "";
    }
    if (providerUrl == null) {
        providerUrl = "";
    }
    if (securityPrincipal == null) {
        securityPrincipal = "";
    }
    if (securityCredentials == null) {
        securityCredentials = "";
    }
    Context ctx;
    if ("".equals(contextFactory)) {
        ctx = new InitialContext();
    } else {
        Hashtable env = new Hashtable();
        env.put(Context.INITIAL_CONTEXT_FACTORY, contextFactory);
        if (providerUrl.length() > 0) {
            env.put(Context.PROVIDER_URL, providerUrl);
        }
        if (securityPrincipal.length() > 0) {
            env.put(Context.SECURITY_PRINCIPAL, securityPrincipal);
        }
        if (securityCredentials.length() > 0) {
            env.put(Context.SECURITY_CREDENTIALS, securityCredentials);
        }
        ctx = new InitialContext(env);
    }
    String contextUrl = "&contextFactory=" + contextFactory;
    contextUrl += "&providerUrl=" + providerUrl;
    contextUrl += "&securityPrincipal=" + securityPrincipal;
    contextUrl += "&securityCredentials=" + securityCredentials;

    Object o = ctx.lookup(name);
    Class clazz = o.getClass();
    Class[] interfaces = clazz.getInterfaces();
    if (o instanceof Context) {
        NamingEnumeration namingEnumeration = ctx.list(name);
        out.println("<h1>" + name + "</h1>");
        out.println("<ul>");
        while (namingEnumeration.hasMoreElements()) {
            NameClassPair element = (NameClassPair) namingEnumeration
                    .nextElement();
            String href = request.getRequestURI() + "?name=" + name;
            if (name.length() > 0 && !name.endsWith(":")) {
                href += "/";
            }
            href += element.getName() + contextUrl;
%><li><a href="<%=href%>"><%=element%></a></li>
<%
    }
        out.println("</ul>");
    } else {
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
<%=o%>
<%
    }
%>
<hr />
<form>
	JNDI Name: <input name="name" size="100" value="<%=name%>" />
	<hr />
	<table>
		<tr>
			<td>Initial Context Factory:</td>
			<td><input name="contextFactory" size="100"
				value="<%=contextFactory%>" /></td>
		</tr>
		<tr>
			<td>Provider URL</td>
			<td><input name="providerUrl" size="100"
				value="<%=providerUrl%>" /></td>
		</tr>
		<tr>
			<td>Security Principal (Username)</td>
			<td><input name="securityPrincipal" size="100"
				value="<%=securityPrincipal%>" /></td>
		</tr>
		<tr>
			<td>Security Credentials (Password)</td>
			<td><input name="securityCredentials" size="100"
				value="<%=securityCredentials%>" /></td>
		</tr>
	</table>
	<input type="submit" />
</form>

<p>
	<a href="jndi-web.jsp?name=java%3A<%=contextUrl%>">Browse java:
		tree</a>
</p>
