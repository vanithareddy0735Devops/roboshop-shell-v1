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
    echo "$2 installation is failed" | tee -a $log_file
    exit 1
else 
    echo "$2 installation is succesfull" | tee -a $log_file
fi
}


cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "adding mongo repo"

dnf install mongodb-org -y &&> $log_file
validate $? "mongo db"

systemctl enable mongod &&> $log_file
systemctl start mongod &&> $log_file
validate $? "enable and start mongodb"


sed -i 's/127.0.0.1/0.0.0.0' /etc/mongod.conf | tee -a $log_file
validate $? "succesfully updated the config file"

systemctl restart mongod | tee -a $log_file
validate $? "restarted the mongo db"