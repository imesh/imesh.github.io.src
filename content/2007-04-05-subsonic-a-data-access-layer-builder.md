---
author: imesh
comments: true
date: 2007-04-05 11:22:00+00:00
layout: post
slug: subsonic-a-data-access-layer-builder
title: SubSonic A Data Access Layer Builder
wordpress_id: 173
categories:
- Blog
---

![](http://www.imeshonline.net/images/subsonic_logo.png)




[SubSonic](http://www.codeplex.com/Wiki/View.aspx?ProjectName=actionpack) is a utility toolset for .NET to generate a complete Data Access Layer (DAL) and Rails-like scaffolding (Data editing forms per table) based on the database design of your application. The DAL can be generated at the compile time for ASP.NET applications and it injects the code into the memory without writing the code to the disk. This makes web applications much simpler and the DAL will be up to date with the database every time the application is build. If you need the DAL to be written to disk it can be done using the SubSonic's web interface which will be useful to implement any other types of applications (ex: Windows Applications).




The most interesting part I noticed with SubSonic is that we do not need to write any SQL code or database connectivity code to manipulate data. The DAL it generates provides a comprehensive interface to do almost everything (Access to tables, views and stored procedures). We just need to write some configuration settings in the web configuration file including the database connection string. It is an [open source](http://www.opensource.org/) project and licensed under [Mozilla Public License](http://www.mozilla.org/MPL/) (MPL). 




At the end SubSonic realized me how important it is to refer different languages and see what they are keen on! _Have a look at _[_Ruby On Rails_](http://www.rubyonrails.org/). 




Thanks a lot [Merill](http://www.merill.net/) for the very useful presentation on SubSonic!
