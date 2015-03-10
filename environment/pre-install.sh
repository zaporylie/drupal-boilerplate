while ! mysql -h${MYSQL_PORT_3306_TCP_ADDR} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD}  -e ";" ; do
  sleep 1s
done
echo "Connected to ${MYSQL_PORT_3306_TCP_ADDR}";

if [ ${METHOD} == 'new' ]; then
  source /root/db-create.sh
fi
