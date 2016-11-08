#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required:  CentOS  6,7                                    #
#   Description: One click Install ShadowsocksR Server            #
#   Author: Teddysun <i@teddysun.com>                             #
#   Thanks: @breakwa11 <https://twitter.com/breakwa11>            #
#   Intro:  https://shadowsocks.be/9.html                         #
#=================================================================#

clear
echo
echo "#############################################################"
echo "# One click Install ShadowsocksR Server                     #"
echo "# Intro: https://shadowsocks.be/9.html                      #"
echo "# Author: Teddysun <i@teddysun.com>                         #"
echo "# Github: https://github.com/breakwa11/shadowsocks          #"
echo "#############################################################"
echo


#Make sure only root can run our script
rootness(){
    if [[ $EUID -ne 0  ]]; then
        echo "[-] Error:This script must be run as root!" 
	exit 1
    fi
	
}

#Disable_selinux
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0
    fi
}
# Pre-installation settings
pre_install(){
    yum -y install python-setuptools && easy_install pip
    yum -y install git
    yum -y install zip unzip
    systemctl stop  firewalld
    systemctl disable firewalld
    pip install cymysql
}
#Download_files
dowload_files(){
    cd /root
    # Download ShadowsocksR file
    if ! wget --no-check-certificate -O manyuser.zip https://github.com/tluolovembtan/shadowsocks/archive/manyuser.zip; then
        echo "Failed to download ShadowsocksR file!"
        exit 1
    fi
    unzip -q manyuser.zip
    mv shadowsocks-manyuser /usr/local/shadowsocks
}

install(){
    cd /usr/local/shadowsocks
    bash initcfg.sh
}
#Install ShadowsocksR
install_shadowsocks(){
    rootness
    disable_selinux
    pre_install
    dowload_files
    install
    
}
#main
install_shadowsocks