---
author: imesh
comments: true
date: 2014-12-22 18:03:42+00:00
layout: post
slug: introduction-to-apache-stratos-mock-iaas
title: Introduction to Apache Stratos Mock IaaS
wordpress_id: 310
categories:
- Blog
---

Apache Stratos supports many Infrastructure as a Service (IaaS) platforms; EC2, OpenStack, VCloud, CloudStack, Docker, etc. However setting up an IaaS or purchasing a public IaaS service is an overhead for contributors and people who would like to tryout Stratos; setting up a local IaaS needs considerable amount of hardware resources and purchasing an online IaaS account involves costs. These are some of the major barriers Stratos community had for last year or so for implementing automated integration tests, bringing in new contributors and allowing people to tryout Stratos with less effort.

Once Stratos introduced Linux Container support with Docker/Kubernetes this problem was solved up to some extent. Nevertheless setting up a Kubernetes cluster also requires several virtual/physical machines and setting up a puppet master (or any other orchestration platform) is an overhead. Very recently when we introduced the Composite Application feature for grouping cartridges this problem became much worse due to the complexity of the logic implemented and the time it took to verify each functionality with above IaaS platforms.

As a solution to this problem we introduced a Mock IaaS feature which could simulate the basic features that Stratos requires from an IaaS. The below diagram illustrates the component architecture of the Mock IaaS:

[![Mock IaaS Component Architecture-2](http://imesh.gunaratne.org/wp-content/uploads/2014/12/Mock-IaaS-Component-Architecture-2.png)](http://imesh.gunaratne.org/wp-content/uploads/2014/12/Mock-IaaS-Component-Architecture-2.png)

_Figure: Mock IaaS Component Architecture_

**Stratos IaaS Interface**

Stratos provides an abstraction layer for implementing support for Infrastructure as a Service platforms. This is a generic interface that includes following features:

  * Start an instance
  * Send user-data/payload parameters to instances
  * Attach network interfaces to instances
  * Allocate public IP addresses to network interfaces
  * Attach storage (volumes) to instances
  * Terminate an instance

In Stratos 4.0.0 release this interface did not include some of the methods for interacting with the IaaS rather those were directly invoked via the jclouds compute service API. With the introduction of the Mock IaaS all the methods required to communicate with the IaaS were moved to the IaaS interface and jclouds specific logic were moved to a separate class called JcloudsIaas. Now this IaaS interface is implemented by the Mock IaaS client and Jclouds IaaS client (JcloudsIaas). Jclouds IaaS client is further extended by EC2, OpenStack, VCloud, CloudStack, Docker providers.

**How Mock IaaS Works**

Mock IaaS service simulates the lifecycle of an instance using a thread. Each instance will have a separate thread which publishes instance status events to message broker and health statistics to Complex Event Processor (CEP). Once a mock member thread is started it will publish Instance Started event to message broker and in several seconds it will publish the Instance Activated event. Thereafter the health statistics publisher will be started. It will read statistics from a singleton health statistics map which is updated by the health statistics generator.

Health statistics generator updates the health statistics map according to the statistics patterns defined in the Mock IaaS configuration. The following sample Mock IaaS configuration illustrates how these patterns could be defined for different cartridges:

````
<mock-iaas enabled="true">
   <health-statistics>
       <cartridge type="tomcat">
           <!-- factor:memory-consumption|load-average|request-in-flight-->
           <!-- mode:loop|continue|stop -->
           <!-- Mode defines the action needs to be taken after the last sample value:
                loop: start from beginning
                continue: continue the last sample value
                stop: stop publishing statistics -->
           <pattern factor="memory-consumption" mode="continue">
               <!-- Sample values -->
               <sampleValues>20,30,40,50,60,70,50,40,30,20</sampleValues>
               <!-- Duration of each sample value in seconds -->
               <sampleDuration>60</sampleDuration>
           </pattern>
           <pattern factor="load-average" mode="continue">
               <!-- Sample values -->
               <sampleValues>20</sampleValues>
               <!-- Duration of each sample value in seconds -->
               <sampleDuration>60</sampleDuration>
           </pattern>
       </cartridge>
   </health-statistics>
</mock-iaas>
````

In the above sample we have defined a health statistics generation pattern for tomcat cartridge. Similarly we can define multiple health statistics generation patterns for different cartridges. Under each cartridge its possible to define three different autoscaling factors: memory-consumption|load-average|request-in-flight. Mock health statistics generator will generate statistics for each factor for the given cartridge and update the central health statistics map. In each pattern mode attribute defines the action that needs to be taken once the last sample value is reached. If this is set to loop, mock health statistics generator will loop back to the first value. If it is set to continue the last sample value will be continued. If it is set to stop, health statistics generation process will be stopped and eventually health statistics publishing process will also stop. Finally the members in that cluster will become faulty.
