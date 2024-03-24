# Proxmox Plex

```
Datacenter
+- proxmox node
   +- plex CT
```

- Create a Debian container
  - keep unpriviledged container
- Setup and install
  ```bash
  apt update
  apt upgrade -y
  apt install curl gnupg -y
  apt install nfs-common -y  # NFS

  curl -sS https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | tee /usr/share/keyrings/plex.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main" > /etc/apt/sources.list.d/plexmediaserver.list

  apt update
  apt install plexmediaserver -y
  ```
- `reboot now`
- `systemctl status plexmediaserver`
- Visit `https://<your_plex_server_url>:32400/web` and finish installation

## NAS NFS

- In `proxmox` -> `container` -> `options` -> `features` check NFS and now you should see `mount=nfs`
- Create mount point
  - `mkdir /mnt/nfs`
  - edit `/etc/fstab` and add `<nas_ipaddr>:/<share> /mnt/nfs nfs defaults 0 2`
    - `1.2.3.4:/mnt/nfs /mnt/nfs nfs defaults 0 2`
- `mount -a`

# References

- Plex in LXC container: [geekbitzone](https://www.geekbitzone.com/posts/2022/proxmox/plex-lxc/install-plex-in-proxmox-lxc/)