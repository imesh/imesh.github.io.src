---
author: imesh
comments: true
date: 2011-10-07 08:45:00+00:00
layout: post
slug: using-amazon-ec2-net-sdk-for-openstack
title: Using Amazon EC2 .NET SDK for Openstack
wordpress_id: 95
categories:
- Blog
---

The Amazon EC2 .NET SDK can be used to access [OpenStack](http://www.openstack.org/). However the current version (1.3.13.1) has a bug. It does not consider the port when preparing the signature for the request. Therefore you may see the request being failed in the OpenStack cloud controller with a signature mismatch error.

There is a [patch](https://forums.aws.amazon.com/thread.jspa?threadID=64825) released to fix this problem. Basically what it does is, include the custom port number if the IsDefaultPort property is set to false when preparing the signature based on the parameters.

**How to apply this patch:**

1. Download source files of the EC2 SDK from [http://aws.amazon.com/sdkfornet/](http://aws.amazon.com/sdkfornet/)
2. Open the project in Visual Studio.
3. Open the AWSSDKUtils.cs file found in Amazon.Util folder.
4. Add the below code block just after data.Append(endpoint.Host); line in CalculateStringToSignV2() method.

    <span class="kwrd">if</span> (!endpoint.IsDefaultPort)
    {
        data.Append(<span class="str">":"</span> + endpoint.Port);
    }
