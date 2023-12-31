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

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "Disabling current mysql version"

cp mysql.repo /etc/yum.repos.d/mysql.repo
VALIDATE $? "Copied Mysql repo"

dnf install mysql-community-server -y &>> $LOGFILE 
VALIDATE $? "Installing Mysql"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "Enabling Mysql"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "Starting Mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE2
VALIDATE $? "Setting mysql root password"


