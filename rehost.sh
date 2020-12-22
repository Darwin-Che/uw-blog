#!/bin/bash

usage(){
	echo "Usage: ${0} machine_port abs_addr_machine"
	exit 1
}

if [ ${#} -ne 1 ]; then
	usage
fi

git pull

abs_addr_machine=${2}
abs_addr_docker="/uw-biblog"
container_name="uw-biblog"
image_name="darwinche/http-server-base"

echo "abs_addr_machine =  " ${abs_addr_machine}
echo "abs_addr_docker =  " ${abs_addr_docker}
echo "container_name =  " ${container_name}
echo "machine_port =  " ${1}


docker rm ${container_name}

docker run -ti --name ${container_name} -p ${1}:1234 -v ${abs_addr_machine}:${abs_addr_docker} ${image_name} bash -c "http-server ${abs_addr_docker} -p 1234"
