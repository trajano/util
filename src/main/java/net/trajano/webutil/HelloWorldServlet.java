package net.trajano.webutil;

import java.io.IOException;
import java.util.Date;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This is a sample servlet, typically you would not use this, but it is useful
 * for testing the sanity of your web application configuration.
 */
@WebServlet(urlPatterns = "/HelloWorld")
public class HelloWorldServlet extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = -4069226002214793588L;

    /**
     * This prints out the standard "Hello world" message with a date stamp.
     * 
     * @param request
     *            the HTTP request object
     * @param response
     *            the HTTP response object
     * @throws IOException
     *             thrown when there is a problem getting the writer
     */
    protected void doGet(final HttpServletRequest request,
            final HttpServletResponse response) throws IOException {
        response.getWriter().println("Hello world on " + new Date());
    }
}
