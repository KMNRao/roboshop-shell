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

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling current NodeJS" &>> $LOGFILE 
 
 dnf module enable nodejs:18 -y &>> $LOGFILE 
 VALIDATE $? "Enabling NodeJS:18" &>> $LOGFILE 

 dnf install nodejs -y &>> $LOGFILE 
 VALIDATE $? "Installing NodeJS:18"

id roboshop
if [ $? -ne 0 ]
then 
 useradd roboshop
 VALIDATE $? "roboshop user creation"
 else 
 echo -e "roboshop user already exist $Y SKIPPING $N 
 fi 
 
  mkdir -p /app &>> $LOGFILE 
  VALIDATE $? "Creating App Directory"

  curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip 
  VALIDATE $? "Dowloading Catalogue application" 
  cd /app 
  unzip -o /tmp/catalogue.zip &>> $LOGFILE 
  VALIDATE $? "Unzipping catalogue Files" 

npm install &>> $LOGFILE 
VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue service file"

 systemctl daemon-reload &>> $LOGFILE
 VALIDATE $? "Demon Loading"

 systemctl enable catalogue &>> $LOGFILE
 VALIDATE $? "Enabling Catalogue"

 systemctl start catalogue &>> $LOGFILE
 VALIDATE $? "Start Catalogue"

 cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
 VALIDATE $? "Copying MongoDB Repo"

 dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing MongoDB client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE 
VALIDATE $? "Loading Catalogue data into MongoDB"





