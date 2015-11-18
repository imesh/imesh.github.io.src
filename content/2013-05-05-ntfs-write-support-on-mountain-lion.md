---
author: imesh
comments: true
date: 2013-05-05 01:28:00+00:00
layout: post
slug: ntfs-write-support-on-mountain-lion
title: NTFS Write Support on Mountain Lion
wordpress_id: 88
categories:
- Blog
tags:
- mac
---

One of the first things that you would notice if you plug-in a portable hard drive formatted in NTFS format to a Mac with Mountain Lion is that the drive is read only. Sometimes you may have not even notice it if you did not try to execute any write operations.




Out of the box Mountain Lion does not support write access to Windows based file system NTFS. However FAT32 is read/write supported. Mac uses it's own set of file systems; [HFS, HFS Plus](http://en.wikipedia.org/wiki/Hierarchical_File_System) (Mac OS Standard, Mac OS Extended). Nevertheless there is a way to get NTFS write access on Mac OS, Mountain Lion.




**Theory Behind:**




Mac OS has been built on top of the Linux kernel. The Linux kernel supports a feature called [Filesystem in Userspace](http://en.wikipedia.org/wiki/Filesystem_in_Userspace) (FUSE) which allows non-priviledged users to create their own file systems without editing the kernel code. This is simply an awesome design feature. From a software engineer's perspective this is a vital feature for any software system, keeping space for extending a system without modifying it's core code.




FUSE has been implemented by [OSXFUSE](http://osxfuse.github.io) for Mac OS X. This is kind of an API for implementing support for many different file systems. By make using OXSFUSE, NTFS-3G has implemented read/write support for NTFS. There we go, we could make use of these two system applications to support NTFS write access on Mountain Lion. One of the important point to note here is that this is not a dirty fix rather it is a well defined implementation for extending Mac OS's file handling capabilities.




**How to Install the Fix:**




1. Download and install MacFUSE: [http://goo.gl/VdnPW](http://goo.gl/VdnPW). [MacFUSE](http://code.google.com/p/macfuse/) is the base version of OSXFUSE. This might prompt you to restart the Mac once the installation is complete. I guess it would be wise to let it proceed.




2. Download and install NTFS-3G: [http://goo.gl/HH0Pm](http://goo.gl/HH0Pm). This is the implementation of FUSE API for NTFS.




3. Download and install the NTFS-3G timeout errors fix: [http://goo.gl/nH5Or](http://goo.gl/nH5Or). There seems to be some known errors in NTFS-3G so we might need this fix.




4. Download and install OSXFUSE: [http://sourceforge.net/projects/osxfuse](http://sourceforge.net/projects/osxfuse). Make sure to check the third check box on the installation configuration page which is by default un-checked.




**References:**




http://kennelbound.com/write-support-for-ntfs-with-mac-osx-mountain-lion/



