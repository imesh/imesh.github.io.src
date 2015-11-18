---
author: imesh
comments: true
date: 2014-11-27 12:57:55+00:00
layout: post
slug: how-to-activatedeactivate-message-processors-in-wso2-esb-with-mbeans
title: How to Activate/Deactivate Message Processors in WSO2 ESB with MBeans
wordpress_id: 301
categories:
- Blog
---

## What is a Message Processor?




WSO2 ESB provides message processors for delivering messages that have been temporarily stored in a message store. This approach is useful for serving traffic to back-end services that can only accept messages at a given rate, whereas incoming traffic to the ESB arrives at different rates [1]. Please refer [2] for sample use cases of message processors.





## How to Implement a MBeans Client?




The below sample code demonstrates how to talk to the JMX endpoint of the ESB and actiavate and deactivate a message processor. Here update the JMX URL and the bean definition accordingly.



````
import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;
import java.util.HashMap;
import java.util.Map;

public class Main {
    public static void main(String[] args) {
        try {
            Map<String, Object> env = new HashMap<String, Object>();
            String[] credentials = new String[]{"admin", "admin"};
            env.put("jmx.remote.credentials", credentials);

            String url = "service:jmx:rmi://localhost:11111/jndi/rmi://localhost:9999/jmxrmi";
            JMXServiceURL target = new JMXServiceURL(url);
            JMXConnector connector = JMXConnectorFactory.connect(target, env);
            MBeanServerConnection remote = connector.getMBeanServerConnection();

            String beanDef = "org.apache.synapse:Type=Message Forwarding Processor view,Name=MessageForwardingProcessor";
            ObjectName bean = new ObjectName(beanDef);

            remote.invoke(bean, "activate", null, null);
            connector.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
````

[1] https://docs.wso2.com/display/ESB481/Message+Processors
[2] https://docs.wso2.com/display/ESB481/Store+and+Forward+Using+JMS+Message+Stores
