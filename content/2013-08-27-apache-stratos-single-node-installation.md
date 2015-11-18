---
author: imesh
comments: true
date: 2013-08-27 18:07:00+00:00
layout: post
slug: apache-stratos-single-node-installation
title: Apache Stratos Single Node Installation
wordpress_id: 85
categories:
- Blog
tags:
- solution-architecture
- stratos
---

![](http://rootfolder.info/a/1/images/ApacheStratos/stratos-single-node-architecture.png)

[Based on Apache Stratos (incubating) 4.0.0-M5]

Apache Stratos is an enterprise grade Platform as a Service (PaaS) solution for implementing public and private clouds. It consists of five major components. They are, the Cloud Controller (CC), Stratos Controller (SC), Elastic Load Balancer (ELB), Stratos Agent and CLI. These products could be deployed on many different deployment architectures according to different requirements. A single node deployment could be used for development and demonstration purposes. Please follow the below steps to create a Apache Stratos single node instance.


### Prerequisites


1. An IaaS supported by jclouds API.
2. A Linux server distribution. Ubuntu Server 13.04 x64 is recommended.
3. Java runtime 1.6 (Oracle JDK/JRE).
4. MySQL Server 5.5 database server.
5. MySQL Connector for Java (JAR file).
6. Unzip utility.
7. A physical/virtual machine with minimum of 8GB of RAM and 20GB of disk space.


### Pre-Installation


1. Install the preferred Linux server distribution on the selected host.
2. Install Java runtime, MySQL Server and Unzip utility.
3. Connect the host to a network where the IaaS is accessible. Make sure that a VM instance in the IaaS could access the Stratos host.
4. Login to the IaaS and create an authentication key.
5. Then create a security group with all TCP, UDP and ICMP ports open. Please note that this is only used for demonstration purposes. In a production environment please ensure that only required ports are opened via the security group.
6. Either download cartridge images for the selected IaaS platform from the Apache Stratos website or create your own.
7. Upload cartridge images to the IaaS.
8. Create a new folder to store the binary distributions:
9. Download WSO2 Message Broker (MB) binary distribution from http://wso2.com and copy it to .
10. Download Apache Stratos binary packages from the website or build them from source.

**How to build from source:**
[code]
git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git
cd incubator-stratos
mvn clean install
cp stratos/products/cloud-controller/modules/distribution/target/apache-stratos-cc-.zip
cp stratos/products/stratos-controller/modules/distribution/target/apache-stratos-sc-.zip
cp stratos/products/elb/modules/distribution/target/apache-stratos-elb-.zip
cp incubator-stratos/products/stratos-agent/distribution/target/apache-stratos-agent-.zip
[/code]

11. Create a new MySQL database user for stratos.
12. Copy Stratos Installer from incubator-stratos/tools/stratos-installer to a desired path.



### Installation


1. Extract WSO2 Message Broker (MB) on the installation path and set it’s port offset value in repository/conf/carbon.xml to 5. Once this is set message broker listening port will be 5677.
2. Update stratos-installer/conf/setup.conf and define all configuration parameters. This is one of the crucial steps of the installation. The configuration has divided into following sections; General, Message Broker, Cloud Controller, Stratos Controller, Elastic Load Balancer, Stratos Agent and IaaS. All these sections should be precisely configured.
3. Execute sudo JAVA_HOME=$JAVA_HOME stratos-installer/setup.sh -p “cc sc elb agent”

This script will extract stratos packages to the given installation path, create stratos_foundation and userstore databases and configure all four products with the given parameter values. Once it is prompted to start the servers, you may say no and start them manually. So that you have more control and visibility over the system.

It is recommended to start the servers on the following order; MB, CC, SC, ELB and finally the Agent. Wait until each product is started successfully to start the next. Once all servers are started, make sure that none of the server logs have errors on them. If you could see any errors, you may need to first correct them before proceeding further.



### Post Installation (Verification)



1. Find the URL of the stratos controller from it’s log and open it on a web browser. The default URL would be https://{host-name}:9445/carbon and administrator user credentials are admin/admin.
2. Login to the stratos controller and create a new tenant.
3. Logout from the administrator account and login again to the stratos controller using the tenant user created. Here you may need to use the tenant user’s email address as the username.
4. Click on the Single Tenant Cartridges menu item on the navigator. Check whether you could see any cartridges populated on this page. If not there could be errors raised on cloud controller log with related to the IaaS configuration in cloud-controller.xml or cartridge definitions specified in <cartridge>.xml files. Please go through them and try to correct the errors.
5. Subscribe to an available cartridge using an external git repository. This process may take some time depending on the resources available in the IaaS. If subscription process is successful you should see the cartridge instance state as ACTIVE.
6. Now the applications deployed via the git repository should be available in the cloud to be accessed by a client.



### Removal


[code]
sudo ./clean.sh -a mysql-username -b mysql-password
[/code]

This script will drop all Stratos databases created, remove any logs available and remove CC, SC, ELB and Agent content. You may run this script on your own risk.

