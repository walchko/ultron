# Plex

```
Datacenter
+- proxmox node
   +- plex CT
```

- Create a Debian container
  - make priviledged container
- Setup and install
  ```
  apt update && apt upgrade -y
  apt install curl gnupg -y
  apt install cifs-utils -y  # SMB
  apt install nfs-common -y  # NFS

  curl -sS https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | tee /usr/share/keyrings/plex.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main" > /etc/apt/sources.list.d/plexmediaserver.list

  apt update && apt install plexmediaserver -y
  ```
- `reboot now`
- `systemctl status plexmediaserver`
- Visit `https://<your_plex_server_url>:32400/web`

## NAS NFS

- In `proxmox` -> `container` -> `options` -> `features` check NFS and now you should see `mount=nfs`
- Create mount point
  - `mkdir /mnt/plex`
  - edit `/etc/fstab` and add `<nas_ipaddr>:/<share> /mnt/plex nfs defaults 0 0`
    - `1.2.3.4:/volume/plex /mnt/plex nfs defaults 0 0`
- `mount -a`

## Proxmox Host Container

- Shutdown LXC plex CT
- proxmox shell: `pct set <id> -mp0 <source>,mp=<target>`
  - **id:** plex CT id
  - **source:** `/mnt/plex` where data is stored on proxmox
  - **target:** `/mnt/plex` where data is mounted on plex
- On `proxmox` host, in shell: `chown -R plex:plex /mnt/plex/`
- plex CT --> `resources` --> `mount point (mp0)` --> `/mnt/plex,mp=/mnt/plex`
- start plex

# References

- Plex in LXC container: [geekbitzone](https://www.geekbitzone.com/posts/2022/proxmox/plex-lxc/install-plex-in-proxmox-lxc/)