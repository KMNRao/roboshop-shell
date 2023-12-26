#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-059529b0d5245ccf4

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "web" "shipping" "payment" "dispatch")

for i in "${INSTANCES[@]}"
do
    echo "instance is: $i"
    if [ $i == "mangodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-059529b0d5245ccf4 --tag-specifications "ResourceType=instance,Tags=[{key=Name,value=$i}]"

done
