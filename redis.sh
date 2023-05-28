source common.sh

print_head "installing redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "Enable 6.2 redis .repo"
yum module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "install reids "
yum install redis -y  &>>${log_file}
status_check $?

print_head "update redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
status_check $?

print_head "enable redis"
systemctl enable redis &>>${log_file}
status_check $?

print_head "start"
systemctl start redis &>>${log_file}
status_check $?
