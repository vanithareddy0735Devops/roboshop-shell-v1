#!/bin/bash
user_id=$(id -u)

log_dir="/var/log/shell-logs"
log_file="${log_dir}/${0}.log"

if [ ${user_id} -ne 0 ]; then
    echo "please make this user as psudo user"
    exit 1
fi
mkdir -p ${log_dir}

validate(){
    if [ $1 -ne 0 ]; then
    echo "$timestamp ERROR=======$2 is failed" | tee -a $log_file
    exit 1
else 
    echo "$(timestamp) INFO========$2 is succesfull" | tee -a $log_file
fi
}

timestamp(){
date +"%d %b %Y"
}
echo "$(timestamp) INFO=====before installing the mysql"

dnf module enable mysql:8.4 -y &>> $log_file
dnf install mysql-server -y &>> $log_file
validate $? "mysql installation"

systemctl enable mysqld &>> $log_file
systemctl start mysqld &>> $log_file
validate $? "starting and enabling mysql"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "setting mysql root password"

mysql | tee -a $log_file
validate $? "validating mysql"