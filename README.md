# OWASP Mutillidae 2 Vagrant

Vagrant config to configure an Ubuntu 16.04 virtual machine and install [OWASP Mutillidae 2](https://sourceforge.net/projects/mutillidae/files/), a deliberately vulnerable PHP web application.

## Requirements

- [vagrant](https://www.vagrantup.com/docs/installation/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Changes from [fawkesley/owasp-mutillidae-vagrant:master ](https://github.com/fawkesley/owasp-mutillidae-vagrant)

- php 7.4 (Technically still EOL, but a bit less EOL than php 5)
- Ubuntu 20.04 LTS
- MySQL 8.0 (and its assorted changes in installation)
- A virtualbox internal network adapter with IP 172.16.1.3 in addition to the default NAT network since I'm poking at this with a Kali instance that's in the 172.16.1.0/24 subnet

## How to use

Get this repo

```
git clone https://github.com/brasstax/owasp-mutillidae-vagrant && cd owasp-mutillidae-vagrant
```

Invoke vagrant to create and provision the box:

```
mkdir -p ~/.cache/vagrant-apt-archives
vagrant up
```

Connect to [http://localhost:8080/mutillidae](http://localhost:8080/mutillidae) (or, within the intnet subnet, http://172.16.1.3/mutillidae)