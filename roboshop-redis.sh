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
    echo "$timestamp INFO========$2 is succesfull" | tee -a $log_file
fi
}

timestamp(){
date +"%d %b %Y"
}
echo "$(timestamp) INFO=====befor installing the redis"

dnf module disable redis -y &>> $log_file
dnf module enable redis:7 -y &>> $log_file
dnf install redis -y &>> $log_file
validate $? "Redis installation"

sed -i -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "allowing remote connections to redis"

systemctl enable redis &>> $log_file
systemctl start redis &>> $log_file
validate $? "enabling and starting redis"