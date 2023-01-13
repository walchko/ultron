# Running ROS 2 nodes in Docker

[ref](https://docs.ros.org/en/humble/How-To-Guides/Run-2-nodes-in-single-or-separate-docker-containers.html)

```
$ docker pull osrf/ros:humble-desktop
$ docker run -it osrf/ros:humble-desktop
root@<container-id>:/#

root@<container-id>:/# ros2 pkg list
(you will see a list of packages)

root@<container-id>:/# ros2 pkg executables
(you will see a list of <package> <executable>)
```

## Run two nodes in two separate docker containers

```
docker run -it --rm osrf/ros:humble-desktop ros2 run demo_nodes_cpp talker
```

```
docker run -it --rm osrf/ros:humble-desktop ros2 run demo_nodes_cpp listener
```

Or `docker-compose`:

```dockerfile
version: '2'

services:
  talker:
    image: osrf/ros:humble-desktop
    command: ros2 run demo_nodes_cpp talker
  listener:
    image: osrf/ros:humble-desktop
    command: ros2 run demo_nodes_cpp listener
    depends_on:
      - talker
```

```
docker-compose up
```
