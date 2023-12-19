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

dnf install maven -y &>> $LOGFILE
VALIDATE $? "Install Maven"

id roboshop
if [ $? -ne 0 ]
then 
 useradd roboshop
 VALIDATE $? "roboshop user creation"
 else 
 echo -e "roboshop user already exist $Y SKIPPING $N"
 fi 

 curl  -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

 cd /app

 unzip -o /tmp/shipping.zip
 VALIDATE $? "Unziping shipping"
 mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "moving files to shipping"

cp home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE
VALIDATE $? "Copying shipping.service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Demon reloading"

systemctl enable shipping &>> $LOGFILE
VALIDATE $? "Enabling shipping"

systemctl start shipping &>> $LOGFILE
VALIDATE $? "Started Shipping"

dnf install mysql -y &>> $LOGFILE
VALIDATE $? "Installing Mysqlb"

mysql -h mysql.mohana.cloud -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE

systemctl restart shipping &>> $LOGFILE
VALIDATE $? "Restarting Shipping"

