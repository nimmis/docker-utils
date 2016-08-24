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
# get_os
#
# determine which containter this is
#
# returns
#   alpine - if alpine os
#   ubuntu - if ubuntu os
#   centos - if centos os
#
get_os() {
  os="unknown"

  if [ -f /etc/os-release ]; then
    os=$(grep ^ID= /etc/os-release | awk -F"=" '{print $2}' | sed 's/"//g')
  fi
  echo ${os}
}

#
# get_init
#
# determine which init process is used
#
# returns
#   runit       - if runit is used
#   supervidord - if supervisord is used
#
get_init() {

  init="unknown"

  if [ -d /etc/supervisor*.d ]; then
    init="supervisord"
  fi

  if [ -d /etc/service ]; then
    init="runit"
  fi

  echo "${init}"
}


#
# install_init <init>
#
# install files for the init system
#
install_init() {

  printf "Installing init files for %s on OS %s .. " ${2} ${1}

  if [ -d $BASEDIR/${1}/init_${2}/ ]; then
    cp -RpP $BASEDIR/${1}/init_${2}/* /
    echo "OK"
  else
    echo "FAIL: source directory not found"
  fi
}

#
# install_base <os>
#
# install basic files for the os
#
install_base() {

  printf "Installing utilities and root files for %s .. " ${1}

  # copy binaries to /usr/local/bin
  cp -p $BASEDIR/${1}/bin/* /usr/local/bin/

  # copy start files
  cp -Rp $BASEDIR/${1}/root/* /

  echo "OK"
}

#
# pre_install <ok>
#
# run pre installation fixes
#

pre_install() {
  if [ -f $BASEDIR/${1}/pre_fix.sh ]; then
    printf "Running pre-install fixes for %s ...." ${1}
    $BASEDIR/${1}/pre_fix.sh
  fi
}
  

os_ver=$(get_os)
#
# run pre-install commands
#

pre_install ${os_ver}

#
# install os depedent files
#

install_base ${os_ver}

#
# install init dependet files
#
init_type=$(get_init)
install_init ${os_ver} ${init_type}

