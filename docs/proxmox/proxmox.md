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

### i7z

I think this just shows status

```
Cpu speed from cpuinfo 3408.00Mhz
cpuinfo might be wrong if cpufreq is enabled. To guess correctly try estimating via tsc
Linux's inbuilt cpu_khz code emulated now
True Frequency (without accounting Turbo) 3407 MHz
  CPU Multiplier 34x || Bus clock frequency (BCLK) 100.21 MHz

Socket [0] - [physical cores=4, logical cores=8, max online cores ever=4]
  TURBO DISABLED on 4 Cores, Hyper Threading ON
  Max Frequency without considering Turbo 3407.00 MHz (100.21 x [34])
  Max TURBO Multiplier (if Enabled) with 1/2/3/4 Cores is  40x/39x/38x/37x
  Real Current Frequency 3390.88 MHz [100.21 x 33.84] (Max of below)
        Core [core-id]  :Actual Freq (Mult.)      C0%   Halt(C1)%  C3 %   C6 %  Temp      VCore
        Core 1 [0]:       2664.35 (26.59x)         1     100       0       0    25      1.1426
        Core 2 [1]:       3390.88 (33.84x)         1    99.9       0       0    27      1.1223
        Core 3 [2]:       3102.56 (30.96x)         1     100       0       0    26      1.1423
        Core 4 [3]:       3126.36 (31.20x)         1    99.9       0       0    25      1.1425



C0 = Processor running without halting
C1 = Processor running with halts (States >C0 are power saver modes with cores idling)
C3 = Cores running with PLL turned off and core cache turned off
C6, C7 = Everything in C3 + core state saved to last level cache, C7 is deeper than C6
  Above values in table are in percentage over the last 1 sec
[core-id] refers to core-id number in /proc/cpuinfo
'Garbage Values' message printed when garbage values are read
  Ctrl+C to exit
```

```
# i7z
i7z DEBUG: i7z version: svn-r93-(27-MAY-2013)
i7z DEBUG: Found Intel Processor
i7z DEBUG:    Stepping 3
i7z DEBUG:    Model e
i7z DEBUG:    Family 6
i7z DEBUG:    Processor Type 0
i7z DEBUG:    Extended Model 5
i7z DEBUG: msr = Model Specific Register
i7z DEBUG: Unknown processor, not exactly based on Nehalem, Sandy bridge or Ivy Bridge
i7z DEBUG: msr device files exist /dev/cpu/*/msr
i7z DEBUG: You have write permissions to msr device files

------------------------------
--[core id]--- Other information
-------------------------------------
--[0] Processor number 0
--[0] Socket number/Hyperthreaded Sibling number  0,4
--[0] Core id number 0
--[0] Display core in i7z Tool: Yes

--[1] Processor number 1
--[1] Socket number/Hyperthreaded Sibling number  0,5
--[1] Core id number 1
--[1] Display core in i7z Tool: Yes

--[2] Processor number 2
--[2] Socket number/Hyperthreaded Sibling number  0,6
--[2] Core id number 2
--[2] Display core in i7z Tool: Yes

--[3] Processor number 3
--[3] Socket number/Hyperthreaded Sibling number  0,7
--[3] Core id number 3
--[3] Display core in i7z Tool: Yes

--[4] Processor number 4
--[4] Socket number/Hyperthreaded Sibling number  0,0
--[4] Core id number 0
--[4] Display core in i7z Tool: No

--[5] Processor number 5
--[5] Socket number/Hyperthreaded Sibling number  0,1
--[5] Core id number 1
--[5] Display core in i7z Tool: No

--[6] Processor number 6
--[6] Socket number/Hyperthreaded Sibling number  0,2
--[6] Core id number 2
--[6] Display core in i7z Tool: No

--[7] Processor number 7
--[7] Socket number/Hyperthreaded Sibling number  0,3
--[7] Core id number 3
--[7] Display core in i7z Tool: No

Socket-0 [num of cpus 4 physical 4 logical 8] 3,
Socket-1 [num of cpus 0 physical 0 logical 0] 
GUI has been Turned ON
i7z DEBUG: Single Socket Detected
i7z DEBUG: In i7z Single_Socket()
i7z DEBUG: guessing Nehalem
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

## Show running services

```
# systemctl list-units --type=service --state=running
  UNIT                     LOAD   ACTIVE SUB     DESCRIPTION                                            
  acpid.service            loaded active running ACPI event daemon
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
34 loaded units listed.
```









