# Asus

## BIOS

- Advanced
  - SA Config
    - vt-d `enabled` ✅
    - above 4G `enabled` ✅
  - Intel virtualization `enabled` ✅
  - CPU Power Mgt
    - Turbo mode `disabled` ❌
  - APM
    - Power PCIe
      - Wake-on-LAN `enabled` ✅
  - Onboard device config
    - Parallel port `disabled` ❌
- Ai Tweaker
  - CPU power mgt
    - Intel speedstep `auto`
    - Turbo mode `disabled` ❌
  - CPU Core ratio `per core`
  - EPU power mode `enabled` ✅
- Monitor
  - Anti-surge support (OVP UVP) `enabled` ✅
  - Fan 1 `disabled` ❌
  - Fan 2 `motherboard` `enabled` ✅

## `apt`

Installed but not sure the value of this:
- `linux-cpupower`
- `cpufrequtils`
- `cpufreqd`
  ```
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

## Command Outputs

```
# lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bridge/DRAM Registers (rev 07)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 530 (rev 06)
00:14.0 USB controller: Intel Corporation 100 Series/C230 Series Chipset Family USB 3.0 xHCI Controller (rev 31)
00:16.0 Communication controller: Intel Corporation 100 Series/C230 Series Chipset Family MEI Controller #1 (rev 31)
00:17.0 SATA controller: Intel Corporation Q170/Q150/B150/H170/H110/Z170/CM236 Chipset SATA Controller [AHCI Mode] (rev 31)
00:1c.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #5 (rev f1)
00:1d.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #9 (rev f1)
00:1f.0 ISA bridge: Intel Corporation B150 Chipset LPC/eSPI Controller (rev 31)
00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
```

```
# lsblk
NAME                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                            8:0    0 238.5G  0 disk 
├─sda1                         8:1    0  1007K  0 part 
├─sda2                         8:2    0     1G  0 part /boot/efi
└─sda3                         8:3    0 237.5G  0 part 
  ├─pve-swap                 252:0    0     8G  0 lvm  [SWAP]
  ├─pve-root                 252:1    0  69.4G  0 lvm  /
  ├─pve-data_tmeta           252:2    0   1.4G  0 lvm  
  │ └─pve-data-tpool         252:4    0 141.2G  0 lvm  
  │   ├─pve-data             252:5    0 141.2G  1 lvm  
  │   ├─pve-vm--100--disk--0 252:6    0    32G  0 lvm  
  │   ├─pve-vm--101--disk--0 252:7    0     8G  0 lvm  
  │   └─pve-vm--102--disk--0 252:8    0    16G  0 lvm  
  └─pve-data_tdata           252:3    0 141.2G  0 lvm  
    └─pve-data-tpool         252:4    0 141.2G  0 lvm  
      ├─pve-data             252:5    0 141.2G  1 lvm  
      ├─pve-vm--100--disk--0 252:6    0    32G  0 lvm  
      ├─pve-vm--101--disk--0 252:7    0     8G  0 lvm  
      └─pve-vm--102--disk--0 252:8    0    16G  0 lvm  
sdb                            8:16   0 238.5G  0 disk 
└─sdb1                         8:17   0 238.5G  0 part 
sdc                            8:32   0   1.8T  0 disk 
```

```
# lscpu
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         39 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  8
  On-line CPU(s) list:   0-7
Vendor ID:               GenuineIntel
  BIOS Vendor ID:        Intel(R) Corporation
  Model name:            Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz
    BIOS Model name:     Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz To Be Filled By O.E.M. CPU @ 3.4GH
                         z
    BIOS CPU family:     198
    CPU family:          6
    Model:               94
    Thread(s) per core:  2
    Core(s) per socket:  4
    Socket(s):           1
    Stepping:            3
    CPU(s) scaling MHz:  100%
    CPU max MHz:         3400.0000
    CPU min MHz:         800.0000
    BogoMIPS:            6799.81
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 cl
                         flush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm
                          constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_ts
                         c cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 sss
                         e3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_dead
                         line_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault
                          invpcid_single pti ibrs ibpb stibp tpr_shadow flexpriority ept vpid ept_a
                         d fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx rdseed 
                         adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm arat pl
                         n pts hwp hwp_notify hwp_act_window hwp_epp vnmi
Virtualization features: 
  Virtualization:        VT-x
Caches (sum of all):     
  L1d:                   128 KiB (4 instances)
  L1i:                   128 KiB (4 instances)
  L2:                    1 MiB (4 instances)
  L3:                    8 MiB (1 instance)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-7
Vulnerabilities:         
  Gather data sampling:  Vulnerable: No microcode
  Itlb multihit:         KVM: Mitigation: VMX disabled
  L1tf:                  Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                   Vulnerable: Clear CPU buffers attempted, no microcode; SMT vulnerable
  Meltdown:              Mitigation; PTI
  Mmio stale data:       Vulnerable: Clear CPU buffers attempted, no microcode; SMT vulnerable
  Retbleed:              Mitigation; IBRS
  Spec rstack overflow:  Not affected
  Spec store bypass:     Vulnerable
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:            Mitigation; IBRS, IBPB conditional, STIBP conditional, RSB filling, PBRSB-
                         eIBRS Not affected
  Srbds:                 Vulnerable: No microcode
  Tsx async abort:       Vulnerable: Clear CPU buffers attempted, no microcode; SMT vulnerable
```

## Fan Problem

**solved?**

```
# sensors
coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +33.0°C  (high = +84.0°C, crit = +100.0°C)
Core 0:        +33.0°C  (high = +84.0°C, crit = +100.0°C)
Core 1:        +28.0°C  (high = +84.0°C, crit = +100.0°C)
Core 2:        +29.0°C  (high = +84.0°C, crit = +100.0°C)
Core 3:        +30.0°C  (high = +84.0°C, crit = +100.0°C)

acpitz-acpi-0
Adapter: ACPI interface
temp1:        +27.8°C  (crit = +119.0°C)
temp2:        +29.8°C  (crit = +119.0°C)
```

Fans are quiet while:

```
# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
performance
performance
performance
performance
performance
performance
performance
performance
```

```
# cat /etc/default/cpufreqd 
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
