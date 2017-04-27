#!/usr/bin/env bash

#----------------#
#     config     #
#----------------#

# SELinuxを停止
if [ `getenforce` != 'disable' ]; then
    setenforce 0
    sed -e "s/(enforcing|permissive)/disabled/g" /etc/selinux/config
fi

#-------------------#
#     functions     #
#-------------------#

# 対象のプロセスが実行中か確認
isProgressService () {
    is_progress=`ps aux | grep -v grep | grep $1`
    if [ ${#is_progress} -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

#----------------------#
#     provisioning     #
#----------------------#

##### yum update , install
yum -y update
yum install -y vim tree wget git postfix ntp nkf cyrus-sasl cyrus-sasl-plain

##### iptables
if isProgressService 'iptables'; then
    service iptables stop
    chkconfig iptables off
fi

##### ntp
if ! isProgressService 'ntpd'; then
    service ntpd start
    chkconfig ntpd on
fi

##### expect
yum -y install expect

##### locate
yum -y install mlocate
updatedb

##### postfix
sudo cp -a /vagrant/provision/postfix/main.cf /etc/postfix/main.cf
sudo cp -a /vagrant/provision/postfix/master.cf /etc/postfix/master.cf
saslpasswd2 -c -u `/usr/sbin/postconf -h myhostname` vagrant
sudo service postfix restart

systemctl enable saslauthd.service
systemctl start saslauthd.service

##### Network restart
systemctl restart network
