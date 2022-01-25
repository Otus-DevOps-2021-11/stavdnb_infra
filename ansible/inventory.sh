#!/bin/bash
s3cmd get s3://test-01234511/terraform.tfstate terraform.tfstate --force > /dev/null
APPSERVER=$(cat terraform.tfstate | jq '.outputs.external_ip_address_app.value')
DBSERVER=$(cat terraform.tfstate | jq '.outputs.external_ip_address_db.value')
echo '{"all":{"children":{"app":{"hosts":{'$APPSERVER':null}},"db":{"hosts":{'$DBSERVER':null}}}}}' | jq '.' > inventory.json
rm terraform.tfstate
