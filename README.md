Installation and user guide for certbot-superior.

Installation
===========

In a terminal of Linux distro of your choice:  

```
$ mkdir -pv /var/lib/repos && cd /var/lib/repos && git clone https://github.com/stefanfluit/certbot-superior.git
```

Launch the configure file, this will configure all the files and programs we need.

```
$ ./configure.sh
```

Make sure to edit the files in /var/lib/scripts, to make sure you set the right API key and other variables.

```
$ vim /var/lib/scripts/certbot-auto-renew.sh
```

And:  

```
$ vim /var/lib/scripts/cleanup.sh
```

And:  

```
$ vim /var/lib/scripts/prehook.sh
```

Systemd will now check every night 01:00 if there is a need to renew the cert. Check with: 

```
$ systemctl status certbot-superior.service
```

It defaults to seven days, so if the certificate from a certain host expires in <7 days, it initiates a renewal.

This will get you a domain.pem file in /etc/certbot/domain. You will have to take care of the rest. 

This is written because there is no DNS plugin available for Superior and i simple needed it. 

Work in progress
===========

This is a work in progress and will be updated soon.

