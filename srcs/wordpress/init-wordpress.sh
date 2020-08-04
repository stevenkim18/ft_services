sleep 5
mysql --host=mysql --user=user --password=password wordpress < /tmp/wordpress.sql > /dev/null 2>&1
until [ $? != 1 ]
do
	echo "데이터베이스에 wordpress.sql을 넣지 못했습니다. 다시 시도합니다 ...."
	sleep 1
	mysql --host=mysql --user=user --password=password wordpress < /tmp/wordpress.sql > /dev/null 2>&1
done