---
author: imesh
comments: true
date: 2011-03-08 17:44:00+00:00
layout: post
slug: how-to-run-a-rpm-on-ubuntu
title: How To Run A RPM on Ubuntu
wordpress_id: 97
categories:
- Blog
---

If you download a [RPM](http://en.wikipedia.org/wiki/RPM_Package_Manager) (Redhat Package Manager) file and wondering how to install it on a Debian Linux distribution like Ubuntu there is a simple solution for that.

As Debian distributions normally use [DEB](http://en.wikipedia.org/wiki/Deb_(file_format)) package format for installing software there is an application called Alien which allows us to convert RPM files to DEB format. This is cool.

1. Install Alien application
````
>sudo apt-get install alien
````

2. Convert your RPM package to DEB
````
>sudo alien -k <application_name>.rpm
````

This will create a new DEB file in the same folder called <application_name>.deb.
