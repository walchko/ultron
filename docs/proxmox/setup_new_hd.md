# Install Hard Drive or SSD

## Get Serial Number

`/dev/sdc` has SN `S1RKNSAF702352` which I shorten the drive name
to `ssd-352`

```bash
# smartctl -i /dev/sdc

smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.8.12-5-pve] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     SAMSUNG MZ7TE256HMHP-00004
Serial Number:    S1RKNSAF702352
LU WWN Device Id: 5 002538 8a056d317
Firmware Version: EXT0200Q
User Capacity:    256,060,514,304 bytes [256 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
TRIM Command:     Available
Device is:        In smartctl database 7.3/5319
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Dec 30 14:17:26 2024 MST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
```

# New Directory Storage

1. `Datacenter` -> `Storage` -> `Add` -> `Directory`
1. Give it a name, `ssd-352` in this case
1. Give it a mount point, `/mnt/bindmounts/share_256G` in this case

> Double check `/etc/fstab` has the info, if not, add it like below

# New HD LVM-Thin Storage

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

## Format HD LVM-Thin Storage

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

# Alternative Adding Existing HD

**not sure which is best**

I would do it this way:

1. create that mountpoint first: `mkdir /mnt/backupHDD`
1. find out the `UUID` or `PARTUUID` of the partition of your backup disk.
   In the case of sda1: `blkid | grep sda1 | grep UUID=`
1. edit fstab: `nano /etc/fstab`, add something like this there in case you
   found a `PARTUUID`:
  ```
  PARTUUID=xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxx   /mnt/backupHDD   ext4   defaults   0   2
  ```
1. mount it by running: `mount -a`
1. Check that your backups are there: `ls -la /mnt/backupHDD`
1. Add a new directory storage pointing to that mountpoint using the webUI at
   Datacenter -> Storage -> Add -> Directory or do it using the CLI like
   this: `pvesm add dir backups --is_mountpoint 1 --path /mnt/backupHDD --content backup --shared 0`.
   In case you have choosen the webUI and not the CLI, enable the "is_mountpoint"
   with `pvesm set IdOfYourDirectoryStorage --is_mountpoint yes`. In case
   your dump directory isn't in the root of that filesystem you might
   need to use `pvesm set IdOfYourDirectoryStorage --is_mountpoint /mnt/backupHDD`
   and point the path to the folder that is containing the dump dir.

[ref](https://forum.proxmox.com/threads/adding-an-existing-hdd-to-proxmox.118361/)
