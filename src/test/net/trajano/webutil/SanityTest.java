package net.trajano.webutil;

import junit.framework.TestCase;

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
}
