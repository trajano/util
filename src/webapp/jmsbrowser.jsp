<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 //EN" 
    "http://www.w3.org/TR/REC-html40/strict.dtd">
<%@ page import="javax.naming.*" %>
<%@ page import="javax.jms.*" %>
<%@ page import="javax.jms.Queue" %>
<%@ page import="java.util.*" %>
<%
	String queueConnectionFactory = request.getParameter("queueConnectionFactory");
	String queue = request.getParameter("queue");
	String breakpoints = request.getParameter("breakpoints");
	String clearQueue = request.getParameter("clearqueue");
	String showProperties = request.getParameter("showProperties");
%>
<form>
	Queue Connection Factory: <input name="queueConnectionFactory" size="100" value="<%= queueConnectionFactory == null ? "" : queueConnectionFactory %>" /><br/>
	Queue: <input name="queue" size="100" value="<%= queue == null ? "" : queue %>" /><br />
	Break points: <input name="breakpoints" size="100" value="<%= breakpoints == null || "null".equals(breakpoints) ? "" : breakpoints %>" /><br />
	<input name="showProperties" type="checkbox" <%= "on".equals(showProperties) ? "checked" : "" %>> Show properties<br />
	<input name="clearqueue" type="checkbox"> CLEAR QUEUE<br />
	<input type="submit" />
</form>
<ul>
<%
	if (queueConnectionFactory != null && queue != null && !("on".equals(clearQueue))) {
		Context ctx = new InitialContext();
		QueueConnectionFactory qcf = (QueueConnectionFactory)ctx.lookup(queueConnectionFactory);
		Queue q = (Queue)ctx.lookup(queue);
		QueueConnection connection = qcf.createQueueConnection();
		QueueSession queueSession =
			connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
		QueueBrowser browser =
			queueSession.createBrowser(q);
		for (Enumeration enumeration = browser.getEnumeration(); enumeration.hasMoreElements(); ) {
			Message message = (Message)enumeration.nextElement();
			String messageText = message.toString();
			if (message instanceof TextMessage) {
				messageText = ((TextMessage)message).getText();
			}
			else if (message instanceof BytesMessage) {
				BytesMessage bytesMessage = (BytesMessage)message;
				byte[] buffer = new byte[1024];
				int size = bytesMessage.readBytes(buffer);
				messageText = new String(buffer, 0, size, "ASCII");
			}
			%>
			<% 
			if (breakpoints != null) {
				StringTokenizer tokenizer = new StringTokenizer(breakpoints, ",");
				int size = tokenizer.countTokens();
				StringBuffer buf = new StringBuffer(messageText);
				int [] breaks = new int[size];
				for (int i = 0; i < size; ++i) {
					breaks[i] = Integer.parseInt(tokenizer.nextToken());
				}
				for (int i = breaks.length-1; i >= 0; --i) {
					buf.insert(breaks[i], "\n");
				}
				messageText = buf.toString();
			}
			%>
			<% if ("on".equals(showProperties)) { %>
			<li>
			<div>
				Properties:
				<ul>
				<% for (Enumeration properties = message.getPropertyNames(); properties.hasMoreElements(); ) { 
					String propertyName = (String)properties.nextElement();
				%>
					<li><%= propertyName %> : <%= message.getObjectProperty(propertyName) %></li>
				<% } %>
				</ul>
			</div>
			<pre><%=messageText%></pre>
			</li>
			<% } else { %>
			<li><pre><%=messageText%></pre></li>
			<% } %>
			<%
		}
		connection.close();
		ctx.close();
	}
	if (queueConnectionFactory != null && queue != null && "on".equals(clearQueue)) {
		Context ctx = new InitialContext();
		QueueConnectionFactory qcf = (QueueConnectionFactory)ctx.lookup(queueConnectionFactory);
		Queue q = (Queue)ctx.lookup(queue);
		QueueConnection connection = qcf.createQueueConnection();
		connection.start();
		QueueSession queueSession =
			connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
		QueueReceiver receiver  =
			queueSession.createReceiver(q);
		while (receiver.receiveNoWait() != null ) {
		}
		connection.close();
		ctx.close();
	}
%>
</ul>