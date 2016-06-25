#!/bin/bash

# set US locale UTF-8
localedef -c -i en_US -f UTF-8 en_US.UTF-8

# enable EPEL repository
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install some often used commands
yum install -y wget curl zip unzip patch less git vim nano psmisc

# installing syslog-ng, with workaround https://bugs.launchpad.net/ubuntu/+source/syslog-ng/+bug/1242173
yum install -y syslog-ng
# can't access /proc/kmsg. https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf

# prepare for using supervisor
yum install -y supervisor

# setup cron and logrotatae
yum install -y cronie logrotate


mkdir /etc/container_environment
mkdir /etc/workaround-docker-2267

# setup logfile to be writable by all
touch /var/log/startup.log
chmod 666 /var/log/startup.log

