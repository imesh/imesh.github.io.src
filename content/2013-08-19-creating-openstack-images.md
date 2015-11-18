---
author: imesh
comments: true
date: 2013-08-19 09:56:00+00:00
layout: post
slug: creating-openstack-images
title: Creating OpenStack Images
wordpress_id: 86
categories:
- Blog
tags:
- open-stack
---

The official documentation for creating OpenStack images from an ISO can be found [here](http://docs.openstack.org/image-guide/content/ch_creating_images_manually.html). In this article we will discuss how to create an image from a running instance and how to upload an existing image file to an OpenStack instance.

To create a new VM image from a running VM instance we first need to install client tools.



#### Install Client Tools for Nova, Glance & Swift:




Execute the below command to install nova-client, glance-client and swift on an Ubuntu host. If its a different operating system please refer [OpenStack documentation](http://docs.openstack.org/user-guide/content/install_clients.html) for details.


[code] sudo apt-get install python-novaclient python-glanceclient swift [/code]



#### List Running Instances:




Next execute the below command to list the running instances.


[code] nova list [/code]



#### Create an Image from a Running Instance:




Select the instance that needs to be exported as an image and execute the below command.


[code] nova create-image <image-id> <new-image-name> [/code]



#### Download an Image to Disk:




Execute the below command to download the created image as a file.


[code] glance image-download <image-id> --file <file-name>.img [/code]



#### Create an Image from an Image File:




Now if you want to upload an existing image file to an OpenStack instance execute the below command.


[code] glance image-create --name="image-name" --is-public=false --container-format=ami --disk-format=ami < file-name.img [/code]

**Notes:**
OpenStack Grizzly release has following components: Object Store (Swift), Image Store (Glance), Compute (Nova), Dashboard (Horizon), Identity (Keystone), Network (Quantum) and Block Storage (Cinder).

 
