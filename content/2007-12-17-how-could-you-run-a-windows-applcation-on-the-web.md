---
author: imesh
comments: true
date: 2007-12-17 12:18:00+00:00
layout: post
slug: how-could-you-run-a-windows-applcation-on-the-web
title: How could you run a Windows Applcation on the Web?
wordpress_id: 147
categories:
- Blog
---

I think it was not possible since Extensible Application Markup Language (XAML) was introduced. If you design a Graphical User Interface (GUI) for a specific Windows Application you will have to design a separate one for the Web and may be another one for the mobile. This might be a waste of time in implementing the same GUI design for different purposes (even there could be any minor changes). This is the place where XAML comes into play.




XAML is an open standard for defining GUI elements which can be used by different programming languages on different platforms. Currently it can be used with the .NET Framework 3 which is mostly known as [Windows Presentation Foundation](http://wpf.netfx3.com/) and with the Java framework [eFace](http://www.soyatec.com/eface/).




<blockquote>

> 
>   
A button which was written like this;
>     
>     <span style="COLOR: maroon"></span><span style="COLOR: blue">Button button = new Button(); </span>
>     
>     <span style="COLOR: blue">button.Text = "Click Me";</span>
> 
> 

> 
> Can now write like this;
>     
>     <span style="COLOR: blue"><</span><span style="COLOR: maroon">Button</span><span style="COLOR: blue">></span><br></br>      <span style="COLOR: blue"><</span><span style="COLOR: maroon">Button.Content</span><span style="COLOR: blue">></span><br></br>        Click Me<br></br>      <span style="COLOR: blue"></</span><span style="COLOR: maroon">Button.Content</span><span style="COLOR: blue">></span><br></br><span style="COLOR: blue"></</span><span style="COLOR: maroon">Button</span><span style="COLOR: blue">></span>
> 
> </blockquote>




Just see the difference, the first one totally depends on the language that you implement but the second one is not. You could have that button either on a Windows Application or on Web Application even with different Programming Languages. This will reduce the time and cost that will required to implement an application for different purposes.  

