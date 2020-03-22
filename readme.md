![](https://static0.srcdn.com/wordpress/wp-content/uploads/Ultron-Marvel-Comics-Annihilation-Conquest-5.jpg?q=50&fit=crop&w=740&h=389)

![GitHub](https://img.shields.io/github/license/walchko/ultron)

I am grouping some of my docker containers together:

- Pi Hole 
- Octoprint ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/walchko/octoprint)

## Simple Instructions

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
