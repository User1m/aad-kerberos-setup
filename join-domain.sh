#!/bin/sh

# DNSHOST='contoso.com'
# ADMINUSER='bob@contoso.com'

DNSHOST='intelADhackathonoutlook.onmicrosoft.com'
ADMINUSER='clmb@intelADhackathonoutlook.onmicrosoft.com'

## 1. CONFIGURE HOSTS
echo "127.0.0.1  $(hostname).$DNSHOST $(hostname)" >> /etc/hosts

## 2. Install required packages
## try passing -q and -y to make a quiet unattended install
# TODO: add sudo to commands
apt-get update --fix-missing \
&& apt-get -q -y install samba sssd sssd-tools libnss-sss libpam-sss ntp ntpdate realmd adcli
##Unattended install of krb5-user on Ubuntu 16.04
DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user

## 3. CONFIGURE NTP
echo "server $DNSHOST" >> /etc/ntp.conf
systemctl stop ntp
ntpdate $DNSHOST
systemctl start ntp

## 4. Join the Linux virtual machine to the managed domain
## WRITE /etc/krb5.conf
cp ./krb5.conf /etc/krb5.conf
realm discover $DNSHOST
## KINIT with Service Principal - figure out how to pass password
echo password | kinit $ADMINUSER
## Join domain
realm join --verbose $DNSHOST -U '$ADMINUSER' --install=/

## 5. Configure SSSD
echo "use_fully_qualified_names = True" >> /etc/sssd/sssd.conf
service sssd restart

## 6. Configure automatic home directory creation
echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0077" >> /etc/pam.d/common-session

bash