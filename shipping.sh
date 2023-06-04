source common.sh
mysql_root_pasword=$1

if [ "${mysql_root_password}" == "mysql" ]; then
  echo -e "\e[31m Missing Mysql Root password argument\e[0m"
  exit 1
fi
component=shipping
schema_type="mysql"
java

