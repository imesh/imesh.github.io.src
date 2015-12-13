---
author: imesh
comments: true
date: 2014-10-24 05:52:55+00:00
layout: post
slug: providing-high-availability-for-stratos-with-pacemaker-heartbeat
title: Providing High Availability for Stratos with Pacemaker & Heartbeat
wordpress_id: 292
categories:
- Blog
tags:
- ha
---

This article describes how High Availability (HA) can be configured with [Pacemaker](http://clusterlabs.org/wiki/Pacemaker) & [Heartbeat](http://linux-ha.org/wiki/Heartbeat) for Apache Stratos. In general this concept can be applied for any server application which needs HA and does not require any data replication. If data replication is needed you may need to consider using [DRBD](http://www.drbd.org/home/what-is-drbd/) with Pacemaker. First of all we will see what Pacemaker and Heartbeat are and go through a series of steps on configuring those.


### What is Pacemaker?

Pacemaker is a Cluster Resource Manager (CRM) which can detect and recover from failures of nodes and resources. It basically can start, stop, check the status of a resource and take decisions for recovering them from failures.

What is a resource? A resource either can be a server application, an IP address or any other software/hardware resource that you can think of. These resources are managed through [Resource Agents](http://www.linux-ha.org/wiki/Resource_agents) which is an abstraction layer that Pacemaker make use of to communicate with different types of resources. Out of the box Pacemaker provides Resource Agents for OCF and LSB services. In this example we will be using LSB Resource Agent to manage Apache Stratos as an init.d service.


### What is Heartbeat?

Heartbeat is a daemon that provides messaging infrastructure for Pacemaker. It manages the communication between nodes and allows to know the presence of resources in the cluster.


### Prerequisites

  * Oracle VirtualBox or any other virtualization technology	
  * Ubuntu 12.04 server (64-bit) virtual machine image
  * Pacemaker 1.1.6 or above
  * Heartbeat 3.0.5 or above


### Steps for Configuring Pacemaker & Heartbeat for Apache Stratos:

  * Start two instances of Ubuntu 12.04 server virtual machines.
  
  * Switch to root user:
    ````
    sudo su
    ````

  * Install Pacemaker and Heartbeat

    ````
    apt-get install pacemaker heartbeat
    ````
    
  * Create Heartbeat configuration file at the following location: /etc/ha.d/ha.cf

````
    # enable pacemaker, without stonith
    crm yes
    # define log file
    logfile /var/log/ha-log
    # warning of soon be dead
    warntime 10
    # declare a host (the other node) dead after:
    deadtime 20
    # dead time on boot (could take some time until net is up)
    initdead 120
    # time between heartbeats
    keepalive 2
    # the nodes
    node node1 # set node1 hostname
    node node2 # set node2 hostname
    # heartbeats, over dedicated replication interface
    ucast eth1 10.186.175.16 # set node1 network-interface and ip address
    ucast eth1 54.211.110.217 # set node2 network-interface and ip address
````


  * Create authentication key file and set permissions in one of the hosts:

    ````
    ( echo -ne "auth 1\n1 sha1 "; \
    dd if=/dev/urandom bs=512 count=1 | openssl md5 ) \
    > /etc/ha.d/authkeys
    chmod 0600 /etc/ha.d/authkeys
    ````
	
  * Copy the above authkeys file to each host (/etc/ha.d/authkeys).	

  * Restart heartbeat service:
    ````
    service heartbeat restart
    ````

  * Now check the status of the Pacemaker cluster using CRM, here all nodes in the cluster should be in online state. If not check the heartbeat configuration again.
  
    ````
    crm status
    ============
    Last updated: Wed Oct 15 11:25:05 2014
    Last change: Wed Oct 15 11:21:51 2014 via crmd on ip-10-186-175-16
    Stack: Heartbeat
    Current DC: ip-10-186-175-16 (d16ccc5c-2641-42b6-b46a-57a0b32fddc9) - partition with quorum
    Version: 1.1.6-9971ebba4494012a93c03b40a2c58ec0eb60f50c
    2 Nodes configured, unknown expected votes
    0 Resources configured.
    ============
    Online: [ ip-10-186-175-16 ip-10-153-165-178 ]
    ````

  * Disable STONITH:
    ````
    crm configure property stonith-enabled=false
    ````	

  * Create a Failover IP resource to manage the virtual IP address:

    ````
    crm configure primitive FAILOVER-IP ocf:heartbeat:IPaddr params ip=192.168.10.20 cidr_netmask="255.255.255.0" op monitor interval=10s
    ````

  * SCP java and Apache Stratos packages to both hosts and extract them under /opt folder.

  * Create an init.d script for Stratos using following code and update USER, JAVA_HOME and PRODUCT_HOME variable values:

    ````
    https://gist.github.com/imesh/5256272cd71b74a06581

    #!/bin/sh
    ### BEGIN INIT INFO
    # Provides:          stratos
    # Required-Start:    $local_fs $remote_fs $network $syslog $named
    # Required-Stop:     $local_fs $remote_fs $network $syslog $named
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # X-Interactive:     true
    # Short-Description: Start/stop stratos server
    ### END INIT INFO

    USER="vagrant"
    PRODUCT_NAME="stratos"
    JAVA_HOME="/opt/jdk1.7.0_60"
    PRODUCT_HOME="/opt/apache_stratos_4.1.0_SNAPSHOT"
    PID_FILE="${PRODUCT_HOME}/wso2carbon.pid"
    CMD="${PRODUCT_HOME}/bin/stratos.sh"

    # LSB exit codes:
    # ftp://ftp.nomadlinux.com/nomad-2/dist/heartbeat-1.2.5/include/clplumbing/lsb_exitcodes.h

    LSB_EXIT_OK=0
    LSB_EXIT_GENERIC=1
    LSB_EXIT_EINVAL=2
    LSB_EXIT_ENOTSUPPORTED=3
    LSB_EXIT_EPERM=4
    LSB_EXIT_NOTINSTALLED=5
    LSB_EXIT_NOTCONFIGED=6
    LSB_EXIT_NOTRUNNING=7

    is_service_running() {
	    if [ -e ${PID_FILE} ]; then
	        PID=`cat ${PID_FILE}`
	        if ps -p $PID >&- ; then
			    # service is running
			    return 0
		        else
			    # service is stopped
			    return 1
	            fi
	         else
		# pid file was not found, may be server was not started before
		return 1
	    fi
    }

    # Status the service
    status() {
        is_service_running
        service_status=$?

        if [ "${service_status}" -eq 0 ]; then
            echo "${PRODUCT_NAME} service is running"
            return ${LSB_EXIT_OK}
            elif [ "${service_status}" -eq 1 ]; then
            echo "$PRODUCT_NAME service is stopped"
            return ${LSB_EXIT_OK}
            else
            echo "$PRODUCT_NAME service status is unknown"
            return ${LSB_EXIT_GENERIC}
            fi
        }

        # Start the service
        start() {
	        if is_service_running; then
            echo "${PRODUCT_NAME} service is already running"
            return ${LSB_EXIT_OK}
            fi

            echo "starting ${PRODUCT_NAME} service..."
            su - ${USER} -c "export JAVA_HOME=${JAVA_HOME}; ${CMD} start"

            is_service_running
            service_status=$?
            while [ "$service_status" -ne "0" ]
            do
            sleep 1;
            is_service_running
            service_status=$?
            done

            echo "${PRODUCT_NAME} service started"
            return ${LSB_EXIT_OK}
        }

        # Restart the service
        restart() {
            echo "restarting ${PRODUCT_NAME} service..."
            su - ${USER} -c "export JAVA_HOME=${JAVA_HOME}; ${CMD} restart"
            echo "${PRODUCT_NAME} service restarted"
            return ${LSB_EXIT_OK}
        }

        # Stop the service
        stop() {
            if ! is_service_running; then
            echo "${PRODUCT_NAME} service is already stopped"
            return ${LSB_EXIT_OK}
            fi

            echo "stopping ${PRODUCT_NAME} service..."
            su - ${USER} -c "export JAVA_HOME=${JAVA_HOME}; ${CMD} stop"

            is_service_running
            service_status=$?
            while [ "$service_status" -eq "0" ]
            do
            sleep 1;
            is_service_running
            service_status=$?
            done

            echo "${PRODUCT_NAME} service stopped"
            return ${LSB_EXIT_OK}
        }
        ### main logic ###
        case "$1" in
        start)
            start
        ;;
        stop|graceful-stop)
            stop
        ;;
        status)
            status
        ;;
        restart|reload|force-reload)
            restart
        ;;
        *)
        echo $"usage: $0 {start|stop|graceful-stop|restart|reload|force-reload|status}"
        exit 1
        esac
        exit $?
        ````


	
  * Create a CRM resource for stratos:

````
crm configure primitive STRATOS lsb::stratos op monitor interval=15s
````
	
  * Create a CRM resource group and add FAILOVER-IP and STRATOS resources:

````
crm configure group FAILOVER-IP-RESOURCE-GROUP FAILOVER-IP STRATOS
````
	
  * Configure a colocation dependency between FAILOVER-IP and STRATOS. This will make sure that both FAILOVER-IP and STRATOS resources will stay in the same host.

````
crm configure colocation FAILOVER-IP-RESOURCE-GROUP-COLOCATION inf: FAILOVER-IP STRATOS
````

