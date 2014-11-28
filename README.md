Utility JSPs
============

This provides a set of utility JSPs and REST classes that can be used 
in debugging JNDI trees, JMS, JDBC, EJBs and web applications. These 
Classes and JSPs are standalone and do not require any other deployable 
artifacts aside from being in a Java EE 6 container.

It uses [Bootstrap][1] and [JQuery][2] [CDNs][3] for styling purposes.

The JSPs and Java classes can also be extracted and put into other 
projects that might have resources that are in the `java:` tree. 

The target audience for this tool is a Java EE application developer with
knowledge on how to deploy applications to the container.  Another
audience would be the testers as this provides direct access to the JMS and
JDBC resources that is available to the application.

Why are some files in Java?
---------------------------
Some files are in Java rather than stand alone JSPs (primarily using
REST services) as it would mostly be Java code and very little would've
been accessible using JSTL.

Installation
------------

There is only the WAR distribution of this artifact as most Java EE containers
allow the deployment of a WAR without an EAR.

The WAR file can also be unzipped to get the JSPs which can be copied into an 
existing Java EE application.  

[1]: http://getbootstrap.com/
[2]: http://jquery.com/
[3]: http://www.bootstrapcdn.com/
