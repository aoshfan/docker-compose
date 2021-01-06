#!/bin/bash

echo "Check Slave Uptime."
UPTIME=$(mysqladmin -h slave -u root status | awk '{print $2}')
if [ "$UPTIME" -gt "60" ]; then
  echo "Slave uptime is ${UPTIME} more than 60 seconds";
  echo "Master-Slave configuration is cancelled now";
  exit 0
fi

echo "SLEEPING 30 seconds before do MySQL Master-Slave configuration"
sleep 30
echo "CREATE USER & GRANT"
mysql -h master -u root -e "CREATE USER 'replication_user'@'%' IDENTIFIED BY 'replication_password'; GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%'; FLUSH PRIVILEGES;"
echo "GETTING BINLOG NAME"
MYSQL_BIN=$(mysql -h master -u root -e "SHOW MASTER STATUS;" | awk '{print $1}' | tail -1)
echo "GETTING BINLOG POST"
MYSQL_POST=$(mysql -h master -u root -e "SHOW MASTER STATUS;" | awk '{print $2}' | tail -1)
echo "CONFIGURE THE SLAVE"
mysql -h slave -u root -e "CHANGE MASTER TO MASTER_HOST='master',MASTER_USER='replication_user', MASTER_PASSWORD='replication_password', MASTER_LOG_FILE='${MYSQL_BIN}', MASTER_LOG_POS=${MYSQL_POST}"
echo "START A SLAVE"
mysql -h slave -u root -e "start slave"
echo "DONE"
