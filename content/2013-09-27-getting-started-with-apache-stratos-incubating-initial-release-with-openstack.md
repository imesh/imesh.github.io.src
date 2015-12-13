---
author: imesh
comments: true
date: 2013-09-27 09:50:00+00:00
layout: post
slug: getting-started-with-apache-stratos-incubating-initial-release-with-openstack
title: Getting Started with Apache Stratos (Incubating) Initial Release with Openstack
wordpress_id: 83
categories:
- Blog
tags:
- apache
- stratos
---

Apache Stratos (incubating) is now ready with it’s initial release. A new Git branch has been created for this release with the name “3.0.0-incubating-x”. Please note that "x" refers to the RC version. Please refer the project wiki for detailed information about this release. To start with, first we need to get the binary distribution of Apache Stratos. We could either build it from source or download the officially released files from svn.


#### How to Build From Source:

You could follow the below steps to build the binary distribution from source:

````
git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git
git checkout 3.0.0-incubation-x
cd incubator-stratos
mvn clean install
````

This process will checkout the source files from 3.0.0-incubating-x branch and build using maven. Once the build is completed you could find the binary packages at the following locations:

````
incubator-stratos/products/stratos-cli/distribution/target/apache-stratos-cli-3.0.0-incubating-x.zip
incubator-stratos/products/cloud-controller/modules/distribution/target/apache-stratos-cc-3.0.0-incubating-x.zip
incubator-stratos/products/stratos-controller/modules/distribution/target/apache-stratos-sc-3.0.0-incubating-x.zip
incubator-stratos/products/elb/modules/distribution/target/apache-stratos-elb-3.0.0-incubating-x.zip
incubator-stratos/products/stratos-agent/distribution/target/apache-stratos-agent-3.0.0-incubating-x.zip
````
 

#### Download Binary Distributions:

Please find the official binary packages at the blow location. Select the latest RC version and download the files.

````
https://dist.apache.org/repos/dist/dev/incubator/stratos/
````
 

#### Download Openstack Cartridge Images:

Once the binary distribution is in place we need to prepare Stratos cartridge images according to the preferred Infrastructure as a Service (IaaS) platform. Here I have created Apache Tomcat, PHP and MySQL cartridge images for Openstack. You could download those image files from the following URLs:

````
stratos-3.0.0-incubating-tomcat-cartridge.img.zip
stratos-3.0.0-incubating-php-cartridge.img.zip
stratos-3.0.0-incubating-mysql-cartridge.img.zip
````
 

#### Upload Cartridge Images to Openstack:

1. The glance client could be used for uploading the above image files to an Openstack instance. Execute the below command to install glance client:

````
sudo apt-get install python-novaclient python-glanceclient swift
````

2. Then download EC2 credentials from Openstack Dashboard and source the openrc.sh file:
````
source /openrc.sh
````

3. Once cartridge images are downloaded execute the below command to upload them via glance. Here the glance client will use the above EC2 credentials to connect to the Openstack instance.

````
glance image-create --name="stratos-3.0.0-incubating--tomcat-cartridge" --is-public=true --container-format=ami --disk-format=ami < stratos-3.0.0-incubating-tomcat-cartridge.img
glance image-create --name="stratos-3.0.0-incubating-mysql-cartridge" --is-public=true --container-format=ami --disk-format=ami < stratos-3.0.0-incubating-mysql-cartridge.img
glance image-create --name="stratos-3.0.0-incubating-php-cartridge" --is-public=true --container-format=ami --disk-format=ami < stratos-3.0.0-incubating-php-cartridge.img
````
 

#### Prepare Stratos Installer

1. Now take a copy of the Stratos installer from it’s source repository’s tools folder:

````
git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git
git checkout 3.0.0-incubation-x
cd incubator-stratos/tools/stratos-installer
````

This folder contains scripts for installing Apache Stratos on a given environment. First configure the required settings in setup.conf file found under conf directory:

````
vi conf/setup.conf
````

2. Configure general information section with the below parameter values:

````
export setup_path= #Folder path containing stratos_setup
export stratos_pack_path= #Folder path containing stratos packages 
export stratos_path= #Folder which stratos will be installed
export JAVA_HOME= #Java home path
export hostip="" #Machine ip on which setup script run
export host_user="" #A host user account for stratos.
export mysql_connector_jar=$stratos_pack_path/"mysql-connector-java-5.1.25.jar" #mysql connector jar file name
````

3. Configure Openstack section with following parameter values. One important thing to note here is that openstack_provider_enabled property enables Openstack IaaS in Stratos. Therefore in this specific scenario you may need to set ec2_provider_enabled property to false.


# Openstack

````
export openstack_provider_enabled=true
export openstack_identity="stratos:stratos" #Openstack project name:Openstack login user
export openstack_credential="password" #Openstack login password
export openstack_tenant="stratos" #Openstack project name
export openstack_jclouds_endpoint="http://hostname:5000/v2.0" #Openstack Keystone URL
export openstack_scaleup_order=2
export openstack_scaledown_order=3
export openstack_keypair_name="" #Create a new keypair and add the name here
export nova_region="RegionOne" #Openstack region used for spawning cartridge instances
export openstack_instance_type_tiny="RegionOne\/1"
export openstack_instance_type_small="RegionOne\/2"
export openstack_security_groups="security-groups"
export openstack_php_cartridge_image_id="" #Openstack PHP Cartridge Image ID
export openstack_mysql_cartridge_image_id="" #Openstack MySQL Cartridge Image ID
export openstack_tomcat_cartridge_image_id="" #Openstack Apache Tomcat Cartridge Image ID
````

4. Install following pre-requisite software:

````
java -jdk1.6.x   
Git
facter   
zip
mysql-server
Gitblits
````
    
5. Download WSO2 Message Broker (MB) binary distribution from http://wso2.com/products/message-broker/ and copy it to stratos-pack-path. Here you could use any preferred message broker product which supports AMQP.

6. Extract MB distribution in stratos-path and set it's port offset in repository/conf/carbon.xml to 5. This will set the actual MB port to 5677.

7. Add the following entries to the /etc/hosts file:

````
<ip-address> stratos.apache.org        # stratos domain
<ip-address> mb.stratos.apache.org     # message broker hostname
<ip-address> cc.stratos.apache.org     # cloud controller hostname
<ip-address> sc.stratos.apache.org     # stratos controller hostname
<ip-address> elb.stratos.apache.org    # elastic load balancer hostname
<ip-address> agent.stratos.apache.org  # agent hostname
````



#### Install Apache Stratos

1. Once the above configuration is done, execute the below command to install Stratos at the given path (stratos_path):

````
sudo ./setup.sh -p "elb sc cc agent"
````

2. At the end of the installation it will prompt to start all the servers in the background, you could say no to this question and start the server manually so that you have more control over the initial Stratos environment. More importantly if any configuration errors has occurred, you should be able to rectify them more easily.

````
sh $stratos_path/<module>/bin/stratos.sh 
````

3. Now carefully watch the logs of Elastic Load Balancer (ELB), Stratos Controller (SC), Cloud Controller (CC) and Stratos Agent. Those logs could be found at the following location of each module. Each should have started successfully without any problems.

````
$stratos_path/<module>/repository/logs/wso2carbon.log
````
 

#### Verify Apache Stratos Installation

1. Now login to Stratos Controller using admin/admin and create a tenant user at the below URL:

````
https://sc.stratos.apache.org:9445/carbon
````

2. Login again to Stratos Controller using the tenant user and subscribe to a cartridge. Here you might need to use a Git repository to point to an application to be deployed on Stratos PaaS. This process should spin up a new instance of relevant cartridge and update the status on cartridge subscription list. Once the cartridge is ready you could test the deployed application by using its URL.
