package net.trajano.webutil;

import org.apache.cactus.ServletTestCase;

import com.meterware.httpunit.WebConversation;

/**
 * This tests the system using the HttpUnit
 * @author <a href="trajano@yahoo.com">Archimedes Trajano</a>
 * @version $Id$
 */
public class HttpUnitTest extends ServletTestCase {

    /**
     * This tests if the Hello World servlet provides the correct output
     * 
     * @throws Exception
     *                    thrown when there is a problem with the test
     */
    public void testHelloWorldServlet() throws Exception {
        WebConversation wc = new WebConversation();
        wc.getResponse(requestUrl("/HelloWorld"));
        assertTrue(wc.getCurrentPage().getText().startsWith("Hello world on"));
    }

    /**
     * This tests if the Hello World JSP provides the correct output
     * 
     * @throws Exception
     *                    thrown when there is a problem with the test
     */
    public void testHelloWorldJsp() throws Exception {
        WebConversation wc = new WebConversation();
        wc.getResponse(requestUrl("/sample.jsp"));
        assertTrue(wc.getCurrentPage().getText().startsWith("Hello world JSP on"));
    }

    /**
     * This is a helper method to create the URL string for the initial web
     * conversation request
     * 
     * @param relativeUrl
     *                   the relative URL including the leading"/"
     * @return the context url with the relative URL appended to it
     */
    private String requestUrl(String relativeUrl) {
        StringBuffer url = request.getRequestURL();
        url.delete(url.lastIndexOf("/"), url.length());
        url.append(relativeUrl);
        return url.toString();
    }
}
