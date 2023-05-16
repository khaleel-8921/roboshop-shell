code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[31m$1\e[0m"
}

print_head "setup mongod repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "install mongodb"
yum install mongodb-org -y

print_head "enable mongodb"
systemctl enable mongod

print_head  "start mongodb service"
systemctl start mongod

# update /etc/mongod.conf file from 127.0.0.1 with  0.0.0.0
