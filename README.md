Utility JSPs
============

This provides a set of utility JSPs that can be used in debugging JNDI trees,
JMS, JDBC, EJBs and web applications. These JSPs are standalone and do 
not require any other deployable artifacts aside from being in a Java EE 5
container.

It uses [Bootstrap][1] and [JQuery][2] [CDNs][3] for styling purposes.

The JSPs can also be extracted and put into other projects that might 
have resources that are in the java: tree. 

The target audience for this tool is a Java EE application developer with
knowledge on how to deploy applications to the container.  Another
audience would be the testers as this provides direct access to the JMS and
JDBC resources that is available to the application.

Installation
------------

There is only the WAR distribution of this artifact as most Java EE containers
allow the deployment of a WAR without an EAR.

The WAR file can also be unzipped to get the JSPs which can be copied into an 
existing Java EE application.  

[1]: http://getbootstrap.com/
[2]: http://jquery.com/
[3]: http://www.bootstrapcdn.com/
