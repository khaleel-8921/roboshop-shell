source common.sh
mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31m Missing mysql_root_password argument\e[0m"
  exit 1
fi

print_head "disabling mysql version 8"
yum module disable mysql -y &>>${log_file}
status_check $?

print_head "copy mysql repofile"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "installing mysql community server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "enable mysql service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "start mysqlr service"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "set root password"
if [ $? -ne 0 ]; then
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?
