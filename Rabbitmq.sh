source common.sh

roboshop_app_pass=$1

if [ -z "${roboshop_app_pass}" ]; then
  echo -e "\e[31m Missing  Rabbitma user password assword argument\e[0m"
  exit 1
fi
 print_head "setup Erlag repos"
 curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
 status_check $?

 print_head "setup Rabbitma repos"
 curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
 status_check $?

 print_head "install erlang & rabbitmq"
 yum install rabbitmq-server erlang -y &>>${log_file}
 status_check $?

 print_head "enable rabbitmq server"
 systemctl enable rabbitmq-server &>>${log_file}
 status_check $?

 print_head "start rabbitmq server"
 systemctl start rabbitmq-server &>>${log_file}
 status_check $?

 print_head "add Application user"
 rabbitmqctl list_user | grep roboshop &>>{log_file}
 if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop {roboshop_app_pass} &>>${log_file}
 fi
 status_check $?

 print_head "configuer permession for app user"
 rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
 status_check $?


