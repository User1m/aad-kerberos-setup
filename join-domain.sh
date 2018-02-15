#!/bin/sh

if [ -z "$1" ]; then
    echo "INFO: Missing DNS HOST NAME";
    echo "Usage Hint: ./join-domain.sh my-domain.onmicrosoft.com admin admin-password vm-host-name"
    exit 1;
fi

if [ -z "$2" ]; then
    echo "INFO: Missing ADMIN USER NAME";
    echo "Usage Hint: ./join-domain.sh my-domain.onmicrosoft.com admin admin-password vm-host-name"
    exit 1;
fi

if [ -z "$3" ]; then
    echo "INFO: Missing ADMIN USER PASSWORD";
    echo "Usage Hint: ./join-domain.sh my-domain.onmicrosoft.com admin admin-password vm-host-name"
    exit 1;
fi

if [ -z "$4" ]; then
    echo "INFO: Missing VM HOST NAME";
    echo "Usage Hint: ./join-domain.sh my-domain.onmicrosoft.com admin admin-password vm-host-name"
    exit 1;
fi

DNSHOST=$1
HOST_ALL_CAPS=$(echo $DNSHOST | tr '[:lower:]' '[:upper:]')
ADMINUSER=$2
ADMINUSERPW=$3
VMHOSTNAME=$4

sed -i -e "s/{DOMAIN-NAME-WILL-GO-HERE}/$DNSHOST/g" sssd.sample.conf krb5.sample.conf
sed -i -e "s/{DOMAIN-NAME-IN-ALL-CAPS-WILL-GO-HERE}/$HOST_ALL_CAPS/g" sssd.sample.conf krb5.sample.conf
sed -i -e "s/{HOST-VM-NAME-WILL-GO-HERE}/$VMHOSTNAME/g" sssd.sample.conf krb5.sample.conf

./install-deps.sh

## 1. CONFIGURE HOSTS
echo "\n127.0.0.1 $(hostname).$DNSHOST $(hostname)" >> /etc/hosts

## 2. CONFIGURE NTP
echo "\nserver $DNSHOST" >> /etc/ntp.conf
systemctl stop ntp
ntpdate $DNSHOST
systemctl start ntp

## 3. CONFIGURE Kerberos
## PLEASE EDIT krb5.sample.conf FIRST ##
cp ./krb5.sample.conf /etc/krb5.conf
realm discover $HOST_UPPER_CASE
## KINIT with Service Principal - figure out how to pass password
echo -n "$ADMINUSERPW" | kinit "$ADMINUSER"
## Join domain
echo -n "$ADMINUSERPW" | realm join --verbose $HOST_ALL_CAPS -U "$ADMINUSER@$HOST_ALL_CAPS" --install=/

## 4. Configure SSSD
apt-get install -y sssd sssd-tools samba
sudo systemctl enable sssd
sudo systemctl start sssd

## 5. Configure automatic home directory creation
echo "\nsession required pam_mkhomedir.so skel=/etc/skel/ umask=0077" >> /etc/pam.d/common-session