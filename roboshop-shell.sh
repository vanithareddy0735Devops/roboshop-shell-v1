#!/bin/bash

ami_id=ami-0055977a6e828a4f4
instance-type=t3.micro
security-groups=$1
domain_name=devopsvanitha.store
hosted_zone_id=Z06591282AN0UYQZN7Q82

for instance in $@
do
echo "creating the instance: $instance"
done