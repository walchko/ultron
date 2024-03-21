# New HD LVM-Thin

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