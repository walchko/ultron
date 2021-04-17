![](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)

# Pi Plex Server

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/linuxserver/plex)

## Setup

- Install `docker`
- Setup `python3` and `docker-compose` in a virtual environment
    - `sudo apt install python3-venv`
    - `python3 -m venv ~/venv`
    - `source ~/venv/bin/activate`
    - `pip install -U pip setuptools wheel docker-compose`
    - Add `. ~/venv/bin/activate` to `.bashrc`
- Create `docker-compose.yml`

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
