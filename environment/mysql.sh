/usr/bin/mysqld_safe &
sleep 10s
export MYSQL_PASSWORD=`pwgen -c -n -1 12`
echo mysql root password: $MYSQL_PASSWORD
echo $MYSQL_PASSWORD >> '/root/mysql_password.txt'
mysqladmin -u root password $MYSQL_PASSWORD
