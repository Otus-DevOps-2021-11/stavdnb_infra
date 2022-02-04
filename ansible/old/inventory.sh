#!/bin/bash
#if [ "$1" == "--list" ] ; then
s3cmd get s3://test-01234511/terraform.tfstate terraform.tfstate --force > /dev/null
APPSERVER=$(cat terraform.tfstate | jq '.outputs.external_ip_address_app.value')
DBSERVER=$(cat terraform.tfstate | jq '.outputs.external_ip_address_db.value')
DBLOCAL=$(cat terraform.tfstate | jq '.outputs.local_ip_address_db.value')
echo '{"all":{"children":{"app":{"hosts":{'$APPSERVER':null}},"db":{"hosts":{'$DBSERVER':null}},"dblocal":{"hosts":{'$DBLOCAL':null}}}}}' | jq '.' 
#rm terraform.tfstate
#elif [ "$1" == "--host" ]; then
#s3cmd get s3://test-01234511/terraform.tfstate terraform.tfstate --force > /dev/null
#APPSERVER=$(cat terraform.tfstate | jq '.outputs.external_ip_address_app.value')
#DBSERVER=$(cat terraform.tfstate | jq '.outputs.external_ip_address_db.value')
#DBLOCAL=$(cat terraform.tfstate | jq '.outputs.local_ip_address_db.value')
#echo '{"_meta": {"hostvars": {'$APPSERVER':{},'$DBSERVER': {}}}}' | jq '.'
#rm terraform.tfstate
#else
#   echo "{ }"
# fi
 