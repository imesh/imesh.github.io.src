---
author: imesh
comments: true
date: 2014-08-27 16:28:09+00:00
layout: post
slug: re-writing-query-parameters-in-wso2-esb
title: Re-Writing Query Parameters in WSO2 ESB
wordpress_id: 280
categories:
- Blog
tags:
- wso2-esb
---

The following code sample shows how to re-write a query parameter in an URL in WSO2 ESB. This technique might be useful when dynamically handling endpoint URLs.

````
<property name="URL" value="http://host:8280?p1=abc&amp;p2=qwe"/>
<filter source="$ctx:URL" regex=".*format=.*">
    <then>
         <!-- format query parameter found in URL, replace it -->
         <property name="URL_UPDATED"
                   expression="replace($ctx:URL, 'format=([^&amp;]*)', 'format=xml')"/>
    </then>
    <else>
         <!-- format query parameter not found in URL, add it -->
         <property name="URL_UPDATED" 
                   expression="concat($ctx:URL, '&amp;format=xml')"/>
    </else>
</filter>
<log level="custom">
    <property name="-- original --" expression="$ctx:URL"/>
    <property name="-- updated --" expression="$ctx:URL_UPDATED"/>
</log>
````
