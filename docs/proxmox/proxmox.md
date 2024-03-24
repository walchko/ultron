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

## `fstab`

```bash
# cat /etc/fstab

# <file system> <mount point> <type> <options> <dump> <pass>
/dev/pve/root / ext4 errors=remount-ro 0 1
UUID=8FF4-D0E0 /boot/efi vfat defaults 0 1
/dev/pve/swap none swap sw 0 0
proc /proc proc defaults 0 0
```

# Post Install Configuration

## `apt`

```bash
apt update && apt upgrade -y
apt install avahi-daemon lm-sensors duf tree
```

```bash
# not sure this is really useful
apt install cpufreqd
```
```bash
# shows hardware power status and c-states
# not sure how useful it is yet ... still learning
apt install powertop
```

> **WARNING:** You will get `apt` errors in your task logs. This is because in the middle of
> the night, updates will fail. To fix this, in `/etc/apt/source.list.d/` remove both
> `ceph.list` and `pve-enterprise.list` and the no subscription repo, then do a `apt update`.

```conf
# /etc/apt/sources.list.d/pve-enterprise.list
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
```

- [displaying in proxmox](https://www.reddit.com/r/homelab/comments/rhq56e/displaying_cpu_temperature_in_proxmox_summery_in/)
- [no subscription repo](https://pve.proxmox.com/wiki/Package_Repositories)

## `powertop`

TBD

## `cpufreqd`

> **WARNING:** Installed but not sure the value of this, but maybe it
> keeps the fans quiet?

- `cpufreqd`
  ```conf
  cat /etc/default/cpufreqd
  # Cpufreqd startup configuration

  # CPU kernel module.
  # Leave empty if you wish to load the modules another way,
  # or if CPUFreq support for your cpu is built in.
  CPUFREQ_CPU_MODULE=""

  # Governor modules.
  # A list separated by spaces. They are needed by cpufreqd
  # to load your policies. The init script can automatically
  # try to load them. Leave empty to disable loading governor
  # modules at all, use "auto" to let the script do the job.
  CPUFREQ_GOV_MODULES="auto"
  ```

## C-States

[CPU Power Management](https://metebalci.com/blog/a-minimum-complete-tutorial-of-cpu-power-management-c-states-and-p-states/)

## Wake-on-LAN

- [proxmox forum](https://forum.proxmox.com/threads/wake-on-lan-on-pve.124785/)

## Adding Hard Drives

- [proxmox forum](https://forum.proxmox.com/threads/how-to-add-hard-drive-to-host.119376/)

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

## Show running services

```bash
# systemctl list-units --type=service --state=running
  UNIT                     LOAD   ACTIVE SUB     DESCRIPTION
  avahi-daemon.service     loaded active running Avahi mDNS/DNS-SD Stack
  chrony.service           loaded active running chrony, an NTP client/server
  cpufreqd.service         loaded active running LSB: start and stop cpufreqd
  cron.service             loaded active running Regular background program processing daemon
  dbus.service             loaded active running D-Bus System Message Bus
  dm-event.service         loaded active running Device-mapper event daemon
  getty@tty1.service       loaded active running Getty on tty1
  ksmtuned.service         loaded active running Kernel Samepage Merging (KSM) Tuning Daemon
  lxc-monitord.service     loaded active running LXC Container Monitoring Daemon
  lxcfs.service            loaded active running FUSE filesystem for LXC
  postfix@-.service        loaded active running Postfix Mail Transport Agent (instance -)
  pve-cluster.service      loaded active running The Proxmox VE cluster filesystem
  pve-firewall.service     loaded active running Proxmox VE firewall
  pve-ha-crm.service       loaded active running PVE Cluster HA Resource Manager Daemon
  pve-ha-lrm.service       loaded active running PVE Local HA Resource Manager Daemon
  pve-lxc-syscalld.service loaded active running Proxmox VE LXC Syscall Daemon
  pvedaemon.service        loaded active running PVE API Daemon
  pvefw-logger.service     loaded active running Proxmox VE firewall logger
  pveproxy.service         loaded active running PVE API Proxy Server
  pvescheduler.service     loaded active running Proxmox VE scheduler
  pvestatd.service         loaded active running PVE Status Daemon
  qmeventd.service         loaded active running PVE Qemu Event Daemon
  rpcbind.service          loaded active running RPC bind portmap service
  rrdcached.service        loaded active running LSB: start or stop rrdcached
  smartmontools.service    loaded active running Self Monitoring and Reporting Technology (SMART) Daemon
  spiceproxy.service       loaded active running PVE SPICE Proxy Server
  ssh.service              loaded active running OpenBSD Secure Shell server
  systemd-journald.service loaded active running Journal Service
  systemd-logind.service   loaded active running User Login Management
  systemd-udevd.service    loaded active running Rule-based Manager for Device Events and Files
  user@0.service           loaded active running User Manager for UID 0
  watchdog-mux.service     loaded active running Proxmox VE watchdog multiplexer
  zfs-zed.service          loaded active running ZFS Event Daemon (zed)

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
33 loaded units listed.
```









