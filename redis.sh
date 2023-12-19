#!/bin/bash
ID=$(id -u)
R="\e[31m" 
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#exec &>$LOGFILE  # this command run background only will run the log file.
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
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE 
VALIDATE $? "Installing remi release"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE 
VALIDATE $? "Enabling redis"

dnf install redis -y &>> $LOGFILE 
VALIDATE $? "Installing Redis"

 sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE 
 VALIDATE $? "Allowing remote connections"

 systemctl enable redis &>> $LOGFILE 
 VALIDATE $? "Enabled redis"

 systemctl start redis &>> $LOGFILE 
 VALIDATE $? "Startin g Redis"



