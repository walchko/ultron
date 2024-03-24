# Proxmox Ansible

> **WARNING:** Not using `ansible` but some simple bash scripts

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