---
author: imesh
comments: true
date: 2013-08-19 01:42:00+00:00
layout: post
slug: apache-stratos-in-a-nutshell
title: Apache Stratos in a Nutshell
wordpress_id: 87
categories:
- Blog
tags:
- cloud
- paas
- stratos
---

![](http://imesh.io/images/ApacheStratos/stratos-logo.png)

[Based on Apache Stratos 3.0.0]

[Apache Stratos](http://stratos.incubator.apache.org) is an open source, enterprise grade Platform as a Service (PaaS) cloud platform built with open standards. Stratos was originally developed by WSO2 and very recently donated to Apache Software Foundation (ASF) with the vision of making it the most open PaaS framework in the market by involving a wide range of organizations and individuals to design and implement it’s features at their best [1].

This might be a great start of a long journey on making an industry standard PaaS solution. Few years back a similar  action was taken by NASA and Rackspace when they decided to start the OpenStack project by donating NASA's Nebula platform and Rackspace's Cloud Files platform at a time where there was no open & industry standard Infrastructure as a Service (IaaS) solution available. By now there are over 200 organizations contributing to OpenStack [2] and many cloud vendors using it as their de facto standard IaaS.



## Open Standards

### OSGi for Modular Architecture

At it’s core Apache Stratos is built using OSGi’s [3] dynamic modular architecture. OSGi is one of the best or may be the only industry proven standard for implementing true component based Java applications until JSR 277 [4] was implemented. The core benifit of using a such standard is that, applications could extend their features without having to change the entire system [5]. The complete Stratos PaaS has been composed as a collection of OSGi modules. These modules have been grouped into four different categories as an extra step for improving the maintainability and readability of the platform. They are grouped as components, service stubs, features and products.

![](http://imesh.io/images/apachestratos/osgi-componenet-architecture.png)

The component modules are the lowest level implementation of the system functionality. Service stub modules include Axis2 web service client stubs for accessing services. The service implementation is done in each required component. Feature modules aggregate components and service stubs and exposes high level system features to the next level. A feature may also refer another feature. Finally a product module is made by aggregating a collection of selected features. In Apache Stratos currently there are five products; Cloud Controller (CC), Elastic Load Balancer (ELB), Stratos Controller (SC), Stratos Agent and Command Line Interface (CLI). This exceptional architectural design was inherited from OSGi modular architecture of WSO2 Carbon platform. Except for this model Carbon provides more extensive features like User Management, Security Management, Tenant Management, Clustering, SOA Governance, Centralized Logging, Web UI and many other supportive features for middleware related products [6].


### Apache Axis2, Synapse & Tribes for Service Implementation, Mediation & Clustering

At it’s next level Stratos make use of Apache Axis2, Axis2 Clustering and Apache Synapse for implementing web services, clustering and message mediation logic. Each product has implemented service APIs for communicating with other products for managing the cloud ecosystem. The load balancer module makes use of Apache Tribes group management framework as the messaging system for clustering the end points. Here the endpoints are known as cartridges which deploy cloud applications in OS level isolated environments. At the moment each cartridge is made out of a virtual machine instance in the IaaS. However there is a plan to improve this functionality by introducing LXC based virtualization to re-use VMs for creating multiple cartridges.


### Apache Qpid - AMQP for Messaging

Apache Qpid implements Advanced Message Queuing Protocol (AMQP) [7] as an open standard for reliable and high performance messaging [8]. Apache Stratos has used Apache Qpid for synchronizing cluster topology information between products using publish-subscribe pattern [9]. This includes cluster information of cartridges connected to the load balancer.


### jclouds API for IaaS Communication

JClouds provides a single, open standard REST API for accessing many different types of IaaS platforms [10]. Apache Stratos has used JClouds to ensure that it is loosely coupled with the underlying virtualized infrastructure. Currently JClouds supports Amazon EC2, OpenStack, VMWare vCloud, Rackspace and many other IaaS solutions.


### Git Version Controlling for Artifact Distribution

Application deployment is one of the key tasks in a PaaS. Stratos has achieved this functionality by using Git version controlling system. The application deployment packages (war files, php deployment distributions, etc) could be checked into a Git repository and the URL of the repo could be registered in the system.


## Logical Architecture

![](http://imesh.io/images/ApacheStratos/apache-stratos-logical-architecture.png)


### Cloud Controller (CC)

Cloud Controller is the main access point to the IaaS. It make use of JClouds API for communicating with many different IaaS platforms. One of the key features of Stratos PaaS is that it could be connected to multiple IaaSs concurrently and implement heterogeneous cloud solutions. For an example, an organization could subscribe to a public and a private IaaS at the same time and configure Cloud Controller IaaS policies to ensure which IaaS to be utilized most. Moreover Cloud Controller is the central storage point of cluster topology information of all products.

### Elastic Load Balancer (ELB)

As the name implies ELB is the load balancing module of Apache Stratos PaaS. It constitutes of Apache Synapse mediation framework, Apache Axis2 clustering, Apache Tribes group management messaging framework and an auto-scaling module implemented using Carbon. Once an application is deployed on a cartridge, it connects to the ELB via the Stratos Agent with Axis2 clustering. This clustering configuration is dynamically managed by the ELB. Each cartridge subscription will have it’s own cluster and all cartridge instances created for scaling functionality will be automatically added to the same cluster. Each cluster could be uniquely identified by it’s domain name given at the time the subscription is made.

All incoming requests of applications are managed in a request queue and monitored by the autoscaler module. The autoscaler module uses a Synapse in-mediator, task and an out-mediator [11] for handling this functionality. According to the scaling rules defined, autoscaler will scale number of instances of applications via the Cloud Controller. In-addition, the ELB keeps a track of session information of messages and routes them to relevant application instances if available.


### Stratos Agent

Stratos Agent’s responsibility is to provide cluster registration functionality for cartridges. Any cartridge which does not have clustering support used by the ELB could go through the agent to subscribe to the PaaS.


### Stratos Controller (SC)

Stratos Controller consists of three main components; the Dashboard, Artifact Distribution Coordinator (ADC) and Autoscaling Policy Manager. The dashboard provides features for managing tenants, cartridge subscriptions, users and roles, single sign-on features based on Security Assertion Markup Language (SAML) [13], registry, metering and key stores. In Stratos each application deployment package is known as an artifact. The responsibility of the ADC is to synchronize artifacts from it’s source Git repository to the cartridge instances. This process is triggered automatically whenever a commit is made to the remote repo or else it could also be triggered manually via the dashboard. The Autoscaling Policy Manager maintains policy rules for managing the auto scaling process in the ELB.


### Command Line Interface (CLI)

The Command Line Interface (CLI) provides same set of features given by the dashboard on the shell. It could be operated in two modes; they are the Interactive Mode and Single Command line Mode. The interactive mode could be used by a human to execute commands against the SC and the single command line could be used by a machine to execute a command script.


### Cartridges

A cartridge is a virtual machine image on an IaaS which has software components to interact with the Stratos PaaS. Out of the box Apache Stratos provide cartridges for PHP, MySQL and Tomcat based applications on OpenStack and Amazon EC2. More importantly a custom cartridge for any other platform could be created with the given set of tools. The documentation for cartridge creation process could be found here [14]. Even though this process sounds tedious it provides a very secure, OS level isolated environment for cloud applications.

**References**:

[1] [http://wso2.com/blogs/thesource/2013/06/what-the-you-just-gave-away-wso2-stratos](http://wso2.com/blogs/thesource/2013/06/what-the-you-just-gave-away-wso2-stratos)
[2] [http://en.wikipedia.org/wiki/OpenStack](http://en.wikipedia.org/wiki/OpenStack)
[3] [http://en.wikipedia.org/wiki/OSGi](http://en.wikipedia.org/wiki/OSGi)
[4] [http://jcp.org/en/jsr/detail?id=277](http://jcp.org/en/jsr/detail?id=277)
[5] [http://www.osgi.org/Technology/WhatIsOSGi](http://www.osgi.org/Technology/WhatIsOSGi)
[6] [http://wso2.com/products/carbon](http://wso2.com/products/carbon)
[7] [http://qpid.apache.org](http://qpid.apache.org)
[8] [http://qpid.apache.org/amqp.html](http://qpid.apache.org/amqp.html)
[9] [http://en.wikipedia.org/wiki/Publish–subscribe_pattern](http://en.wikipedia.org/wiki/Publish–subscribe_pattern)
[10] [https://github.com/jclouds/jclouds](https://github.com/jclouds/jclouds)
[11] [http://synapse.apache.org/userguide/mediators.html](http://synapse.apache.org/userguide/mediators.html)
[12] [http://en.wikipedia.org/wiki/Security_Assertion_Markup_Language](http://en.wikipedia.org/wiki/Security_Assertion_Markup_Language)
[13] [https://cwiki.apache.org/confluence/display/STRATOS](https://cwiki.apache.org/confluence/display/STRATOS)
[14] [http://blog.afkham.org/2011/09/wso2-load-balancer-how-it-works.html](http://blog.afkham.org/2011/09/wso2-load-balancer-how-it-works.html)
