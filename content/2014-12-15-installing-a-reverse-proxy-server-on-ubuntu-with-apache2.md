---
author: imesh
comments: true
date: 2014-12-15 08:25:54+00:00
layout: post
slug: installing-a-reverse-proxy-server-on-ubuntu-with-apache2
title: Installing A Reverse Proxy Server on Ubuntu with Apache2
wordpress_id: 307
categories:
- Blog
---

Update package lists:
[code]
apt-get update
[/code]

Install Apache2 with mod_proxy:
[code]
sudo apt-get install libapache2-mod-proxy-html
[/code]

Install libxml2 module:
[code]
apt-get install libxml2-dev
[/code]

Add following configuration to the /etc/apache2/apache2.conf file:
[code]
LoadModule  proxy_module         /usr/lib/apache2/modules/mod_proxy.so
LoadModule  proxy_http_module    /usr/lib/apache2/modules/mod_proxy_http.so
LoadModule  headers_module       /usr/lib/apache2/modules/mod_headers.so
LoadModule  deflate_module       /usr/lib/apache2/modules/mod_deflate.so
LoadFile    /usr/lib/x86_64-linux-gnu/libxml2.so
[/code]

Add a sample reverse proxy configuration to the same file:
[code]
ProxyPass /imesh http://imesh.gunaratne.org
ProxyPassReverse /imesh http://imesh.gunaratne.org
[/code]

Restart Apache2:
[code]
/etc/init.d/apache2 restart
[/code]

References:
http://httpd.apache.org/docs/2.2/mod/mod_proxy.html
https://abhirama.wordpress.com/2008/11/03/apache-mod_proxy-in-ubuntu/
