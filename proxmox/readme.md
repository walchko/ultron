![](https://www.proxmox.com/images/proxmox/Proxmox_logo_standard_hex_400px.png#joomlaImage://local-images/proxmox/Proxmox_logo_standard_hex_400px.png?width=400&height=60)

# Proxmox Ansible

Setup new Proxmox LXC Debian 12 contrainers

## Commands

```
changevenv ansible
ansible-playbook update.yml
ansible-playbook -i <ip>, -u root <file>.yml
```

## ansible-vault

```
ansible-vault encrypt|decrypt|view file
```

## Playbooks

| Playbook          | Description |
|-------------------|-------------|
| `file-server.yml` | setup Samba and NFS file server for plex or other things
| `pihole-init.yml` | setup Pi Hole ad blocker and DHCP server
| `plex.yml`        | setup Plex media player