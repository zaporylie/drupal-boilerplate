while ! mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD}  -e ";" ; do
  sleep 0.5
done
echo "Connected to ${MYSQL_HOST_NAME}";
