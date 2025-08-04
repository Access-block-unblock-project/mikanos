#!/bin/bash

image=$1
container=$2
vnc_port=$3
target=$4

# Build a docker image.
if [ -z "$(docker images --format {{.Repository}} $image)" ]; then
	docker build --build-arg vnc_port=$vnc_port -t $image .
fi

# Create a docker conatiner.
if [ -z "$(docker ps -a --format {{.Names}} --filter name=^$container\$)" ]; then
	docker create -i -t -p $vnc_port:$vnc_port --privileged --name $container $image /bin/bash
	docker start $container
	docker exec --workdir /root/edk2 $container ./build_boot_loader.sh
	docker exec --workdir /root/mikanos $container ./build_mikanos.sh
	docker stop $container
fi

# Download MikanOS image file.
docker cp $container:/root/mikanos/$4 $4

