# Setup Azure Domain Services & Kerberos


**Remember**: After creating a new *Azure Domain Services*, users are required to update their passwords [**here**](https://account.activedirectory.windowsazure.com/)  then re-sign in for the DNS to recognize them.

[Learn more...](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-getting-started-password-sync)

### NOTE: Tested and works on Ubuntu 16.04
* Follow [this tutorial](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-join-ubuntu-linux-vm) for Ubuntu 17.01

## Prereqs:

1. [Setup Azure Domain Services](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-getting-started)

2. [Provision an Ubuntu Linux virtual machine](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-join-ubuntu-linux-vm#provision-an-ubuntu-linux-virtual-machine)

> Deploy the virtual machine into the **same virtual network in which you have enabled Azure AD Domain Services**.

> Pick a **different subnet** than the one in which you have enabled Azure AD Domain Services.


## How to Use

**Clone this repo on the provisioned Ubuntu Linux virtual machine:**

```
> sudo git clone https://github.com/User1m/aad-kerberos-setup.git
```

**`cd` into the repo:**

```
> cd aad-kerberos-setup
```

**Run:**

```
> sudo ./join-domain.sh my-domain.onmicrosoft.com admin admin-password vm-host-name
```

* Be aware that running this command will take the parameters passed and modify the `sample.conf` files included in the repo.
* Should you mis-type something and need to change, simply revert the file changes and re-run the command.