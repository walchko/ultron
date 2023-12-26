![](https://www.proxmox.com/images/proxmox/Proxmox_logo_standard_hex_400px.png#joomlaImage://local-images/proxmox/Proxmox_logo_standard_hex_400px.png?width=400&height=60)

# [Proxmox](https://www.proxmox.com)

Proxmox Virtual Environment is a complete, open-source server management platform for enterprise virtualization. It tightly integrates the KVM hypervisor and Linux Containers (LXC), software-defined storage and networking functionality, on a single platform. With the integrated web-based user interface you can manage VMs and containers, high availability for clusters, or the integrated disaster recovery tools with ease.

## Resources

- [install directions](https://www.proxmox.com/en/proxmox-virtual-environment/get-started)
- [hardware haven proxmox install](https://www.youtube.com/watch?v=_sfddZHhOj4)

## System Requirements

- Intel `EMT64` or `AMD64` with Intel `VT/AMD-V` CPU flag
- Memory, minimum 2 GB for OS and Proxmox VE services
  - Plus designated memory for guests.
  - For Ceph or ZFS additional memory is required, approximately 1 GB memory for every TB used storage
- Fast and redundant storage, best results with SSD disks.
- OS storage: Hardware RAID with batteries protected write cache (“BBU”) or non-RAID with ZFS and SSD cache
- VM storage:
  - For local storage use a hardware RAID with battery backed write cache (BBU) or non-RAID for ZFS
  - Neither ZFS nor Ceph are compatible with a hardware RAID controller.
- Redundant Gbit NICs, additional NICs depending on the preferred storage technology and cluster setup
  - 10 Gbit and higher is also supported
- For PCI(e) passthrough a CPU with `VT-d`/`AMD-d` CPU flag is needed

## Features

- Firewall: built-in, cluster-wide, IPv4 and IPv6
- Base OS: Debian
- Full virtualization with KVM/QEMU
- OS-level virtualization with LXC

## Services to Host

- [Paperless](https://github.com/paperless-ngx/paperless-ngx) document database ([tutorial](https://www.youtube.com/watch?v=uT9Q5WdBGos&t=687s))
- [OpnSense](https://opnsense.org) firewall
- PiHole (do in a container [example](https://www.youtube.com/watch?v=k0TwkSwLYWA))

## Generate SSL Certs

Let's Encrypt `DNS-01` verification allows cert creation **without** exposing anything
to the internet. Thus **NO** poking holes in your firewall

Directions [here](https://www.youtube.com/watch?v=qlcVx-k-02E)

- Use Duck DNS to verify private LAN domain name
- Nginx Proxy Manager
    - `docker-compose`: https://nginxproxymanager.com/setup/
        - Add other services here so they are all on the same docker network
          or set IP addresses in the DNS
    - supports Let's Encrypt `DNS-01` verification
      - create wildcard certs for other services
 












