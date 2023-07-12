![](https://static0.srcdn.com/wordpress/wp-content/uploads/Ultron-Marvel-Comics-Annihilation-Conquest-5.jpg?q=50&fit=crop&w=740&h=389)

![GitHub](https://img.shields.io/github/license/walchko/ultron)

I am grouping some of my docker containers together:

- Pi Hole ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/pihole/pihole)
- Octoprint ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/octoprint/octoprint)
- Debian Linux ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/walchko/debian/latest)
- Rocky Linux ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/walchko/rocky/latest)

## Instructions for Using Existing Images from DockerHub

- Run `docker-compose` pull to get latest image
- Run `docker-compose up -d` to get things going
    - `-d` will detach it from the terminal, you can omit and use `ctrl-c` to shut it down
- Terminate with `docker-compose down`
- You **must** be in this sub folder with the `docker-compose.yaml` to run `up` and `down` commands


## Instructions for Building Images

1. `cd` into folder
1. `docker-compose build --compress --force-rm --no-cache --pull --parallel`
    1. `--compress` - Compress the build context using gzip
    2. `--force-rm` - Always remove intermediate containers
    3. `--no-cache` - Do not use cache when building the image
    4. `--pull` - Always attempt to pull a newer version of the image
    5. `--parallel` - Build images in parallel
1. To run container:
    1. Attached in foreground: `docker-compose up`
    1. Detached in backgroud: `docker-compose up -d`
1. `docker-compose down` to stop and clean-up

## Publish to DockerHub

1. `docker login`
1. `docker-compose push`
1. `docker logout`

## `docker-compose` Help

```bash
docker-compose -h
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --no-ansi                   Do not print ANSI control characters
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information

```

This manages containers so you don't have to. If spun up and the yaml has an entry
for `restart`, then it will be restarted after a shutdown/reboot.

## Cleaning Up

Docker is a pain in the ass to get rid of unneeded things. Try:

```
docker rm $(docker ps -a -q)
docker system prune -a -f
docker images prune -a
docker volume prune -f
docker container prune -f
# docker rmi $(docker ps -q)
docker rmi $(docker images -a -q) # delete all images
docker rm $(docker ps -aq) # delete all containers
```

## `docker-compose`

```yaml
---
version: '3'

services:
  debian:
    build: .
    image: walchko/debian:0.1
    container_name: debiancontainer
    hostname: debianhost
    ports:
      # - "443:443/tcp"
      - "2222:22/tcp"
```

```
(py)  kevin@Logan ultron % ./docker-tools.sh

[System]-------------------------
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          5         2         658.6MB   341.4MB (51%)
Containers      2         1         292.7kB   292.7kB (99%)
Local Volumes   0         0         0B        0B
Build Cache     42        0         1.485GB   1.485GB
[Containers]---------------------
CONTAINER ID  IMAGE              COMMAND                 CREATED        STATUS        PORTS                 NAMES
63da953f56a9  walchko/debian:0.1 "/usr/sbin/sshd -D"     9 seconds ago  Up 9 seconds  0.0.0.0:2222->22/tcp  debiancontainer
c69a8159c9d9  walchko/rocky:0.1  "/usr/sbin/sshd -D -e"  36 hours ago   Exited (0) 36 hours ago             rocky
[Images]-------------------------
REPOSITORY       TAG       IMAGE ID       CREATED        SIZE
walchko/debian   0.1       1af297533e07   6 hours ago    229MB
<none>           <none>    5839e60a0081   6 hours ago    229MB
<none>           <none>    20fdf844a080   6 hours ago    229MB
<none>           <none>    764d8562c3ee   30 hours ago   229MB
walchko/rocky    0.1       25293b510163   36 hours ago   205MB

```

# License MIT

**Copyright (c) 2019 Kevin J. Walchko**

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
