---
author: imesh
comments: true
date: 2015-10-13 14:44:13+00:00
layout: post
slug: an-introduction-to-wso2-configurator
title: An Introduction to WSO2 Configurator
wordpress_id: 335
categories:
- Blog
---

Product configurations can be automated with orchestration management systems such as Puppet, Chef, Salt, Ansible, etc. Most of these orchestration systems provide their own templating engine for templating configuration files. The problem with this model is that for each orchestration system a separate set of templates need to be created for the same product. Switching between different orchestration systems & maintaining different sets of templates files are very costly.

WSO2 Configurator was introduced to solve this problem by implementing a generic templating solution which can work with any orchestration system: ![configurator-architecture](http://imesh.gunaratne.org/wp-content/uploads/2015/10/configurator-architecture.png)

WSO2 Configurator is a python module written using [Jinja2](http://jinja.pocoo.org/docs/dev/) template engine which can configure a product using a set of key/value pairs. As shown in the above diagram configuration parameters can be either provided by using a set of environment variables or using the module.ini file inside the template module. The template module includes the template files, any other files that needs to be copied to the product distribution such as patches and the module.ini file.

WSO2 Private PaaS Cartridges releases template modules for all the WSO2 products. Currently template modules can be found for API-M, AS, BRS, DAS, ESB, G-Reg, IS & MB can be found here [3](https://github.com/wso2/private-paas-cartridges).

### How to use Configurator:

#### 1. Build WSO2 Configurator
    
    cd /tmp/
    git clone https://github.com/wso2/private-paas-cartridges.git
    cd private-paas-cartridges/common/configurator
    git checkout tags/v4.1.0
    mvn clean install
    cp target/ppaas-configurator-4.1.0.zip /tmp/work
    cd /tmp/work/
    unzip ppaas-configurator-4.1.0.zip

#### 2. Build WSO2 AS 5.2.1 Template Module
    
    cd /tmp/private-paas-cartridges/wso2as/5.2.1/template-module 
    mvn clean install
    cd target/
    unzip wso2as-5.2.1-template-module-4.1.0.zip
    cp wso2as-5.2.1-template-module-4.1.0 /tmp/work/ppaas-configurator-4.1.0/template-modules/
    
#### 3. Extract WSO2 AS 5.2.1 Distribution
    
    cd /tmp/work/
    unzip wso2as-5.2.1.zip

#### 4. Update module.ini File
    
    Update module.ini file and set CARBON_HOME to /tmp/work/wso2as-5.2.1
    
#### 5. Run Configurator
    
    export CONFIG_PARAM_PORT_OFFSET=2
    cd /tmp/work/ppaas-configurator-4.1.0
    python configurator.py


Now have a look at the carbon.xml file port offset value. It should be set to 2.