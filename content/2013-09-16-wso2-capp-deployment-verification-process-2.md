---
author: imesh
comments: true
date: 2013-09-16 06:02:09+00:00
layout: post
slug: wso2-capp-deployment-verification-process-2
title: WSO2 CApp Deployment Verification Process
wordpress_id: 84
categories:
- Blog
tags:
- capp
- wso2
---

WSO2 introduced a new Carbon Application (CApp) deployment verification process in Carbon 4.2.0 release. This might be useful for environments where applicaiton deployment process is automated via DevOps such as Jenkins.

In Carbon 4.2.0 release CApps are considered as atomic units which consists of a collection of artifacts that provides set of services for a specific requirement. Since the applications are considered atomic, if one of the artifacts of an application does not get deployed properly, that application will considered as not deployed. Which means either the all the artifacts of a CApp will get deployed or none.

Following steps could be tried out to test this functionality with WSO2 Application Server (AS) 5.2.0: 

1. Download AS 5.2.0 binary distribution and extract to a desired location.
2. Set the following property to false in repository/conf/carbon.xml
[code] <hideadminservicewsdls>false</hideadminservicewsdls> [/code]

This will expose the Administrative Services WSDLs and we may need to access the following services:
[code]
1. https://host-name:9443/services/AuthenticationAdmin?wsdl
2. https://host-name:9443/services/ApplicationAdmin?wsdl
[/code]

3. Invoke the login() method at https://host-name:9443/services/AuthenticationAdmin service. This method will return a Session ID on the HTTP response header and it may look like below:
JSESSIONID=45A850DF90CA6A009AD875CF5EF61460

4. Invoke listAllApplications() method at https://host-name:9443/services/ApplicationAdmin service while passing the Session ID on the HTTP request header as an Cookie. This request may look like below:

[code]
– Request –
POST https://host-name:9443/services/ApplicationAdmin.ApplicationAdminHttpsSoap11Endpoint/ HTTP/1.1
Accept-Encoding: gzip,deflate
Content-Type: text/xml;charset=UTF-8
SOAPAction: “urn:listAllApplications”
COOKIE: JSESSIONID=45A850DF90CA6A009AD875CF5EF61460
Content-Length: 238
Host: host-name:9443
Connection: Keep-Alive
User-Agent: Apache-HttpClient/4.1.1 (java 1.5)

– Response –
<soapenv:Envelope xmlns:soapenv=”http://schemas.xmlsoap.org/soap/envelope/”>
   <soapenv:Body>
      <ns:listAllApplicationsResponse 
          xmlns:ns=”http://mgt.application.carbon.wso2.org” 
          xmlns:ax27=”http://mgt.application.carbon.wso2.org/xsd”>
         <ns:return>HelloCar_1.0.0</ns:return>
      </ns:listAllApplicationsResponse>
   </soapenv:Body>
</soapenv:Envelope>
[/code]

On the response body you could see the available CApps listed.

5. Now invoke getAppData() method at https://host-name:9443/services/ApplicationAdmin service with the required CApp name and Session ID:

[code]
– Request –
POST https://host-name:9443/services/ApplicationAdmin.ApplicationAdminHttpsSoap11Endpoint/ HTTP/1.1
Accept-Encoding: gzip,deflate
Content-Type: text/xml;charset=UTF-8
SOAPAction: “urn:getAppData”
COOKIE: JSESSIONID=45A850DF90CA6A009AD875CF5EF61460
Content-Length: 329
Host: host-name:9443
Connection: Keep-Alive
User-Agent: Apache-HttpClient/4.1.1 (java 1.5)

– Response –
<soapenv:Envelope xmlns:soapenv=”http://schemas.xmlsoap.org/soap/envelope/”>
   <soapenv:Body>
      <ns:getAppDataResponse xmlns:ns=”http://mgt.application.carbon.wso2.org”>
         <ns:return xsi:type=”ax27:ApplicationMetadata” 
                    xmlns:ax27=”http://mgt.application.carbon.wso2.org/xsd” 
                    xmlns:xsi=”http://www.w3.org/2001/XMLSchema-instance”>
            <ax27:appName>HelloCar</ax27:appName>
            <ax27:appVersion>1.0.0</ax27:appVersion>
            <ax27:artifactsDeploymentStatus xsi:type=”ax27:ArtifactDeploymentStatus”>
               <ax27:artifactName>HelloCarService</ax27:artifactName>
               <ax27:deploymentStatus>Deployed</ax27:deploymentStatus>
            </ax27:artifactsDeploymentStatus>
         </ns:return>
      </ns:getAppDataResponse>
   </soapenv:Body>
</soapenv:Envelope>
[/code]

Here on the response body you could see the deployment status of the CApps and their artifacts.
