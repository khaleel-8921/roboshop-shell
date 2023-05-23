source common.sh

print_head "configuring nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
cd /app
print_head "install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "create roboshop User"
useradd roboshop &>>${log_file}


print_head "create Application directory"
mkdir /app &>>${log_file}
status_check $?


print_head "Delete old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Download App content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?


print_head "Extracting the App content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "install the nidejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy systemD service fies"
cp  ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "reload systemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable catalog service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "start catalog service"
systemctl start catalogue

print_head "copy MongoDB repo file"
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install Mongo client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load schema"
mongo --host mongodb.devops999.online </app/schema/catalogue.js &>>${log_file}
status_check $?