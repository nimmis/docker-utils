#!/bin/bash

# install script for centos 5-7
#
# (c) nimmis <kjell.havneskold@gmail.com>, 2016
#


# fix missing dir
mkdir -p /usr/share/info/

# install some often used commands
yum install -y wget curl zip unzip patch less vim nano psmisc

# do versiondependent installations

RELEASEVER=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))

case "$RELEASEVER" in
  5)
	# enable EPEL repositor
	rpm -Uhv http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

	# install crontab
	yum install -y vixie-cron

	;;
  6)
	# enable EPEL repository
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

	# install crontab
	yum install -y cronie

	;;
  7)
	# enable EPEL repository
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

	# install crontab
	yum install -y cronie

	;;
esac

#install git after epel for version 5 to work
yum install -y git

# set US locale UTF-8
localedef -c -i en_US -f UTF-8 en_US.UTF-8


# installing syslog-ng, with workaround https://bugs.launchpad.net/ubuntu/+source/syslog-ng/+bug/1242173
yum install -y syslog-ng
# can't access /proc/kmsg. https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf

# prepare for using supervisor
yum install -y supervisor

# setup cron and logrotatae
yum install -y logrotate


mkdir /etc/container_environment
mkdir /etc/workaround-docker-2267

# setup logfile to be writable by all
touch /var/log/startup.log
chmod 666 /var/log/startup.log

