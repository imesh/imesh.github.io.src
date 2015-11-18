---
author: imesh
comments: true
date: 2014-05-15 13:36:00+00:00
layout: post
slug: exposing-wso2-identity-server-admin-services-as-rest-apis
title: Exposing WSO2 Identity Server Admin Services as REST APIs
wordpress_id: 80
categories:
- Blog
tags:
- identity
- security
---

WSO2 Identity server 4.5.0 does not provide REST APIs for accessing its administrative services out of the box. However we could use WSO2 ESB to convert SOAP based administrative services to REST. Please follow the below steps to do this:

1. Download WSO2 ESB 4.8.1 and IS 4.5.0.

2. Extract ESB distribution and set the offset to 1 in carbon.xml file.
[code] <offset>1</offset> [/code]

3. Extract IS distribution and set the HideAdminServiceWSDLs property to false in carbon.xml file. This will expose administrative services WSDLs.

[code] <HideAdminServiceWSDLs>false</HideAdminServiceWSDLs> [/code]

4. Now start IS with OSGi console enabled:

[code] sh <IS-HOME>/bin/wso2server.sh -DosgiConsole [/code]

5. Enter listAdminServices command in OSGi console and retrieve the list of administrative services available and their WSDLs.

6. In this article I will use listAllUsers() method available in UserAdmin service to demonstrate how to convert SOAP based services to REST. UserAdmin service WSDL could be found at:

[code] https://localhost:9443/services/UserAdmin?wsdl [/code]

7. Now create an in sequence in ESB with the following content:

[code lang="xml" escaped="true"]
<sequence xmlns="http://ws.apache.org/ns/synapse" name="ListUsersInSeq">
    <payloadFactory media-type="xml">
        <format>
            <xsd:listAllUsers xmlns:xsd="http://org.apache.axis2/xsd">
                <xsd:filter>$1</xsd:filter>
                <xsd:limit>$2</xsd:limit>
            </xsd:listAllUsers>
        </format>
        <args>
            <arg xmlns:m0="http://services.samples" evaluator="xml" expression="$url:filter"/>
            <arg xmlns:m0="http://services.samples" evaluator="xml" expression="$url:limit"/>
        </args>
    </payloadFactory>
    <property xmlns:ns="http://org.apache.synapse/xsd" name="Authorization" 
              expression="fn:concat('Basic ', base64Encode('admin:admin'))" scope="transport" type="STRING"/>
    <property name="SOAPAction" value="urn:listAllUsers" scope="transport" type="STRING"/>
    <property name="HTTP_METHOD" value="POST" scope="axis2" type="STRING"/>
    <log level="full"/>
    <send>
        <endpoint>
            <address uri="https://localhost:9443/services/UserAdmin" format="soap12"/>
        </endpoint>
    </send>
</sequence>
[/code]

8. Create an out sequence with the following content:

[code lang="xml" escaped="true"]
<sequence xmlns="http://ws.apache.org/ns/synapse" name="ListUsersOutSeq">
    <log level="full"/>
    <property name="messageType" value="application/json" scope="axis2" type="STRING"/>
    <send/>
</sequence>
[/code]

9. Create an API with the following content:

[code lang="xml" escaped="true"]
<api xmlns="http://ws.apache.org/ns/synapse" name="listUsers" context="/listUsers">
    <resource methods="GET" inSequence="ListUsersInSeq" outSequence="ListUsersOutSeq">
        <faultSequence/>
    </resource>
</api>
[/code]

10. Send a HTTP GET request to the listUsers API:

Request:
[code]
curl -v http://localhost:8281/listUsers?filter=*&limit=10
[/code]

Response:
[code]
{"listAllUsersResponse":
   {"return":[ {"@type":"ax2629:FlaggedName","dn":{"@nil":"true"},"domainName":{"@nil":"true"},"editable":true,
"itemDisplayName":"admin","itemName":"admin","readOnly":false,"roleType":{"@nil":"true"},"selected":false,"shared":false},
                       {"@type":"ax2629:FlaggedName","dn":{"@nil":"true"},"domainName":{"@nil":"true"},"editable":false,
"itemDisplayName":null,"itemName":false,"readOnly":false,"roleType":{"@nil":"true"},"selected":false,"shared":false}
]}}
[/code]
