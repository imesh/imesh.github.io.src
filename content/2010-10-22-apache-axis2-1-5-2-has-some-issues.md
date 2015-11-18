---
author: imesh
comments: true
date: 2010-10-22 15:42:00+00:00
layout: post
slug: apache-axis2-1-5-2-has-some-issues
title: Apache Axis2 1.5.2 Has Some Issues
wordpress_id: 102
categories:
- Blog
---

There is an issue in Apache Axis2 1.5.2 release (including 1.5, 1.5.1). The classes AxisServlet and AxisAdminServlet have been referred from **org.apache.axis2.transport.http** package in the web.xml file. I guess these have been moved to **org.apache.axis2.webapp** package after version 1.5.




Trace:




SEVERE: Error loading WebappClassLoader   context: /WebApp5   delegate: false   repositories:     /WEB-INF/classes/ ----------> Parent Classloader: org.apache.catalina.loader.StandardClassLoader@11ddcde org.apache.axis2.transport.http.AxisAdminServlet  java.lang.ClassNotFoundException: org.apache.axis2.transport.http.AxisAdminServlet 	at org.apache.catalina.loader.WebappClassLoader.loadClass(WebappClassLoader.java:1645) 	at org.apache.catalina.loader.WebappClassLoader.loadClass(WebappClassLoader.java:1491) 	at org.apache.catalina.core.StandardWrapper.loadServlet(StandardWrapper.java:1095) 	at org.apache.catalina.core.StandardWrapper.load(StandardWrapper.java:993) 	at org.apache.catalina.core.StandardContext.loadOnStartup(StandardContext.java:4350) 	at org.apache.catalina.core.StandardContext.start(StandardContext.java:4659) 	at org.apache.catalina.core.ContainerBase.start(ContainerBase.java:1045) 	at org.apache.catalina.core.StandardHost.start(StandardHost.java:785) 	at org.apache.catalina.core.ContainerBase.start(ContainerBase.java:1045) 	at org.apache.catalina.core.StandardEngine.start(StandardEngine.java:445) 	at org.apache.catalina.core.StandardService.start(StandardService.java:519) 	at org.apache.catalina.core.StandardServer.start(StandardServer.java:710) 	at org.apache.catalina.startup.Catalina.start(Catalina.java:581) 	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) 	at sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source) 	at sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source) 	at java.lang.reflect.Method.invoke(Unknown Source) 	at org.apache.catalina.startup.Bootstrap.start(Bootstrap.java:289) 	at org.apache.catalina.startup.Bootstrap.main(Bootstrap.java:414)
