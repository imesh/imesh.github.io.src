---
author: imesh
comments: true
date: 2007-12-16 09:50:00+00:00
layout: post
slug: imap-to-your-rescue
title: IMAP To Your Rescue
wordpress_id: 148
categories:
- Blog
---

How do you manage your mail box? May be you are using a mail client at your home computer, a web base mail client at your office and also may be another mail client in your mobile. If so you may have experienced that the mails you have already read in your home computer are still in un-read state when you log in to your web base mail client. This is because the protocol that your home computer mail client is using does not update your mail status in the mail server. It just downloads all the mails in the mail server to your computer. This protocol is called Post Office Protocol or mostly known as [POP](http://en.wikipedia.org/wiki/Post_Office_Protocol).

Few weeks back I came across this new protocol called [IMAP](http://en.wikipedia.org/wiki/Imap) which updates the mail status in the mail server as you read your mail in your mail client. This is really cool! You can configure your mail client using your mail server's IMAP address, either in your home computer or in your mobile. As soon as you read a mail, the mail server is notified with to change the status of the mail. Then when you log into your web based mail client you will find that the mails you read in your other mail clients have been set as read.

Try [Thunderbird](http://www.mozilla.com/thunderbird) with [Gmail](http://www.gmail.com/). It Rocks!
