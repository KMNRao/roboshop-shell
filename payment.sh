#!/bin/bash
ID=$(id -u)
R="\e[31m" 
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB_HOST=mongodb.mohana.cloud 
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

dnf install python36 gcc python3-devel -y 

id roboshop
if [ $? -ne 0 ]
then 
 useradd roboshop
 VALIDATE $? "roboshop user creation"
 else 
 echo -e "roboshop user already exist $Y SKIPPING $N"
 fi 

  mkdir -p /app &>> $LOGFILE 
  
  VALIDATE $? "Creating App Directory"

curl -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE $? "copying payment service"

cd /app &>> $LOGFILE


unzip -o /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "Unziping payments"

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "Installing dependencies"

cp home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE $? "copying payment service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Deamon reloading"

systemctl enable payment &>> $LOGFILE
VALIDATE $? "Enabling Payment"

systemctl start payment &>> $LOGFILE
VALIDATE $? "Starting payment"
