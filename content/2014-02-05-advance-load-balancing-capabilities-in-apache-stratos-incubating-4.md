---
author: imesh
comments: true
date: 2014-02-05 22:38:00+00:00
layout: post
slug: advance-load-balancing-capabilities-in-apache-stratos-incubating-4
title: Advance Load Balancing Capabilities in Apache Stratos (incubating) 4
wordpress_id: 82
categories:
- Blog
tags:
- apache
- stratos
- load-balancing
---

In Apache Stratos (incubating) 4 architecture there are three different ways to configure load balancers for services. The idea of this functionality is to provide more optimized load balancing capabilities in a single PaaS deployment as required by different services.

### 1. Shared Scalable Load Balancing

In this load balancing mode a service would get access to a scalable load balancer/cluster shared among multiple services. The resulting load balancing solution may consume less IaaS resources and will be cost efficient for the service provider.

### 2. Dedicated Scalable Load Balancing for Services

If a service requires a high through put and low response time in load balancing it could request a dedicated scalable load balancer/cluster for its service. This load balancer/cluster will not be shared among any other services and will only be used with the given service. As a result it will use more IaaS resources than option 1 and may cost more.

### 3. Non Scalable Load Balancing

If the service provider does not need a scalable load balancing solution, they could either configure the auto-scaling policies to spawn one load balancer instance or go with a non scalable load balancer/cluster. In non scalable load balancing mode Stratos will not manage the load balancer instances rather it will provide required topology information via the message broker to configure its topology in runtime.

More importantly in each load balancing mode either Apache Stratos Load Balancer or any other load balancer with Apache Stratos Load Balancer Extension API could be used. I will be writing another article on the load balancer extension API and its usage soon.

The above load balancing modes could be configured in cartridge definition and load balancer configuration as follows:

### Cartridge Definition Configuration

#### C1: Cartridge 1/Service 1 Configured with Shared Scalable Load Balancing:

Here we set the default.load.balancer property to true in load balancer section in cartridge definition. As a result all the subscriptions made to this service will join to the default shared load balancer.

According to the current implementation there will be only one default load balancer instance/cluster for a given Stratos deployment.

````
{
    "cartridgeDefinitionBean": {
        ...

        "loadBalancer": {
            "property": {
                "name": "default.load.balancer",
                "value": "true"
            }
        }
    }
}
````

#### C2: Cartridge 2/Service 2 Configured with Dedicated Scalable Load Balancing:

Here we set the "service.aware.load.balancer" property to true in load balancer section. As a result there will be a dedicated load balancer instance/cluster spawned for this service and all the subscriptions made to this service will join to this dedicated load balancer.

````
{
    "cartridgeDefinitionBean": {
        ...

        "loadBalancer": {
            "property": {
                "name": "service.aware.load.balancer",
                "value": "true"
            }
        }
    }
}
````

#### C3: Cartridge 3/Service 3 Configured with Non Scalable Load Balancing:

Here we set the "no.load.balancer" property to true in load balancer section. As a result there will be no load balancers spawned for this service. However we could configure a static load balancer instance to serve the members spawned for the service subscriptions.

````
{
    "cartridgeDefinitionBean": {
        ...

        "loadBalancer": {
            "property": {
                "name": "no.load.balancer",
                "value": "true"
            }
        }
    }
}
````

Once the above cartridge configuration is done we need to configure the load balancer to identify the services which it needs to serve. This is accomplished by adding the load balancer cluster id to each member which it needs to join. Once a new member is spawned in a service cluster, Stratos Manager adds the relevant load balancer cluster id to the member instance. Subsequently when the member activated event is received by the load balancer it checks the member's load balancer cluster id against its value. If it matches then the relevant member will get joined to that load balancer/cluster.

#### Load Balancer Configuration for C1 & C2

Once a load balancer/cluster is spawned for above C1 and C2 options, the cartridge agent will update the topology-member-filter property in loadbalancer.conf value to its own load balancer cluster id at the start up. This process will make sure that only members with the same LB Cluster ID will join to this load balancer/cluster.

````
 # Topology member filter
 # Provide load balancer cluster ids in a comma separated list to filter incoming topology events if
 # topology_event_listener_enabled is set to true. This functionality could be used for allowing members
 # to join a given load balancer cluster.
 topology-member-filter: lb-cluster-id=lb-cluster-id1;
````

#### Load Balancer Configuration for C3

For non-scalable load balancers we could manually start a Stratos load balancer/cluster by commenting out the topology-member-filter property. As a result all the members in the Stratos deployment will get joined to this non-scalable load balancer/cluster.
