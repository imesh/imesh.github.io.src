---
author: imesh
comments: true
date: 2014-06-15 18:30:48+00:00
layout: post
slug: implementing-split-aggregate-pattern-in-esb
title: Implementing Split Aggregate Pattern in ESB
wordpress_id: 69
categories:
- Blog
tags:
- esb
---

Split Aggregate is an [Enterprise Integration Pattern](http://www.eaipatterns.com/) (EIP) which could be implemented in an ESB in scenarios where the same backend service needs to be invoked with different payloads. This will avoid the need of making multiple service calls to backend services and eventually reduce the service invocation round trip time.

In this article I have designed a sample mediation flow in WSO2 ESB, by using the Iterate and Aggregate mediators to demonstrate the usage of Split Aggregate patten.


### In Mediation Flow


  




[![ESB-Iterate-Aggregate-In-Flow](http://imesh.gunaratne.org/wp-content/uploads/2014/06/ESB-Iterate-Aggregate-In-Flow.png)](http://imesh.gunaratne.org/wp-content/uploads/2014/06/ESB-Iterate-Aggregate-In-Flow.png)


- According to the above diagram when a message is received by an API or Proxy Service in the ESB it will be delegated to the In Sequence.
- Here we could validate the incoming request and implement error handling logic. What I have done is I have introduced a Response Sequence to generate an error response if the incoming request is not valid. At the same time I re-use the Response Sequence as the last step in the message out flow.
- Here my approach is to generate a common response message in Response Sequence which will have attributes to detect an error.
- The best part of this approach is that the API/Proxy Service will return a response in both successful and error situations.
- As the next step the iterate mediator will split the message using the XPath expression given and send each sub message to the endpoint.
- At this point iterate mediator set the total sub message count in the message context:

[code lang="java"]
org.apache.synapse.mediators.eip.splitter.IterateMediator (Synapse 2.1.2-wso2v5):
   private MessageContext getIteratedMessage() {
      ...
      newCtx.setProperty(
      EIPConstants.MESSAGE_SEQUENCE + "." + id,
      msgNumber + EIPConstants.MESSAGE_SEQUENCE_DELEMITER + msgCount);
      ...
   }
[/code]

- Then I have configured the endpoint timeout settings to trigger the fault sequence if a timeout occurs.
- Here we need to consider the timeout value of the actual backend service which the endpoint is pointing to.



### Out Mediation Flow


  




[![ESB-Iterate-Aggregate-Out-Flow](http://imesh.gunaratne.org/wp-content/uploads/2014/06/ESB-Iterate-Aggregate-Out-Flow.png)](http://imesh.gunaratne.org/wp-content/uploads/2014/06/ESB-Iterate-Aggregate-Out-Flow.png)


- All successful responses will trigger the out sequence and all fault messages will trigger the fault sequence (according to the API/Proxy Service configuration).
- In addition any messages that may get timeout by the endpoint will trigger the fault sequence.
- Both out sequence and fault sequence will generate a sub result block in the same format as show in below sample response. Since both blocks are in the same format the aggregate mediator will be able to aggregate them without any problem.
- Important: In this approach we will generate a sub result block for all the sub messages sent to the endpoint, even if a timeout occurs in one sub message.
- Then the Aggregate Mediator will wait until responses to all the sub messages are received:

[code lang="java"]
org.apache.synapse.mediators.eip.aggregator.Aggregate (Synapse 2.1.2-wso2v5):
   public synchronised boolean isComplete() {
   ...
      String[] msgSequence = prop.toString().split(
      EIPConstants.MESSAGE_SEQUENCE_DELEMITER);
      int total = Integer.parseInt(msgSequence[1]);
      ...
      if (messages.size() &gt;= total) {
         synLog.traceOrDebug("Aggregation complete");
         return true;
      }
      ...
   }
[/code]

- To do this we should not define a timeout in complete condition in aggregate mediator, rather the following could be defined:

[code lang="xml"]
<aggregate> 
    <completeCondition> 
        <messageCount/> 
    </completeCondition> 
    <onComplete xmlns:m0="http://services.samples" expression="//m0:getQuoteResponse"> 
        <send/> 
    </onComplete> 
</aggregate> 
</code>
[/code]

- Once the aggregated response message is reached at the Response Sequence it will be sent back to the client.
