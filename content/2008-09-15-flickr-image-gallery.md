---
author: imesh
comments: true
date: 2008-09-15 07:50:00+00:00
layout: post
slug: flickr-image-gallery
title: Flickr Image Gallery
wordpress_id: 128
categories:
- Blog
---

I was thinking of writting an Image Gallery from some time back to publish my flickr images in my web log. Very recently I found [Flickr.NET](http://www.codeplex.com/FlickrNet) API which is a free and open source .NET library which provides access to the Flickr API. So have a look at my first attempt of using Flickr.NET in my [photography](http://rootfolder.info/photography) page.

It was a really nice experience to develop your own image gallery. The only challenge I had was to come up with a algorithm to implment the navigator. It was bit complex than I thought. I had to design the way that it displays the page numbers according to the selected page and the total number of pages. This is how it was done. 

The navigator was designed to display the first five page numbers and the last two page numbers at the start. 

![](http://rootfolder.info/images/ImageGallery/nav1.png)   


If you navigate to the 5th page it will expand it's content and display a set of five page numbers in the middle by keeping the first and last two page numbers on both sides. It will always display the previous page number on the left hand side to the selected page number. This will allow the user to navigate back to the previous page very easily. Moreover it will display two arrows, basically the greater than and less than characters on the most left and right corners to navigate to each side.

![](http://rootfolder.info/images/ImageGallery/nav2.png)   


If you navigate to one of the pages in the set of last 5 pages or may be the last 6 pages it will display the first two page numbers and the last few page numbers as below.

![](http://rootfolder.info/images/ImageGallery/nav3.png)   


I'm planning to release this application as a free open source product in the near future. It will be improved to read images from web folders or may be from other image publishing platforms like [Picasa](http://picasa.google.com). At the moment this Image Gallery is implemented as a ASP.NET page so I need to change this to a ASP.NET Control. Then it will be able to placed inside a ASP.NET Page with few configuration parameters in the Web.config file.

If anyone is interested in joining this project please let me know.

[code.google.com/p/imagegallery](http://code.google.com/p/imagegallery)
