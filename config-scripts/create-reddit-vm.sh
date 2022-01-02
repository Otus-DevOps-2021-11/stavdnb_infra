#!/bin/bash
IMAGE_ID_APP=$(yc compute image list | grep reddit-full | awk '{print $2}')
yc compute instance create \
	--name reddit-app \
	--hostname reddit-app \
	--memory=2  \
	--create-boot-disk name=reddit-full,image-id=$IMAGE_ID_APP,size=10GB \
        --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
	--metadata serial-port-enable=1 \
	--ssh-key ~/.ssh/appuser.pub
