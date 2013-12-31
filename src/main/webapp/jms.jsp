<%@ page import="javax.naming.*" session="false"%>
<%@ page import="javax.jms.*" %>
<%
	String queueConnectionFactory = request.getParameter("queueConnectionFactory");
	String queue = request.getParameter("queue");
	String message = request.getParameter("message");
%>
<form>
	Queue Connection Factory: <input name="queueConnectionFactory" size="100" value="<%= queueConnectionFactory == null ? "" : queueConnectionFactory %>" /><br/>
	Queue: <input name="queue" size="100" value="<%= queue == null ? "" : queue %>" /><br />
	Message: <input name="message" size="100" value="<%= message == null ? "" : message %>" /><br />
	<input type="submit" />
</form>
<%
	if (queueConnectionFactory != null && queue != null) {
		Context ctx = new InitialContext();
		QueueConnectionFactory qcf = (QueueConnectionFactory)ctx.lookup(queueConnectionFactory);
		Queue q = (Queue)ctx.lookup(queue);
		QueueConnection connection = qcf.createQueueConnection();
		QueueSession queueSession =
			connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
		QueueSender sender = queueSession.createSender(q);
		sender.send(queueSession.createTextMessage(message));
		connection.close();
		ctx.close();
		%><b>message "<%=message%>" sent</b><%
	}
%>
