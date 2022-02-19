# KodeKloud Engineer

<https://kodekloud-engineer.com/>

## Create a Linux User with non-interactive shell

Get the credentials here: <https://kodekloudhub.github.io/kodekloud-engineer/docs/projects/nautilus>

Once logged in the required server:

```sh
adduser ${userName} -s /sbin/nologin
```


## Linux TimeZones Setting

```sh
# check current settings
timedatectl

# list the available timezones
timedatectl list-timezones

# set a timezone
sudo timedatectl set-timezone ${timezone}
```


## Disable root connections via ssh

Edit `/etc/ssh/sshd_config`, replaceing:
```sh
#PermitRootLogin yes
```
with
```sh
PermitRootLogin no
```

Restart sshd:
```sh
# on Ubuntu
systemctl restart sshd
```

