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

# Post Install Configuration

## Avahi Setup

```
apt install avahi-daemon
```

## Sensors

```
apt install hddtemp lm-sensors
```

```
# sensors
coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +31.0°C  (high = +84.0°C, crit = +100.0°C)
Core 0:        +29.0°C  (high = +84.0°C, crit = +100.0°C)
Core 1:        +28.0°C  (high = +84.0°C, crit = +100.0°C)
Core 2:        +28.0°C  (high = +84.0°C, crit = +100.0°C)
Core 3:        +27.0°C  (high = +84.0°C, crit = +100.0°C)

acpitz-acpi-0
Adapter: ACPI interface
temp1:        +27.8°C  (crit = +119.0°C)
temp2:        +29.8°C  (crit = +119.0°C)

nouveau-pci-0100
Adapter: PCI adapter
GPU core:    900.00 mV (min =  +0.88 V, max =  +1.08 V)
temp1:        +45.0°C  (high = +95.0°C, hyst =  +3.0°C)
                       (crit = +105.0°C, hyst =  +5.0°C)
                       (emerg = +135.0°C, hyst =  +5.0°C)
```

[displaying in proxmox](https://www.reddit.com/r/homelab/comments/rhq56e/displaying_cpu_temperature_in_proxmox_summery_in/)

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

## Reduce Power - NOT WORKING

**keeps booting into `performance` and setting it to `powersave` does nothing ... fan runs like mad**

### Bios

Turned off Turbo boost mode in BIOS - NOJOY

### cpufrequtils

**being replaced by cpupower?**

```
DIDN'T WORK
# Ref: https://forum.proxmox.com/threads/fix-always-high-cpu-frequency-in-proxmox-host.84270/
# Ref: https://wiki.archlinux.org/title/CPU_frequency_scaling
## cpu scaling
# proxmox uses performance by default change to powersave to enable cpu scaling
# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
apt install cpufrequtils

cat << 'EOF' > /etc/default/cpufrequtils
GOVERNOR="powersave"
EOF
```

### cpupower

**doesn't work**

```
# cpupower -c all frequency-set -g powersave
Setting cpu: 0
Setting cpu: 1
Setting cpu: 2
Setting cpu: 3
Setting cpu: 4
Setting cpu: 5
Setting cpu: 6
Setting cpu: 7
root@proxmox:~# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
powersave
powersave
powersave
powersave
powersave
powersave
powersave
powersave
```

```
# cpupower frequency-info
analyzing CPU 0:
  driver: intel_pstate
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency:  Cannot determine or is not supported.
  hardware limits: 800 MHz - 3.40 GHz
  available cpufreq governors: performance powersave
  current policy: frequency should be within 800 MHz and 3.40 GHz.
                  The governor "powersave" may decide which speed to use
                  within this range.
  current CPU frequency: Unable to call hardware
  current CPU frequency: 800 MHz (asserted by call to kernel)
  boost state support:
    Supported: no
    Active: no
```

### linux

Double check which states are valid:

```
# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
performance powersave
```

Other systems might have other modes, but mine has these two. You should be able to 
put the system into `powersave` or `performance`.

```
# echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
powersave

# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
powersave
powersave
powersave
powersave
powersave
powersave
powersave
powersave
```

- [home assistant and proxmox](https://community.home-assistant.io/t/psa-how-to-configure-proxmox-for-lower-power-usage/323731/4)

# Services to Host

- [Paperless](https://github.com/paperless-ngx/paperless-ngx) document database ([tutorial](https://www.youtube.com/watch?v=uT9Q5WdBGos&t=687s))
- [OpnSense](https://opnsense.org) firewall
- PiHole in LXC container:
  - [youtube video](https://www.youtube.com/watch?v=k0TwkSwLYWA)
  - [post](https://www.naturalborncoder.com/linux/2023/07/12/installing-pi-hole-on-proxmox/)
- Plex in LXC container: [geekbitzone](https://www.geekbitzone.com/posts/2022/proxmox/plex-lxc/install-plex-in-proxmox-lxc/)











