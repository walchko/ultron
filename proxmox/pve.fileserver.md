# Proxmox File Server

You really should do this as a VM.

> You can't do an NFS server from a container unless you
> do unsecure things (which is maybe OK in a homelab) like
> disable `aptarmor` and create a `priviledged` LXC.

## Useful

```bash
apt install tree duf
```

## NFS

- Install NFS packages
- Share directory, nfs defaults `root` user actions to `nobody:nogroup`
  so make sure they own it
- Add share directory to `/etc/exports` and start server

```bash
sudo apt install nfs-kernel-server
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server

sudo mkdir /mnt/nfs -p
sudo chown nobody:nogroup -R /mnt/nfs
sudo chmod 755 /mnt/nfs

sudo sh -c 'echo "/mnt/nfs 10.0.1.0/24(rw,sync,no_subtree_check)" >> /etc/exports'
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
```

Double check all is working:

```bash
$ sudo systemctl list-dependencies nfs-kernel-server
nfs-kernel-server.service
● ├─-.mount
○ ├─auth-rpcgss-module.service
● ├─nfs-idmapd.service
● ├─nfs-mountd.service
● ├─nfsdcld.service
● ├─proc-fs-nfsd.mount
● ├─rpc-statd-notify.service
● ├─rpc-statd.service
○ ├─rpc-svcgssd.service
● ├─rpcbind.socket
● ├─system.slice
● ├─network-online.target
● │ └─networking.service
● └─network.target
```

```bash
$ sudo cat /proc/fs/nfsd/versions
-2 +3 +4 +4.1 +4.2
```

## Samba

```bash
sudo apt install samba samba-common samba-common-bin cifs-utils python3-pexpect
```

Edit the samba config `/etc/samba/smb.conf`:

```conf
[global]
   workgroup = WORKGROUP
   wins support = yes
   dns proxy = no

#### Debugging/Accounting ####
   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d

####### Authentication #######
   server role = standalone server
   passdb backend = tdbsam
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user

############ Misc ############
# Allow users who've been granted usershare privileges to create
# public shares, not just authenticated ones
   usershare allow guests = yes

#======================= Share Definitions =======================
[nfs]
   read only = no
   path = /mnt/nfs
   guest ok = yes
```

```bash
sudo systemctl restart smbd.service
sudo systemctl restart nmbd.service
```

---

```bash
# not sure you need to do this
# smbpasswd -a [username]
```

## Setup Firewall

```bash
# iptables -A INPUT -p udp --dport 137 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
# iptables -A INPUT -p udp --dport 138 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
# iptables -A INPUT -p tcp --dport 139 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
# iptables -A INPUT -p tcp --dport 445 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
```

