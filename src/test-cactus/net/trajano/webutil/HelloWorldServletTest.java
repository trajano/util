package net.trajano.webutil;

import org.apache.cactus.ServletTestCase;
import org.apache.cactus.WebResponse;

import net.trajano.webutil.HelloWorldServlet;

/**
 * This tests that the HelloWorld servlet is functioning
 * 
 * @author <a href="trajano@yahoo.com">Archimedes Trajano</a>
 * @version $Id: HelloWorldServletTest.java,v 1.1 2004/09/25 10:23:09 trajano
 *                 Exp $
 */
public class HelloWorldServletTest extends ServletTestCase {

    /**
     * Tests if the hello world servlet is accessible.
     * 
     * @throws Exception
     */
    public void testHelloWorld() throws Exception {
        HelloWorldServlet servlet = new HelloWorldServlet();
        servlet.doGet(request, response);
    }

    /**
     * Tests if the Hello World program responds properly.
     * 
     * @param response
     *                   the web response from the servlet.
     */
    public void endHelloWorld(final WebResponse response) {
        assertTrue(response.getText().startsWith("Hello world on"));
    }
}
