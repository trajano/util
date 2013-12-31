<%@ page import="java.util.*" session="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Environment dump</title>
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
<script type="text/javascript"
	src="//code.jquery.com/jquery-1.10.1.min.js"></script>
<script type="text/javascript"
	src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body data-target="#scrollspy" data-spy="scroll">
	<div class="container">
		<div class="row clearfix">
			<div class="col-md-3 column" id="scrollspy">
				&nbsp;
				<ul class="nav nav-stacked nav-pills" id="affix" data-offset-top="0"
					data-spy="affix">
					<li class="active"><a href="#request">Request Data</a></li>
					<li><a href="#header">HTTP Request Header</a></li>
					<li><a href="#env">System Environment Variables</a></li>
					<li><a href="#properties">System Properties</a></li>
					<li><a href="#session">Session Attributes</a></li>
					<li><a href="#cookies">Cookies</a></li>
				</ul>
			</div>
			<div class="col-md-9 column">
				<h1>Environment dump</h1>
				<h2>
					<a id="request">Request Data</a>
				</h2>
				<table class="table">
					<col width="40%">
					<col width="60%">
					<tbody>
						<tr>
							<th>Auth Type</th>
							<td><%=request.getAuthType()%></td>
						</tr>
						<tr>
							<th>Character Encoding</th>
							<td><%=request.getCharacterEncoding()%></td>
						</tr>
						<tr>
							<th>Context Path</th>
							<td><%=request.getContextPath()%></td>
						</tr>
						<tr>
							<th>Remote User</th>
							<td><%=request.getRemoteUser()%></td>
						</tr>
						<tr>
							<th>Secure</th>
							<td><%=request.isSecure()%></td>
						</tr>
						<tr>
							<th>User Principal</th>
							<td><%=request.getUserPrincipal()%></td>
						</tr>
					</tbody>
				</table>

				<h2>
					<a id="header">HTTP Request Header</a>
				</h2>
				<%
				    @SuppressWarnings("unchecked")
				    final Enumeration<String> headerNames = request.getHeaderNames();
				%>
				<table class="table">
					<col width="40%">
					<col width="60%">
					<tr>
						<th>Name</th>
						<th>Value</th>
					</tr>
					<%
					    while (headerNames.hasMoreElements()) {
					        final String next = headerNames.nextElement();
					%>
					<tr>
						<td><%=next%></td>
						<td><%=request.getHeader(next)%></td>
					</tr>
					<%
					    }
					%>
				</table>

				<h2>
					<a id="env">System Environment Variables</a>
				</h2>
				<table class="table">
					<col width="40%">
					<col width="60%">
					<tr>
						<th>Name</th>
						<th>Value</th>
					</tr>
					<%
					    final Map<String, String> env = System.getenv();
					    for (final String envVar : new TreeSet<String>(env.keySet())) {
					%>
					<tr>
						<td><%=envVar%></td>
						<%
						    if (env.get(envVar).contains(";")) {
						%>
						<td>
							<ul>
								<%
								    for (final String pathElement : env.get(envVar).split(";")) {
								%>
								<li><%=pathElement%></li>
								<%
								    }
								%>
							</ul>
						</td>
						<%
						    } else {
						%>
						<td><%=env.get(envVar)%></td>
						<%
						    }
						%>
					</tr>
					<%
					    }
					%>
				</table>

				<h2>
					<a id="properties">System Properties</a>
				</h2>

				<table class="table">
					<col width="40%">
					<col width="60%">
					<tr>
						<th>Name</th>
						<th>Value</th>
					</tr>
					<%
					    for (final String propertyName : new TreeSet<String>(System
					            .getProperties().stringPropertyNames())) {
					%>
					<tr>
						<td><%=propertyName%></td>
						<%
						    if (System.getProperty(propertyName).contains(";")) {
						%>
						<td>
							<ul>
								<%
								    for (final String pathElement : System.getProperty(
								                    propertyName).split(";")) {
								%>
								<li><%=pathElement%></li>
								<%
								    }
								%>
							</ul>
						</td>
						<%
						    } else if (System.getProperty(propertyName).contains(",")) {
						%>
						<td>
							<ul>
								<%
								    for (final String pathElement : System.getProperty(
								                    propertyName).split(",")) {
								%>
								<li><%=pathElement%></li>
								<%
								    }
								%>
							</ul>
						</td>
						<%
						    } else {
						%>
						<td><%=System.getProperty(propertyName)%></td>
						<%
						    }
						%>
					</tr>
					<%
					    }
					%>
				</table>

				<h2>
					<a id="session">Session Attributes</a>
				</h2>
				<%
				    try {
				        @SuppressWarnings("unchecked")
				        final Enumeration<String> sessionAttributeNames = request
				                .getSession(false).getAttributeNames();
				%>
				<table class="table">
					<col width="40%">
					<col width="60%">
					<tr>
						<th>Name</th>
						<th>Value</th>
					</tr>
					<%
					    while (sessionAttributeNames.hasMoreElements()) {
					            final String next = (String) sessionAttributeNames
					                    .nextElement();
					%>
					<tr>
						<td><%=next%></td>
						<td><%=request.getSession().getAttribute(next)%></td>
					</tr>
					<%
					    }
					%>
				</table>
				<%
				    } catch (Exception e) {
				%>
				<div class="alert alert-warning">
					<i>no HttpSession available</i>
				</div>
				<%
				    }
				%>


				<h2>
					<a id="cookies">Cookies</a>
				</h2>
				<table class="table">
					<tr>
						<th>Name</th>
						<th>Value</th>
					</tr>
					<%
					    final Cookie[] cookies = request.getCookies();
					    for (int i = 0; cookies != null && i < cookies.length; ++i) {
					%>
					<tr>
						<td><%=cookies[i].getName()%></td>
						<td><%=cookies[i].getValue()%></td>
					</tr>
					<%
					    }
					%>
				</table>
			</div>
		</div>
	</div>
</body>
</html>