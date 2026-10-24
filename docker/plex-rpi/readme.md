![](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)

# Pi Plex Server

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/linuxserver/plex)

Docker runs great on a Raspberry Pi 3 and better on a 4.

## Setup

- Install `docker`
- Setup `python3` and `docker-compose` in a virtual environment
    - `sudo apt install python3-venv`
    - `python3 -m venv ~/venv`
    - `source ~/venv/bin/activate`
    - `pip install -U pip setuptools wheel docker-compose`
    - Add `. ~/venv/bin/activate` to `.bashrc`
- Create `docker-compose.yml`

### Errors

- Errors about `permission`: `sudo chmod 777 /var/run/docker.sock`
- Make sure to add to group: `sudo usermod -aG docker pi`

## Run and Stop

- Update: `docker-compose pull`
- Run: `docker-compose up -d`
- Open `<hostname>:32400/web/index.html`
- Log in with Plex account
- Add a Library for movies or TV
- Stop: `docker-compose down`
    - Ensure you are in the same directory as this yaml script when running `down`

## Yaml File

Modify the script below to find movie folder:

```yaml
---
version: "2.1"
services:
  plex:
    image: ghcr.io/linuxserver/plex
    container_name: plex
    network_mode: host
    environment:
      - PUID=1000
      - PGID=1000
      - VERSION=docker
      - PLEX_CLAIM= #optional
    volumes:
      - /home/pi/plex/library:/config
      - /path/to/movies:/movies
    restart: unless-stopped
```

## USB Hard Drive

Find the UUID for the usb hard drive:

```bash
pi@ultron ~ $ sudo blkid
/dev/mmcblk0p1: LABEL="boot" UUID="A365-6756" TYPE="vfat" PARTUUID="4338245d-01"
/dev/mmcblk0p2: LABEL="rootfs" UUID="90a83158-560d-48ee-9de9-40c51d93c287" TYPE="ext4" PARTUUID="4338245d-02"
/dev/mmcblk0: PTUUID="4338245d" PTTYPE="dos"
/dev/sda1: UUID="1205f6bf-5477-4f85-a701-13360c85f33e" TYPE="ext4" PARTUUID="6d95cef4-01"
```

Modify `/etc/fstab` to automount the drive:

```
proc            /proc           proc    defaults          0       0
PARTUUID=f84b4b6e-01  /boot           vfat    defaults          0       2
PARTUUID=f84b4b6e-02  /               ext4    defaults,noatime  0       1
# a swapfile is not a swap partition, no line here
#   use  dphys-swapfile swap[on|off]  for that
UUID=1205f6bf-5477-4f85-a701-13360c85f33e /mnt/usbdrive ext4 defaults,auto,nofail,user,rw 0 0
```

After a quick reboot and alowing the drive to be automounted, we should get something like this:

```bash
pi@ultron ~ $ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 238.5G  0 disk 
└─sda1        8:1    0 238.5G  0 part /mnt/usbdrive
mmcblk0     179:0    0  14.9G  0 disk 
├─mmcblk0p1 179:1    0  43.1M  0 part /boot
└─mmcblk0p2 179:2    0  14.8G  0 part /
```
# Strange Error

```
Creating plex ... done
Attaching to plex
plex    | [s6-init] making user provided files available at /var/run/s6/etc...exited 0.
plex    | [s6-init] ensuring user provided files have correct perms...exited 0.
plex    | [fix-attrs.d] applying ownership & permissions fixes...
plex    | [fix-attrs.d] done.
plex    | [cont-init.d] executing container initialization scripts...
plex    | [cont-init.d] 01-envfile: executing... 
plex    | [cont-init.d] 01-envfile: exited 0.
plex    | [cont-init.d] 10-adduser: executing... 
plex    | 
plex    | -------------------------------------
plex    |           _         ()
plex    |          | |  ___   _    __
plex    |          | | / __| | |  /  \
plex    |          | | \__ \ | | | () |
plex    |          |_| |___/ |_|  \__/
plex    | 
plex    | 
plex    | Brought to you by linuxserver.io
plex    | -------------------------------------
plex    | 
plex    | To support LSIO projects visit:
plex    | https://www.linuxserver.io/donate/
plex    | -------------------------------------
plex    | GID/UID
plex    | -------------------------------------
plex    | 
plex    | User uid:    1000
plex    | User gid:    1000
plex    | -------------------------------------
plex    | 
plex    | 
plex    | @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
plex    | 
plex    | Your DockerHost is most likely running an outdated version of libseccomp
plex    | 
plex    | To fix this, please visit https://docs.linuxserver.io/faq#libseccomp
plex    | 
plex    | Some apps might not behave correctly without this
plex    | 
plex    | @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
plex    | 
plex    | [cont-init.d] 10-adduser: exited 0.
plex    | [cont-init.d] 40-chown-files: executing... 
plex    | [cont-init.d] 40-chown-files: exited 0.

...

| [services.d] done.
plex    | Starting Plex Media Server.
plex    | libc++abi: terminating with uncaught exception of type std::__2::system_error: clock_gettime(CLOCK_MONOTONIC) failed: Operation not permitted
plex    | libc++abi: terminating with uncaught exception of type std::__2::system_error: clock_gettime(CLOCK_MONOTONIC) failed: Operation not permitted
plex    | ****** PLEX MEDIA SERVER CRASHED, CRASH REPORT WRITTEN: /config/Library/Application Support/Plex Media Server/Crash Reports/1.23.1.4602-280ab6053/PLEX MEDIA SERVER/dc9cde97-c147-4865-ec7c58ba-2a983e67.dmp
plex    | Starting Plex Media Server.
plex    | libc++abi: terminating with uncaught exception of type std::__2::system_error: clock_gettime(CLOCK_MONOTONIC) failed: Operation not permitted
plex    | libc++abi: terminating with uncaught exception of type std::__2::system_error: clock_gettime(CLOCK_MONOTONIC) failed: Operation not permitted
plex    | ****** PLEX MEDIA SERVER CRASHED, CRASH REPORT WRITTEN: /config/Library/Application Support/Plex Media Server/Crash Reports/1.23.1.4602-280ab6053/PLEX MEDIA SERVER/445d3d41-3c5d-45be-941aa6af-510dff84.dmp
```

- [linuxserver.io fix reference](https://docs.linuxserver.io/faq#libseccomp)

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138
echo "deb http://deb.debian.org/debian buster-backports main" | sudo tee -a /etc/apt/sources.list.d/buster-backports.list
sudo apt update
sudo apt install -t buster-backports libseccomp2
```
