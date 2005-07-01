package net.trajano.webutil;

import junit.framework.TestCase;
import com.meterware.httpunit.GetMethodWebRequest;
import com.meterware.httpunit.HttpUnitOptions;
import com.meterware.httpunit.WebRequest;
import com.meterware.httpunit.WebResponse;
import com.meterware.servletunit.ServletRunner;
import com.meterware.servletunit.ServletUnitClient;

/**
 * This is a simple JUnit test case to ensure that the environment is okay.
 * 
 * @author <a href="trajano@yahoo.com">Archimedes Trajano</a>
 * @version $Id$
 */
public class SanityTest extends TestCase {
    /**
     * This verifies that "test" is equivalent to "test".
     */
    public void testSanity() {
        assertEquals("test", "test");
    }

    /**
     * This tests the HelloWorld servlet.
     * 
     * @throws Exception
     *             problem with the test.
     */
    public void testHelloWorldServlet() throws Exception {
        HttpUnitOptions.setScriptingEnabled(false);
        ServletRunner servletRunner = new ServletRunner();
        servletRunner.registerServlet("HelloWorldServlet", HelloWorldServlet.class.getName());
        ServletUnitClient client = servletRunner.newClient();
        WebRequest request = new GetMethodWebRequest("http://test/HelloWorldServlet");
        WebResponse response = client.getResponse(request);
        assertTrue(response.getText().startsWith("Hello world on "));
    }
}
