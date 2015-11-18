---
author: imesh
comments: true
date: 2007-05-14 04:08:00+00:00
layout: post
slug: bizcode-application-builder-1-2-beta-released
title: BizCode Application Builder 1.2 (Beta) Released
wordpress_id: 166
categories:
- Blog
---

[BizCode Application Builder 1.2 (Beta)](http://www.bizcodeframework.net/cs/files/folders/application_builder/entry39.aspx) was just released. Spent around two days on developing the new functionality to map Collection Association/Aggregations in BizCode Application Builder. Earlier versions did not support this functionality. The way Aggregations are mapped in Visual Studio Class Designer is using Collection Associations. For an example if we have an aggregation between class OrderDetails and class Product, an instance of OrderDetails can hold a collection of Product instances. Therefore it should be mapped into three tables in the Storage Layer, ORDER_DETAILS table, PRODUCT table and ORDER_DETAILS_PRODUCT_COLLECTION table to hold the collection data. In Class Designer we can define it as a List<Product> type association. Then the Application Builder will identify it as a Collection Association.




![](http://www.imeshonline.net/images/aggregation1.jpg)




Application Builder allows the user to select classes from the list of classes found in the Class Diagram to generate source code. Therefore it will check selected classes associations for referencing classes. If there are associations found in selected classes, all the referencing classes will be automatically selected. This feature was added to let the user to define Primary Keys for the referencing classes. Otherwise the Application Builder will not be able to map the associations properly.




Another new feature was added in the new version of Application Builder to format table names and column names using their naming convention. Application Builder will look for the Camel Notation in all the class names and attribute names and those will be split using the underscore "_" character. 




Ex:-






  * Class Name: OrderDetails -> Table Name: ORDER_DETAILS


  * Attribute Name: OrderDetailsId -> Column Name: order_details_id



**Demo Order Management Sample Class Diagram**




[](http://www.imeshonline.net/images/ClassDiagram.jpg)




![](http://www.imeshonline.net/images/1.2_class_diagram_small.jpg)




[[Large Size Image](http://www.imeshonline.net/images/1.2_class_diagram.jpg)]
