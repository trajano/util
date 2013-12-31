<%@ page import="java.io.*" session="false"%>
<%
    final String path = request.getParameter("path") == null ? ""
            : request.getParameter("path");
    File file = null;
    if (path != "") {
        file = new File(path);
        if (!file.isDirectory() && file.exists()) {
            response.setContentType("text/plain");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + file.getName() + "\"");
            InputStream is = null;
            try {
                is = new FileInputStream(file);
                byte[] buf = new byte[10240];
                int c = is.read(buf);
                while (c >= 0) {
                    out.write(new String(buf, 0, c));
                    c = is.read(buf);
                }
            } finally {
                if (is != null) {
                    is.close();
                }
            }
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%
    if (file == null) {
%><title>Retrieve file from server</title>
<%
    } else if (file.isDirectory()) {
%><title><%=file%></title>
<%
    }
%>
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" />
<script type="text/javascript"
	src="//code.jquery.com/jquery-1.10.1.min.js"></script>
<script type="text/javascript"
	src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>
	<div class="container">
		<div class="row clearfix">
			<div class="col-md-12">
				<%
				    if (file == null) {
				%>
				<h1>Retrieve files from server</h1>
				<form class="form-horizontal">
					<div class="form-group">
						<label for="path" class="col-sm-2 control-label">Path</label>
						<div class="col-md-10">
							<input type="text" class="form-control" id="path" size="100"
								name="path" value="<%=path%>"
								placeholder="Enter path to file to download or directory to browse">
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-offset-2 col-md-10">
							<button type="submit" class="btn btn-default">Retrieve</button>
						</div>
					</div>
				</form>
				<%
				    } else if (file.isDirectory()) {
				%>
				<h1><%=path%></h1>
				<ul class="nav nav-pills nav-stacked">
					<%
					    if (file.getParent() != null) {
					%>
					<li><a href="getfile.jsp?path=<%=file.getParent()%>"> <i
							class="fa fa-arrow-up"></i> Go up one level
					</a></li>
					<%
					    }
					%>
					<%
					    for (final File target : file.listFiles()) {
					%>
					<li><a href="getfile.jsp?path=<%=target%>"> <%
     if (target.isDirectory()) {
 %> <i class="fa fa-folder"></i> <%
     } else {
 %> <i class="fa fa-file"></i> <%
     }
 %> <%=target.getName()%></a></li>
					<%
					    }
					%>
				</ul>
				<%
				    }
				%>
			</div>
		</div>
	</div>
</body>
</html>