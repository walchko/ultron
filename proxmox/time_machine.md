![](./servers.jpg)

# Time Machine

> **WARNING:** It appears Samba has issues with time machine, but
> people have success with netatalk.

## Debian 12 and Samba Issues

- `netatalk` is not available, use Debian 11
- `samba` appears to have issues too, I couldn't make it easily work

## Debian 11

- Create a Debian 11 CT
    - 1 core, 1GB RAM
    - Disk tab:
        - LVM-thin 8GB root
        - `add` a 1TB `/mnt/backup` ext4

```bash
# df -Th
Filesystem                                    Type      Size  Used Avail Use% Mounted on
/dev/mapper/file_server_disk-vm--105--disk--0 ext4      7.8G  785M  6.6G  11% /
/dev/mapper/thin_2TB-vm--105--disk--0         ext4     1007G   17G  940G   2% /mnt/backup
none                                          tmpfs     492K  4.0K  488K   1% /dev
udev                                          devtmpfs   16G     0   16G   0% /dev/tty
tmpfs                                         tmpfs      16G     0   16G   0% /dev/shm
tmpfs                                         tmpfs     6.3G  140K  6.3G   1% /run
tmpfs                                         tmpfs     5.0M  4.0K  5.0M   1% /run/lock
tmpfs                                         tmpfs     3.2G   12K  3.2G   1% /run/user/1000
```

## `netatalk` Setup

`.env`:
```conf
My_Cool_Password
```

```bash
apt install update && apt install netatalk -y

# create user w/password held in .env file
PSW=$(<".env")
EC=$(perl -e 'print crypt($ARGV[0], password)' "${PSW}")
useradd --no-create-home --password $EC --home-dir /mnt/backup tm

# create mount points for backups
mkdir -p /mnt/backup/time-machine

# fix permissions
chown tm:tm -R /mnt/backup/time-machine
chown og-rwx -R /mnt/backup/time-mahcine

# update AFP config
tee -a /etc/netatalk/afp.conf << EOF
[Mac Mini Time Machine Backup]
path = /mnt/backup/time-machine
time machine = yes
valid users = tm
EOF

service netatalk restart
```

## All Done

```bash
# netatalk -V
netatalk 3.1.12 - Netatalk AFP server service controller daemon

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version. Please see the file COPYING for further information and details.

netatalk has been compiled with support for these features:

      Zeroconf support: Avahi
     Spotlight support: Yes

                  afpd: /usr/sbin/afpd
            cnid_metad: /usr/sbin/cnid_metad
       tracker manager: /usr/bin/tracker daemon
           dbus-daemon: /usr/bin/dbus-daemon
              afp.conf: /etc/netatalk/afp.conf
     dbus-session.conf: /etc/netatalk/dbus-session.conf
    netatalk lock file: /var/lock/netatalk
```

# References

- [Netatalk](https://dgross.ca/blog/linux-time-machine-server/)
- [Alt Netatalk](https://www.genieblog.ch/blog/en/2023/a-working-netatalk-setup-on-debian-12/)
- [Samba](https://dev.to/ea2305/time-machine-backup-with-your-home-server-1lj6)