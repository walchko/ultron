# `container`

`container` [reference](https://github.com/apple/container/blob/main/docs/command-reference.md)

## Usage Examples

```bash
container system start

container system stop
2025-09-28T15:34:42-0400 info com.apple.container.cli: stopTimeoutSeconds=5 [container] stopping containers
9c4f5328-2859-4a87-8d9d-0a38d7205eb1
aab68ac1-feb4-4478-93f3-f2eaa0231ed0
b9240efc-2d99-4527-a4ae-7759679cad71
fc78667d-fa6e-4810-a34c-081bdc1868f3
2025-09-28T15:34:42-0400 info com.apple.container.cli: [container] waiting for containers to exit
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.apiserver [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.container-runtime-linux.fc78667d-fa6e-4810-a34c-081bdc1868f3 [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.container-network-vmnet.default [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.container-core-images [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.apiserver [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.container-runtime-linux.b9240efc-2d99-4527-a4ae-7759679cad71 [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.container-runtime-linux.aab68ac1-feb4-4478-93f3-f2eaa0231ed0 [container] stopping service
2025-09-28T15:34:42-0400 info com.apple.container.cli: label=gui/501/com.apple.container.container-runtime-linux.9c4f5328-2859-4a87-8d9d-0a38d7205eb1 [container] stopping service
```

```bash
# simple interactive
container run -it debian /bin/bash

# interactive container with local file access
container run -it --volume $PWD:/workspace debian /bin/bash
```

```bash
# list all containers, even stopped ones
container list -a
ID                                    IMAGE                            OS     ARCH   STATE    ADDR
aab68ac1-feb4-4478-93f3-f2eaa0231ed0  docker.io/library/alpine:latest  linux  arm64  stopped  
fc78667d-fa6e-4810-a34c-081bdc1868f3  docker.io/library/debian:latest  linux  arm64  stopped  
b9240efc-2d99-4527-a4ae-7759679cad71  docker.io/library/debian:latest  linux  arm64  running  192.168.64.4

# all are stopped now
container list -a
ID                                    IMAGE                            OS     ARCH   STATE    ADDR
aab68ac1-feb4-4478-93f3-f2eaa0231ed0  docker.io/library/alpine:latest  linux  arm64  stopped  
b9240efc-2d99-4527-a4ae-7759679cad71  docker.io/library/debian:latest  linux  arm64  stopped  
9c4f5328-2859-4a87-8d9d-0a38d7205eb1  docker.io/library/debian:latest  linux  arm64  stopped  
fc78667d-fa6e-4810-a34c-081bdc1868f3  docker.io/library/debian:latest  linux  arm64  stopped  
```

```bash
container network ls
NETWORK  STATE    SUBNET
default  running  192.168.64.0/24
```
