---
author: imesh
comments: true
date: 2007-10-01 11:44:00+00:00
layout: post
slug: what-is-an-openid
title: What is an OpenID?
wordpress_id: 152
categories:
- Blog
---

![](http://www.imeshonline.net/images/WhatIsAnOpenID/250px-OpenID_logo_svg.png)




An OpenID is a user identity (commonly known as a user id) which can be used to sign into different web sites without registering at each place where you required to login. I think this is an innovative concept but also there were very similar concepts being used before in web applications such as MSN ID. You can get your own OpenID for FREE by an OpenID service provider (which is an OpenID server), [http://www.openid.org/](http://www.openid.org/), [http://www.myopenid.com/](http://www.myopenid.com/). Once you register your own OpenID you can log into web sites which supports OpenID sign-on system. Most of the popular web sites and Content Management Systems (CMSs) are now being implementing OpenID support for their web sites like Wordpress. Those web sites will have an Open ID log in text box with the OpenID logo on the right hand side of it.




Once an OpenID is used to log into a web site it will validate the user id with the relevant OpenID server and prompt the user to enter his/her OpenID password at the OpenID server log in page. Then the user will be redirected back to the consumer web site if the password is valid. Most of the OpenID servers provide SSL on the log in page. Therefore the OpenID password will be sent to the OpenID server in a secure way.




I think this is a nice way to have a unique user id in different web sites without any hassle.
