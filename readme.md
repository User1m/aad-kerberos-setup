# Setup Azure Domain Services & Kerberos


**Remember**: After creating a new *Azure Domain Services*, users are required to update their passwords [**here**](https://account.activedirectory.windowsazure.com/)  then re-sign in for the DNS to recognize them.

[Learn more...](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-getting-started-password-sync)

### NOTE: Tested and works on Ubuntu 16.04
* Follow [this tutorial](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-join-ubuntu-linux-vm) for Ubuntu 17.01

## How to Use

* Run:

```
> sudo ./join-domain.sh my-domain.onmicrosoft.com admin admin-password vm-host-name
```

* Be aware that running this command will take the parameters passed and modify the `sample.conf` files included in the repo.
* Should you mis-type something and need to change, simply revert the file changes and re-run the command.