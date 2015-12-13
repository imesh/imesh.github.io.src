---
author: imesh
comments: true
date: 2014-06-22 19:32:40+00:00
layout: post
slug: install-stratos-in-one-go
title: Install Stratos in One Go
wordpress_id: 269
categories:
- Blog
tags:
- apache
- stratos
- paas
---

Apache Stratos 4.0.0 [installation process](https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Installation+Guide) has series of manual steps; installing prerequisites, downloading source and binary packages, installing and configuring puppet master, configuring Stratos products, etc. I think it is a waste of time to do all these steps over an over again when setting up Stratos development or demo environments.

As a solution to this, I implemented a script to automate the complete Stratos installation process by filling the gaps in between:


#### Prerequisites:

- An Ubuntu 12.04 64bit host
- Git client


#### Steps to follow:

1. Take a git clone of the below git repository:

````
git clone https://github.com/imesh/stratos-dev-stack.git
````

2. Update install.sh with host private IP and IaaS configuration parameters:

````
host_private_ip=""
ec2_identity="identity"
ec2_credential="credential"
ec2_keypair_name="keypair-name"
ec2_owner_id="owner-id"
ec2_availability_zone="availability-zone"
ec2_security_groups="security-groups"
````

3. Grant install.sh executable access:

````
chmod +x install.sh
````

4. Run install.sh with root permissions:

````
sudo ./install.sh
````

This will download and install Stratos source/binary packages, Java, MySQL connector, ActiveMQ, puppet master and configure all of them with default configuration settings. Once the process is complete it will start MySQL server, Active MQ and Stratos.

Stratos dashboard URL could be found at the below link:

````
https://<hostname>:9443/console
````

In addition to Stratos installation we need to create a base cartridge image. This will act as the base image for all the cartridges. To start with spawn another instance of Ubuntu 12.04 64bit image and run the below script with root permissions. In this process we do not need to do any configurations, it will download and install all prerequisites and puppet agent:

````
cd /tmp
wget https://gist.githubusercontent.com/imesh/f8fd7a40d89dd4b60898/raw/48087c76b853632cf12474ba909bc355fe861666/cartridge-creator.sh 
chmod +x cartridge-creator.sh
sudo ./cartridge-creator.sh
````

During this process it will prompt you to enter the puppet master IP, puppet master hostname, and service name, for those please enter the following:

````
Puppet master IP: IP of the Stratos host
Puppet master hostname: puppet.stratos.org
Service name: default
````

Once cartridge creation process is completed create an image from the running VM instance. Thereafter find the image id of the created image and use it as the cartridge image id in each [cartridge definition](https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Sample+Cartridge+Definition).

