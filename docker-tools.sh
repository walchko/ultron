#!/bin/bash

useage(){
    echo "./program.sh [cmd]"
    echo " clean   Removes images with TAG <none>"
    echo " prune   Prunes system, containers, images, and volumes"
    exit 0
}

if [[ $# -eq 1 ]]; then
    CMD=$1
else
    CMD="none"
fi

if [[ ${CMD} == "help" ]]; then
    useage
    exit 0
elif [[ ${CMD} == "clean" ]]; then
    # remove intermediate images with TAG <none>
    docker images | egrep "^<none>" | awk '{print $3}' | xargs docker rmi -f
elif [[ ${CMD} == "prune" ]]; then
    echo "*** Prune system, containers, images, and volumes ***"
    docker system prune -a -f
    docker images prune -a
    docker volume prune -f
    docker container prune -f
    docker rmi $(docker images -a -q) # delete all images
    # docker rm $(docker ps -aq) # delete all containers
    echo "*** Done ***"
elif [[ ${CMD} == "none" ]]; then
    :
else
    useage
fi

echo ""
echo "[System]-------------------------"
docker system df
echo "[Containers]---------------------"
docker ps -a
echo "[Images]-------------------------"
docker images
