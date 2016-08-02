#!/bin/sh
#
# install utilities on docker container 
# - nimmis/alpine
# - nimmis/alpine-micro
# - nimmis/ubuntu
# - nimmis/centos
#
# (c) 2016 nimmis <kjell.havneskold@gmail.com>
#
#

#
# get basedirecoty for installation
#

BASEDIR=$(dirname "$0") 

#
# which_os
#
# determine which containter this is
#
# returns
#   alpine - if alpine os
#   ubuntu - if ubuntu os
#   centos - if centos os
#
which_os() {
  os="unknown"

  if [ -f /etc/os-release ]; then
    os=$(grep ^ID= /etc/os-release | awk -F"=" '{print $2}' | sed 's/"//g')
  fi
  echo ${os}
}

#
# which_init
#
# determine which init process is used
#
# returns
#   runit       - if runit is used
#   supervidord - if supervisord is used
#
which_init() {

  init="unknown"

  if [ -d /etc/supervisor.d ]; then
    init="supervisord"
  fi

  if [ -d /etc/runit ]; then
    init="runit"
  fi

  echo ${init}
}


#
# install_init <init>
#
# install files for the init system
#
install_init() {
  cp -Rp $BASEDIR/${1}/* /
}

#
# install_base <os>
#
# install basic files for the os
#
install_base() {

  # copy binaries to /usr/local/bin
  cp -p $BASEDIR/${1}/bin/* /usr/local/bin/

  # copy start files
  cp -Rp $BASEDIR/${1}/root/* /

}

  

#
# install os depedent files
#

install_base $(which_os)

#
# install init dependet files
#

install_init ${which_init}
