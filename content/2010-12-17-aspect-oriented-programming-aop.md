---
author: imesh
comments: true
date: 2010-12-17 10:12:00+00:00
layout: post
slug: aspect-oriented-programming-aop
title: Aspect Oriented Programming (AOP)
wordpress_id: 100
categories:
- Blog
---

Aspect Oriented Programming (AOP) is a programming design that addresses a dimension which Object Oriented Programming (OOP) has not considered in developing software. According to AOP expert Philip Laureano it is the time line of the Objects. As I understood once we write a Class, its properties and methods in OOP we don't have any control to the life cycle of the method calls or property access. So if we need to execute some method calls before calling a method or after calling the method we will have to manually add more lines inside the method implementation. In a complex application it will be tedious process to do. Therefore the idea of AOP is to have a separate block of code called Aspect which can monitor a given class and hook into methods life cycles. So the Aspect can be programmed to trigger on different events of a given method call.




To learn more about AOP I found a nice Pod Cast done by Scott Hanselman with Philip Laureano:




[http://s3.amazonaws.com/hanselminutes/hanselminutes_0213.mp3](http://s3.amazonaws.com/hanselminutes/hanselminutes_0213.mp3)
