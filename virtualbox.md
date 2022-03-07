# VirtualBox
[✏️](https://github.com/meleu/my-notes/edit/master/apache.md)

## Installing

- official instructions: <https://www.virtualbox.org/wiki/Linux_Downloads>

On Linux Mint 20 (based on Ubuntu Focal)
```sh
# add the official repository
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

# add the key
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

# install it
sudo apt update && sudo apt install -y virtualbox-6.1

# just confirming
sudo systemctl status vboxdrv
```

What to do when experiencing `The following signatures were invalid BADSIG`:
```sh
sudo -s -H
apt-get clean
rm /var/lib/apt/lists/*
rm /var/lib/apt/lists/partial/*
apt-get clean
apt-get update
```

