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

```bash
apt install avahi-daemon
apt install tree
```

## VM Only

- Don't install desktop
- Only install: basic OS and sshd

```bash
apt install sudo

# where [username] is what you setup during
# the installation and add them to sudo
adduser [username]
usermod -aG sudo [username]
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

