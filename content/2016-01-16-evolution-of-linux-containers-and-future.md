---
author: imesh
comments: true
date: 2016-01-16 16:00:00+05:30
layout: post
slug: evolution-of-linux-containers-and-future
title: Evolution of Linux Containers and Future
categories:
- blog
tags:
- containers, docker, linux
---

# Evolution of Linux Containers & Future

Linux containers is an [operating system level virtualization] [1] technology for providing multiple isolated Linux environments on a single Linux host. Unlike virtual machines (VMs) containers do not run a dedicated guest operating system rather they share the host operating system kernel and make use of  guest operating system system libraries for providing the required OS capabilities. Since there is no dedicated operating system, containers start much faster than VMs.

![Virtual Machines Vs Containers](/images/contvsvm.png)
> Image credit: Docker Inc.

Containers make use of the Linux kernel features such as Namespaces, Apparmor, SELinux profiles, chroot & CGroups for providing an isolated environment similar to VMs. Linux security modules guarantee that access to the host machine and the kernel from the containers is properly managed to avoid any intrusion activities. In addition containers can run different Linux distributions from its host operating system  if both operating systems to run on the same CPU architecture.

In general containers provide means of creating container images based on various Linux distributions, an API for managing the lifecycle of the containers, client tools for interacting with the API, features to take snapshots, migrating container instances from one container host to another, etc.

## Container History
Below is a short summary of container history extracted from Wikipedia and other sources:

### 1979 - chroot
Container concept was started way back in 1979 with UNIX [chroot] [2]. It's an UNIX operating-system system call for changing the root directory of a process and its children to a new location in the filesystem which is only visible to a given process. The idea of this feature is to provide an isolated disk space for each process. Later in 1982 this was added to BSD.

### 2000 - FreeBSD Jails
[FreeBSD Jails] [3] is one of the early container technologies introduced by Derrick T. Woolworth at R&D Associates for FreeBSD in year 2000. It is an operating-system system call similar to chroot but included additional process sandboxing features for isolating the filesystem, users, networking, etc. As a result it could provide means of assigning an IP address for each jail, custom software installations and configurations, etc.

### 2001 - Linux VServer
[Linux VServer] [4] is a another jail mechanism that can be used to securely partition resources on a computer system (file system, CPU time, network addresses and memory). Each partition is called a security context and the virtualized system within it is called a virtual private server.

### 2004 - Solaris Containers
[Solaris Containers] [6] was introduced for x86 and SPARC systems, first released publicly in February 2004 in build 51 beta of Solaris 10, and subsequently in the first full release of Solaris 10, 2005. A Solaris Container is a combination of system resource controls and the boundary separation provided by zones. Zones act as completely isolated virtual servers within a single operating system instance.

### 2005 - OpenVZ
[OpenVZ] [7] is similar to Solaris Containers and make use of a patched Linux kernel for providing virtualization, isolation, resource management, and checkpointing. Each OpenVZ container would have an isolated file system, users & user groups, a process tree, network, devices and IPC objects.

### 2006 - Process Containers
[Process Containers] [8] was implemented at Google in year 2006 for limiting, accounting and isolating resource usage (CPU, memory, disk I/O, network, etc) of a collection of processes. Later on it was renamed to Control Groups to avoid the confusion multiple meanings of the term "container" in the Linux kernel context and merged to the Linux kernel 2.6.24. This shows how early Google was involved in container technology and how they have contributed back.

### 2007 - Control Groups
As explained above Control Groups AKA cgroups was implemented by Google and added to the Linux Kernel in year 2007.

### 2008 - LXC
[LXC] [9] stands for LinuX Containers and it is the first, most complete implementation of Linux container manager. It was implemented using cgroups and Linux namespaces. LXC was delivered in liblxc library and provided language bindings for the API in python3, python2, lua, Go, ruby, and Haskell. Contrast to other container technologies LXC works on vanila Linux kernel without requiring any patches. Today [LXC project] [10] is sponsored by Canonical Ltd and hosted here.

### 2011 - Warden
[Warden] [12] was implemented by CloudFoundry in year 2011 by using LXC at the initial stage and later on replaced with their own implementation. Unlike LXC, Warden is not tightly coupled to Linux rather it can work on any operating system that can provide ways of isolating the environments. It runs as a daemon and provides an API for managing the containers. Refer [Warden documentation] [12] and [this blog post] [13] for more detailed information on Warden.

### 2013 - LMCTFY
[lmctfy] [14] stands for "Let Me Contain That For You". It is the open source version of Google’s container stack, which provides Linux application containers. Google started this project with the intension of providing guaranteed performance, high resource utilization, shared resources, over-commitment and near zero overhead with containers (Ref: [lmctfy presentation] [15]). The cAdvisor tool used by Kubernetes today was started as a result of lmctfy project. The initial release of lmctfy was made in Oct 2013 and in year 2015 Google has decided to contribute core lmctfy concepts and abstractions to libcontainer. As a result now no active development is done in LMCTFY.

The libcontainer project was initially started by [Docker] [17] and now it has been moved to [Open Container Foundation] [18].

### 2013 - Docker
[Docker] [19] is the most popular and widely used container management system as of January 2016. It was developed as an internal project at a platform as a service company called dotCloud and later renamed to Docker. Similar to Warden Docker also used LXC at the initial stages and later replaced LXC with it's own library called libcontainer. Unlike any other container platform Docker introduced an entire ecosystem for managing containers. This includes a highly efficient, layered container image model, a global and local container registries, a clean REST API, a CLI, etc. At a later stage Docker also took an initiative to implement a container cluster management solution called Docker Swarm.  

### 2014 - Rocket
[Rocket] [20] is a much similar initiative to Docker started by CoreOS for fixing some of the drawbacks they found in Docker. CoreOS has mentioned that their aim is to provide more rigorous security and production requirements than Docker. More importantly it is implemented on App Container specification to be a more open standard. In addition to Rocket, CoreOS also develops several other container related products used by Docker & Kubernetes; [CoreOS Operating System] [21], [etcd] [22], [flannel] [23].


### 2016 - Windows Containers
Microsoft also took an initiative to add container support to Microsoft Windows Server operating system in year 2015 for Windows based applications and it's called [Windows Containers] [24]. This is to be released with Microsoft Windows Server 2016. With this implementation Docker would be able to run Docker containers on Windows natively without having to run a virtual machine to run Docker (earlier Docker ran on Windows using a Linux VM).

## The Future of Containers
As of today (Jan 2016) there is a huge trend in the industry to move towards containers from viratual machines for deploying software applications. According to [Brian Grant] [25] Google has used container technology for many years with [Borg and Omega] [26] platforms for running Google products at scale. Google may have gained a huge gain in performance, resource utilization and overall efficiency using containers during past years. Very recently Microsoft who did not had means of running containers on Windows platform took immediate action to implement support for containers and Docker on Windows Server.

Docker, Rocket and other container platforms have a common problem of being vulnerable to single point of failure. Even though a collection of containers can be run on a single host, if the host fail, all the containers run on that host will also fail. The only option to solve this problem is to use a container host cluster. Google took a step to implement an open source container cluster management system called Kubernetes with the experience they got from Borg. Docker also started a solution called Docker Swarm. Today these solutions are at the very early stages and it may take several months and years to complete their full feature set, become stable and widely use in the industry in production environments.

[1]: https://en.wikipedia.org/wiki/Operating-system-level_virtualization#IMPLEMENTATIONS
[2]: https://en.wikipedia.org/wiki/Chroot
[3]: https://en.wikipedia.org/wiki/FreeBSD_jail
[4]: https://en.wikipedia.org/wiki/Linux-VServer
[5]: http://linux-vserver.org/Overview
[6]: https://en.wikipedia.org/wiki/Solaris_Containers
[7]: https://en.wikipedia.org/wiki/OpenVZ
[8]: https://en.wikipedia.org/wiki/Cgroups
[9]: https://en.wikipedia.org/wiki/LXC
[10]: https://linuxcontainers.org/lxc/introduction/
[11]: http://pivotal.io/platform/infographic/moments-in-container-history
[12]: https://docs.cloudfoundry.org/concepts/architecture/warden.html
[13]: http://blog.altoros.com/cloud-foundry-containers-warden-docker-garden.html
[14]: https://github.com/google/lmctfy
[15]: http://www.linuxplumbersconf.org/2013/ocw//system/presentations/1239/original/lmctfy%20(1).pdf
[16]: https://github.com/google/cadvisor/
[17]: https://github.com/docker/libcontainer
[18]: https://github.com/opencontainers/runc/tree/master/libcontainer
[19]: https://en.wikipedia.org/wiki/Docker_(software)
[20]: https://coreos.com/blog/rocket/
[21]: https://en.wikipedia.org/wiki/CoreOS
[22]: https://coreos.com/etcd/
[23]: https://github.com/coreos/flannel
[24]: https://msdn.microsoft.com/en-us/virtualization/windowscontainers/about/about_overview
[25]: https://github.com/bgrant0607
[26]: http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43438.pdf
