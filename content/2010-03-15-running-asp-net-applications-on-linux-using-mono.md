---
author: imesh
comments: true
date: 2010-03-15 18:40:00+00:00
layout: post
slug: running-asp-net-applications-on-linux-using-mono
title: Running ASP.NET Applications On Linux Using Mono
wordpress_id: 109
categories:
- Blog
---

ASP.NET is a Windows based web technology. However it's no more true, now we can run ASP.NET applications on a Linux environment using Mono Framework. Mono has developed a stand alone web server called Mono XSP for running ASP.NET applications on C# which can be run using Mono. Moreover it can be run on Apache web server using mod-mono Apache module.

At the moment Mono XSP2 supports ASP.NET 1.0 and 2.0 versions. Mono-Develop IDE can be used to design and implement web applications using C# and VB.NET. I tested Image Gallery on Mono XSP2 and noticed that the master page was not loaded due to the two upper case letters used. So I had to rename the master page ImageGallery.master to imagegallery.master to make it work. I'm not too sure why that happened may be the master page references are case sensitive.

Now with Mono XSP2 we have a complete software stack for running .NET Applications on Linux:

1. .NET Console Applications can run on Mono without doing any modifications.

2. .NET Windows Applications can be ported to GTK (Mono uses GTK for GUI implementation) and run on Mono.

3. ASP.NET Applications (including Web Services) can be directly run on Mono XSP2 without any modifications.

How to install Mono XSP2 on Ubuntu:

[code] sudo apt-get install mono-xsp2 mono-xsp2-base [/code]

Install Sample Web Applications:

[code] sudo apt-get install asp.net2-examples [/code]

Run The Web Server:

[code] xsp2 --root /usr/share/asp.net2-demos/ [/code]

Listening on address: 0.0.0.0

Root directory: /usr/share/asp.net2-demos

Listening on port: 8080 (non-secure)

Hit Return to stop the server.

Test On A Web Browser:

Open a web browser and go to http://localhost:8080. This should open asp.net2-demos web application.

References:

http://www.mono-project.com/ASP.NET

http://www.howtogeek.com/howto/ubuntu/run-aspnet-applications-on-ubuntu-for-developers/
