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