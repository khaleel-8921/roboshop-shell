source common.sh

print_head "configuring nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?



print_head "install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "create roboshop User"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
useradd roboshop &>>${log_file}
fi
status_check $?

print_head "create Application directory"
if [ ! -d /app ]; then
mkdir /app &>>${log_file}
fi
status_check $?

print_head "Delete old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Download App content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?
cd /app


print_head "Extracting the App content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "install the nidejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy systemD service fies"
cp  ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "reload systemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable user service"
systemctl enable user &>>${log_file}
status_check $?

print_head "start user service"
systemctl start user

print_head "copy MongoDB repo file"
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install Mongo client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load schema"
mongo --host mongodb.devops999.online </app/schema/user.js &>>${log_file}
status_check $?