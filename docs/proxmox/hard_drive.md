# Adding Existing HD

I would do it this way:

1. create that mountpoint first: `mkdir /mnt/backupHDD`
2. find out the `UUID` or `PARTUUID` of the partition of your backup disk.
   In your case of sda1: `blkid | grep sda1 | grep UUID=`
4. edit fstab: `nano /etc/fstab`, add something like this there in case you
   found a `PARTUUID`:
  ```
  PARTUUID=xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxx   /mnt/backupHDD   ext4   defaults   0   2
  ```
4. mount it by running: `mount -a`
5. Check that your backups are there: `ls -la /mnt/backupHDD`
6. Add a new directory storage pointing to that mountpoint using the webUI at
   Datacenter -> Storage -> Add -> Directory or do it using the CLI like
   this: `pvesm add dir backups --is_mountpoint 1 --path /mnt/backupHDD --content backup --shared 0`.
   In case you have choosen the webUI and not the CLI, enable the "is_mountpoint"
   with `pvesm set IdOfYourDirectoryStorage --is_mountpoint yes`. In case
   your dump directory isn't in the root of that filesystem you might
   need to use `pvesm set IdOfYourDirectoryStorage --is_mountpoint /mnt/backupHDD`
   and point the path to the folder that is containing the dump dir.

[ref](https://forum.proxmox.com/threads/adding-an-existing-hdd-to-proxmox.118361/)
