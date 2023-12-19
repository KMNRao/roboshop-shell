#!/bin/bash
ID=$(id -u)
R="\e[31m" 
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB_HOST=monfodb.mohana.cloud 
echo "script started executing at $TIMESTAMP" &>> $LOGFILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo -e "$2 ... $R FAILED $N"
    exit 1
    else
    echo -e "$2 ... $G SUCCES $N"
    fi
}
if [ $ID -ne 0 ]
then
echo -e "$R ERROR:: Please run this script with root acces $N"
exit 1
else 
echo "You are root user"
fi 

