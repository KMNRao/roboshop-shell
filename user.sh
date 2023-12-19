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
 echo -e "roboshop user already exist $Y SKIPPING $N"
 fi 
 
  mkdir -p /app &>> $LOGFILE 
  
  VALIDATE $? "Creating App Directory"

  curl  -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
  VALIDATE $? "Downloading user application"

  cd /app 
  
  unzip /tmp/user.zip &>> $LOGFILE
  VALIDATE $? "Unzipping"

  npm install &>> $LOGFILE
  VALIDATE $? "Installing dependencies"

  cp /home/centos/roboshop-shell/suer.service /etc/systemd/system/user.service  &>> $LOGFILE
  VALIDATE $? "Copying user service file"

 systemctl daemon-reload &>> $LOGFILE
 VALIDATE $? "Demon Loading"

 systemctl enable user &>> $LOGFILE
 VALIDATE $? "Enabling user"

 systemctl start user &>> $LOGFILE
 VALIDATE $? "Start user"

 cp /home/centos/roboshop-shell/mango.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE 
 VALIDATE $? "Copying mongodb repo"

 dnf install mongodb-org-shell -y 
 VALIDATE $? "Installing MongoDB client"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js &>> $LOGFILE 
VALIDATE $? "Loading user data into MongoDB"
