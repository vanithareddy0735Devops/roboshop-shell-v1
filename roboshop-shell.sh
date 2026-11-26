#!/bin/bash

ami_id=ami-0055977a6e828a4f4
instance_type=t3.micro
domain_name=devopsvanitha.store
hosted_zone_id=Z06591282AN0UYQZN7Q82

for instance in $@
do
instance_id=$(aws ec2 run-instances \
  --image-id $ami_id \
  --count 1 \
  --instance-type $instance_type \
  --security-groups "roboshop-common" "roboshop-$instance" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
  --query "Instances[0].InstanceId" \
  --output text
)

echo "$instance ID: $instance_id"
done