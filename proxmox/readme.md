![](https://www.proxmox.com/images/proxmox/Proxmox_logo_standard_hex_400px.png#joomlaImage://local-images/proxmox/Proxmox_logo_standard_hex_400px.png?width=400&height=60)

# Machines

| Name    | IP  | Type | HD  | RAM | Services*  |
|---------|-----|------|-----|-----|------------|
| pihole  | 200 | XX   | 8GB | 1GB | DNS, Adblocking, DHCP
| pihole2 | 201 | CT   | 8GB | 1GB | DNS, Adblocking
| proxmox | 202 | XX   | 2TB | 32GB| hypervisor only
| fs      | 203 | VM   | 8GB | 1GB | NFS, SMB
| plex    | 204 | CT   | 8GB | 1GB | plex media
| tm      | 205 | CT   | 8GB | 1GB | netatalk

- `*`: All have `avahi-daemon`
- XX: Other
- CT: LXC
- VM: Virtual Machine

## Plex/NAS Setup

- fs (file server) VM
    - HD: LVM sized for OS and media
    - NFS: serve `/mnt/nfs`
    - SMB: serve `/mnt/nfs`
- plex CT
    - NFS: fstab `fs:/mnt/nft` `/mnt/nfs nfs defaults 0 0`
    - Options -> Feautures: `mount=nfs`
    - plex
- pihole2 CT
    - DHCP
        - range: 20-150
        - dns: 200, 201
    - Recursive DNS w/unbound
- tm (time machine) CT
    - HD
        - root_fs: `/` lvm-thin
        - mp0: `/mnt/backup` 2TB_thin

## Debian VM/CT Modifications

```bash
#/etc/bash_rc
cat << EOF >> /etc/bash.bashrc
alias ls="ls --color -h"
alias systemctl="systemctl --no-pager"
alias systemctl-running="systemctl list-units --type=service --state=running"
alias df="df -Th"
EOF
```

```
apt install avahi-daemon
apt install tree
```

## VM Only

- Don't install desktop
- Only install: basic OS and sshd

```bash
apt install sudo

# where [username] is what you setup during
# the installation
adduser [username]
usermod -aG sudo [username]
```

## Proxmox Host Modifications

All of the VM/CT mods, plus:

```bash

```

```bash
apt install lm-sensors
apt install duf
```

## Change IP Addr

`cat /etc/network/interfaces`:

```conf
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# primary nic dhcp
allow-hotplug ens18
iface ens18 inet dhcp
```

```conf
# primary nic static
auto ens18
iface ens18 inet static
    address 10.10.0.15/24
    gateway 10.10.0.1
    dns-nameservers 10.10.0.200 10.10.0.201
```

## CT Configurations

`cat /etc/pve/lxc/103.conf`:

```conf
arch: amd64
cores: 1
features: mount=nfs
hostname: plex
memory: 1024
net0: name=eth0,bridge=vmbr0,firewall=1,gw=10.0.1.1,hwaddr=BC:24:11:39:15:31,ip=10.0.1.204/24,type=veth
ostype: debian
rootfs: local-lvm:vm-103-disk-0,size=8G
swap: 512
```

## Nested Virtualization

This is for running a hypervisor inside another hypervisor.

## New HD LVM-Thin

> **WARNING:** There appears to be concern over data loss on thin
> drives if power is suddenly lost. LVM drives seem to retain data
> better, BUT allocate the entire required space at creation time.
> Thin LVMs only allocate space on write so the same LVM-thin drive
> *could* be over subscribe by VMs/CTs.

Web admin:

1. `proxmox` host -> Disks -> Wipe Disk
1. `proxmox` host -> Disks -> Initialize Disk with GPT
1. `proxmox` host -> Disks -> LVM-Thin -> Create: Thinpool
    - This will set up the disk and reserve 16GB for metadata pool

## Format HD LVM-Thin

`lsblk -f` (this is *after* I partitioned and formatted):

```bash
NAME FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1
│    ext4   1.0         af2b31c0-972b-42f1-bfa3-0f7964da5c95   26.9G     6% /
├─sda2
│
└─sda5
     swap   1           5b9594cd-8e94-447d-983e-b59578e5d9d9                [SWAP]
sdb
└─sdb1
     ext4   1.0         bb0f41fd-3259-4a63-b828-74fa2e8800e0  476.9G     0% /mnt/apple
sr0  iso966 Jolie Debian 12.5.0 amd64 n
                        2024-02-10-11-31-15-00
```

- `fdisk /dev/sdb`
    - `n`: new partition
    - `p`: primary partition
    - `return`: default next partition number
    - `return`: default start
    - `return`: default end
    - `w`: write and exit
- `mkfs.ext4 /dev/sdb1`
- `mkdir /mnt/apple`
- `echo "/dev/sdb1 /mnt/apple ext4 defaults 0 2" >> /etc/fstab`
- `mount /mnt/apple`



---

# Proxmox Ansible

Setup new Proxmox LXC Debian 12 contrainers

## Users

By default you can not ssh into a VM as root and VNC in proxmox doesn't
support copy/paste, so it is easier/safer to setup a user that can
ssh in and execute commands with copy/paste.

```bash
apt install sudo
adduser [username]
usermod -aG sudo [username]
```

## Commands

```bash
changevenv ansible
ansible-playbook update.yml
ansible-playbook -i <ip>, -u root <file>.yml
```

## ansible-vault

```bash
ansible-vault encrypt|decrypt|view file
```

## Playbooks

| Playbook          | Description |
|-------------------|-------------|
| `file-server.yml` | setup Samba and NFS file server for plex or other things
| `pihole-init.yml` | setup Pi Hole ad blocker and DHCP server
| `plex.yml`        | setup Plex media player