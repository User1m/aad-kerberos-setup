#!/bin/bash

apt remove --purge --autoremove -y krb5-user samba sssd sssd-tools libnss-sss libpam-sss ntp ntpdate realmd adcli

## try passing -q and -y to make a quiet unattended install
apt-get -y update --fix-missing \
&& apt-get install -y ntp ntpdate \
&& apt-get install -y libnss-sss libpam-sss realmd adcli
##Unattended install of krb5-user on Ubuntu 16.04
# https://stackoverflow.com/questions/39804070/unattended-install-of-krb5-user-on-ubuntu-16-04
DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user
