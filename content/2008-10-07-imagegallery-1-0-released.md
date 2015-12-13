---
author: imesh
comments: true
date: 2008-10-07 17:36:00+00:00
layout: post
slug: imagegallery-1-0-released
title: ImageGallery 1.0 Released
wordpress_id: 125
categories:
- Blog
---

[![](http://imesh.io/images/ImageGalleryReleased/Mosaic_New_379X408.jpg)](http://imesh.io/images/ImageGalleryReleased/Mosaic_New.jpg)

Today I'm really glad to announce the first version of [ImageGallery](http://code.google.com/p/imagegallery), version 1.0 licensed under [GNU Lesser GPL](http://www.gnu.org/copyleft/lesser.html). During past few days I spent my spare time playing around with this to make it available for the public. The initial version which was deployed in my [photography](http://imesh.io/photography) page was cleaned and converted into an User Control. Now an Image Gallery can be added to an ASP.NET Page with a single line.

````
<uc:Gallery runat="server"></uc:Gallery>
````

A new theme was created as the default theme of ImageGallery and it can be seen here at [Demo Gallery](http://imesh.io/projects/imagegallery/). Still ImageGallery only supports to access images from Flickr Accounts. The next step is to develop another two extensions to provide access to Web Folders and Picasa Accounts.

Thanks to [FlickrNET](http://www.codeplex.com/FlickrNet) API and [Lightbox Slideshow](http://www.justinbarkhuff.com/lab/lightbox_slideshow/) Javascript Library. Special thanks to [Justin Barkhuff](http://www.justinbarkhuff.com/) for allowing me to distribute Lightbox Slideshow with ImageGallery.

[Download ImageGallery 1.0](http://code.google.com/p/imagegallery/downloads/list)






