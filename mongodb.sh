cp configs/


yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
127.0.0.1 to 0.0.0.0
systemctl restart mongod