#!/bin/bash

case $1 in

    "--list")
	echo -e "{\n" \
		"    \"_meta\": {\n" \
		"        \"hostvars\": {\n" \
		"            \"appserver\": {\n" \
		"                \"ansible_host\": $(yc compute instance get reddit-app --format json | jq '.network_interfaces[].primary_v4_address.one_to_one_nat.address')\n" \
		"            },\n" \
		"            \"dbserver\": {\n" \
		"                \"ansible_host\": $(yc compute instance get reddit-db --format json | jq '.network_interfaces[].primary_v4_address.one_to_one_nat.address')\n" \
		"            },\n" \
		"            \"dbserver2\": {\n" \
		"                \"ansible_host\": $(yc compute instance get reddit-db --format json | jq '.network_interfaces[].primary_v4_address.address')\n" \
		"            }\n" \
		"        }\n" \
		"    },\n" \
		"    \"all\": {\n" \
		"        \"children\": [\n" \
		"            \"app\",\n" \
		"            \"db\",\n" \
		"            \"ungrouped\"\n" \
		"        ]\n" \
		"    },\n" \
		"    \"app\": {\n" \
		"        \"hosts\": [\n" \
		"            \"appserver\"\n" \
		"        ]\n" \
		"    },\n" \
		"    \"db\": {\n" \
		"        \"hosts\": [\n" \
		"            \"dbserver\"\n" \
		"        ]\n" \
		"    },\n" \
		"    \"db2\": {\n" \
		"        \"hosts\": [\n" \
		"            \"dbserver2\"\n" \
		"        ]\n" \
		"    }\n" \
		"}\n" \
	;;

#    "--host")
#	echo -e "{\n" \
#		"    \"ansible_host\": $(yc compute instance get $2 --format json | jq '.network_interfaces[].primary_v4_address.one_to_one_nat.address')\n" \
#		"}\n"
#	;;
#
    *)
	echo "Usage: $0 --list [hostname]"
	exit 1
	;;
esac

exit 0