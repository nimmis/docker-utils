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

	# fix python 2.6
	yum install -y python26
	ln -sf /usr/bin/python2.6 /usr/bin/python
	# fix yum problem
	sed -i 's/usr\/bin\/python$/usr\/bin\/python2.4/' /usr/bin/yum 

	# install pip the hard way
	curl https://bootstrap.pypa.io/get-pip.py | python -

	# prepare for using supervisor
	# don't use old with repo, install new with pip
        pip install supervisor
        # install missing path
        mkdir -p /var/log/supervisor/

        # installing syslog-ng
        yum install -y syslog-ng syslog-ng-libdbi

        # can't access /proc/kmsg. https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
        sed -i '/\proc\/kmsg/d' /etc/syslog-ng/syslog-ng.conf

        # fix different location on syslog-ng for supervisord conf
        ln -s /sbin/syslog-ng /usr/sbin/

	;;
  6)
	# enable EPEL repository
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

	# install crontab
	yum install -y cronie

	# fix missing argpars in python
	yum install -y python-argparse

	# prepare for using supervisor
	# don't use old with repo, install new with pip
	yum install -y python-pip
	# workaround for version bug on 1.0.3 with supervisor
	pip install 'meld3 == 1.0.1'
	# install supervisor
	pip install supervisor
	# install missing path
	mkdir -p /var/log/supervisor/

	# installing syslog-ng
	yum install -y syslog-ng syslog-ng-libdbi

	# can't access /proc/kmsg. https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
	sed -i '/program_override/d' /etc/syslog-ng/syslog-ng.conf 

	# fix different location on syslog-ng for supervisord conf
	ln -s /sbin/syslog-ng /usr/sbin/
	;;
  7)
	# enable EPEL repository
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

	# install crontab
	yum install -y cronie

	# prepare for using supervisor
	yum install -y supervisor

        # installing syslog-ng
        yum install -y syslog-ng
	# can't access /proc/kmsg. https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
	sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf

	;;
esac

#install git after epel for version 5 to work
yum install -y git

# set US locale UTF-8
localedef -c -i en_US -f UTF-8 en_US.UTF-8


# setup cron and logrotatae
yum install -y logrotate


mkdir /etc/container_environment
mkdir /etc/workaround-docker-2267

# setup logfile to be writable by all
touch /var/log/startup.log
chmod 666 /var/log/startup.log

