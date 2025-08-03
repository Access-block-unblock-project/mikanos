#!/bin/bash

image=$1
container=$2
target=$3
mount=$4

# Delete target.
rm -f $target

# Delete mount.
if mountpoint -q $mount; then
	sudo umount -l $mount
fi
if [ -e $mount ]; then
	rm -rf $mount
fi

# Stop the docker container.
if [ -n "$(docker ps --format {{.Names}} --filter name=^$container\$)" ]; then
	docker stop $container
fi

# Delete the docker conatiner.
if [ -n "$(docker ps -a --format {{.Names}} --filter name=^$container\$)" ]; then
	docker rm $container
fi

# Delete the docker image.
if [ -n "$(docker images --format {{.Repository}} $image)" ]; then
	docker rmi $image
fi

