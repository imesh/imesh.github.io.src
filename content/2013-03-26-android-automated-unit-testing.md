---
author: imesh
comments: true
date: 2013-03-26 06:18:00+00:00
layout: post
slug: android-automated-unit-testing
title: Android Automated Unit Testing
wordpress_id: 90
categories:
- Blog
tags:
- android
---

I did some experiments with Android Unit Testing features to implement a custom automated unit testing framework recently. Android itself has a unit testing framework built in. This has been written using JUnit and has implemented new functionality to test Android specific features such as Activities, Services and Content Providers. The basic concept behind Android Unit Test framework is to implement an Android test application similar to a standard Android application and define required meta data to identify the application to be tested and test steps. Once the test application is run it automatically loads the target application and executes the given set of test commands as it is done by a human.




The UI interaction of the test either can be implemented in Java using the Instrumentation Test Runner or in Python using [Monkey Runner](http://developer.android.com/tools/help/monkeyrunner_concepts.html). The below diagram illustrates the architecture of the Android Unit Testing framework.




![](http://developer.android.com/images/testing/test_framework.png)




Reference: [Android Testing Fundamentals](http://developer.android.com/tools/testing/testing_android.html)




Except for standard test implementation several other open source projects have emerged to simplify the process. One of the leading implementation is [Robotium](https://github.com/jayway/robotium). Robotium is a very light weight framework which has introduced helper classes to facilitate most of the user interaction commands which may cost more if we were to implement on standard Android Test Framework. For an example to type on a text field with standard Android Unit Test implementation we may need to write something like this:



    
    // Find field references
    LoginActivity mActivity = getActivity();
    final EditText mEmailView = (EditText) mActivity.findViewById(com.example.helloworld.R.id.email);
    final EditText mPasswordView = (EditText) mActivity.findViewById(com.example.helloworld.R.id.password);
    final Button mSignIn = (Button) mActivity.findViewById(com.example.helloworld.R.id.sign_in_button);
    
    // Set field values and press sign in button
    mActivity.runOnUiThread(new Runnable() {
    	public void run() {
    		mEmailView.setText("ABC");
    		mPasswordView.setText("hello");
    		mSignIn.callOnClick();				
    	}
    });
    




However with Robotium we could write the same test script with:



    
    // Find field references
    Activity mActivity = getActivity();
    		EditText mEmailView = (EditText) mActivity.findViewById(R.id.email);
    		EditText mPasswordView = (EditText) mActivity.findViewById(R.id.password);		
    		
    		solo.enterText(mEmailView, "f");
    		solo.enterText(mPasswordView, "hello");
    		solo.clickOnButton("Sign in or register");
    




Robotium also supports to take screen shots at different points of the test flow so that we could have a look at the screens for investigating problems.




Another important aspect of unit testing is that executing them in a build using a continuous integration system like Jenkins. Jenkins has a plugin for integrating Android Unit Tests called [Android Emulator Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Android+Emulator+Plugin). This could be used to test Android applications on different device configurations while generating test reports at the end of test sessions.




Android unit testing is quite interesting. So if you find any questions or and comments regarding this please let me know. I will try my best to answer them via this post. Thanks.
