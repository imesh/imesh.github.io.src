---
author: imesh
comments: true
date: 2013-04-14 17:00:00+00:00
layout: post
slug: running-monoscape-on-openstack
title: Running Monoscape on OpenStack
wordpress_id: 89
categories:
- Blog
tags:
- monoscape
- openstack
---

Since it's inception Monoscape was built on top of OpenStack IaaS. This was around early 2011. During this time OpenStack had only a minimal set of features and components like Nova - Compute, Swift - Object Storage, Glance - Image Service and a very basic web interface. It even didn't had a proper installation process, most people used Stackops distributions. In contrast today OpenStack is a very matured product. Now it has many componenets ([Ceilometer](http://docs.openstack.org/developer/ceilometer/) - Billing, Cinder - Block Storage, Glance - Image Service, [Heat](https://wiki.openstack.org/wiki/Heat) - AWS CloudFormation, Horizon - Dashboard, Keystone - Identity Management, Nova - Compute, Quantum and Swift) including a rich set of features and a well defined installation process. Still Stackops provide easy to use distributions for OpenStack packaged with Ubuntu Server but I think they are no longer necessary. One major security issue I noticed with Stackops installation process is that they store client's configuration information in their severs online.




If you are trying out OpenStack for the first time you could use a Virtual Machine (VM) on Oracle VirtualBox or any other VM platform. However you may need to make sure that you use a physical machine with at least 8GB of memory running with a high end processor. So that you could provide nearly 4 GB of memory to the VM and around 10 GB of dynamic disk space.




**How to install OpenStack**







  * Download and install Ubuntu 12.04.2 LTS (Precise Pangolin) server x64 from http://releases.ubuntu.com.


  * Install Git using following command: > sudo apt-get install git


  * Download OpenStack installation script from from its git repository using the following command: > git clone git://github.com/openstack-dev/devstack.git


  * Run stack.sh script. This script will install MySQL, RabitMQ and many other required software. Then the OpenStack compoenents will be configured with the given user preferences on a single node.


  * Once the installation is complete try to login to Horizon via http://host-ip/ using the administrative user ('admin') and the password given at the installation time. If you could not remember the password by any chance you could find it inside the devstack installation folder written to a text file.


  * One important point to note on this relase of OpenStack is that the IP address of the host could be dynamic. Earlier it used to be static with Stackops.





Once OpenStack is up and running you could start installing Monoscape. However you may need to note that Keystone, OpenStack identity management service does not start automatically in this release as the operating system starts up. Therefore you may need to manually start it using the script created inside devstack folder. That's the only problem I found so far with the latest dev release.




Monoscape could be installed on a separate physical or virtual machine. First of all download source code from htttps://github.com/monoscape and build it using Mono. A shell script for building all the components could be found in the root folder.




**How to install Monoscape**







  * Create a new OpenStack user account for monoscape to access the EC2 API.


  * Find EC2 authentication details (secret key and access key) for the above user from the IaaS dashboard. 


  * Update Monoscape Application Grid Controller configuraiton file with the above information.


  * Start Monoscape Load Balancer using start-load-balancer.sh shell script.


  * Start Monoscape Application Grid using start-application-grid.sh shell script.


  * Start Monoscape Dashboard using start-dashboard.sh shell script.


  * Login to Monoscape Dashboard using http://host-ip:8080 and verify IaaS authentication status.


  * Create a new key for a EC2 image of Ubuntu 12.04 server and start an instance.


  * Copy Monoscape Node Controller to the above VM instance.


  * Update Monoscape Node Controller configuration file with the IP address of the application grid.


  * Export the above instance of the VM and import it to the IaaS using the same key.


  * Login to Monoscape Dashboard and upload Mono applications to be deployed in the PaaS.


  * Start an application and do a sanity test to see whether its is working.





If you have any concerns or comments about Monoscape or its installation, please do not hesitate to add a comment line to this post.







**References:**




OpenStack Documentation - http://docs.openstack.org/install  
Deploying OpenStack for Developers - http://devstack.org
