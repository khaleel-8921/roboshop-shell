code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[33m$1\e[0m"
}

status_check(){
  if [ $1 -eq 0 ]; then
     echo success
  else
    echo failure
    echo "read the log file ${log_file} for more info about the error"
    exit 1
  fi
 }

 schema_setup() {

   if [ "${schema_type}" == "mongo" ];then
   print_head "copy MongoDB repo file"
   cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
   status_check $?

   print_head "install Mongo client"
   yum install mongodb-org-shell -y &>>${log_file}
   status_check $?

   print_head "Load schema"
   mongo --host mongodb.devops999.online </app/schema/${component}.js &>>${log_file}
   status_check $?

   elif [ "${schema_type}" == "mysql" ]; then
     print_head "install Mysql Client"
     yum install mysql -y &>>${log_file}
     status_check $?


     print_head "load schema"
     mysql -h mysql.devops999.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
     status_check $?
 }

nodejs() {
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
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting the App content"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "install the nidejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy systemD service fies"
cp  ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "reload systemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable ${component} service"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "start ${component} service"
systemctl start ${component} &>>${log_file}
status_check $?
schema_setup
}

java(){

  print_head "install maven"
  yum install maven -y &>>${log_file}
  status_check $?

  print_head "add user roboshop"
  useradd roboshop
  status_check $?

   app_prereq_setup
  print_head "Downloading dependencies and packages"
  mvn clean package &>>${log_file}
  mv target/${component}-0.1.jar ${component}.jar &>>${log_file}
  status_check $?

  #schema setup Function
  schema_setup
}
