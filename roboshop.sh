#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-059529b0d5245ccf4

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "web" "shipping" "payment" "dispatch")

ZONE_ID=Z09009163A0GN0OVQ08D2
DOMAIN_NAME="mohana.cloud"

for i in "${INSTANCES[@]}"
do
    echo "instance is: $i"
    if [ $i == "mangodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-059529b0d5245ccf4  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
    echo "$i: $IP_ADDRESS"

    create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '
done










#done
    #IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-059529b0d5245ccf4 
    #done
    #--tag-specifications "ResourceType=instance,Tags=[{key=Name,value=$i}]" --query "Instances[0].privateIpAddress" --output text)
#     echo "$i: $IP_ADDRESS"
    
#     aws router53 change-resources-record-sets \
#   --hosted-zone-id $ZONE_ID \
#   --change-batch '
#   {
#        "Comment": "creating a record set for cognito endpoint"
#         ,"Changes": [{
#         "Action"                : "UPSERT"
#         ,"ResourceRecordSet"    : {
#             "Name"              : "'$i'.'$DOMAIN_NAME'"
#             ,"Type"             : "A"
#             ,"TTL"              : 1
#             ,"ResourceRecord"   : [{
#                 "Value"         : "'$IP_ADDRESS'"
#             }]
#         }
#         }]
#     }
#         '

# done
