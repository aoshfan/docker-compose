# ProxySQL
I creted this docker compose i because want to test ProxySQL on Master-Slave MySQL database.  
Below is the list what included in docker-compose.
1. MySQL Master (container name: master)
2. MySQL Slave (container name: slave)
3. ProxySQL (container name: proxysql)
4. Sysbench (container name: sysbench)
5. Configure MySQL (container name: mysqlconfigure ) (Will start configure master slave after 30 seconds, you can change the value in *mysql-configure/configure-master-slave*.)  

### How to use:
1. cd into this folder.
2. docker-compose up -d
3. wait 60 seconds for Master-Slave configuration to start, and you can *docker logs -f <mysqlconfigure-container-id>*. to view the logs process.
4. After 10 seconds the Master-Slave configuration should be finished already.

### How to connect:
1. ProxySQL  
    * mysql -h127.0.0.1 -P16032 -uradmin -pradmin --prompt "ProxySQL Admin>"
2. Other containers
   * docker exec -it <container-name> bash # You can replace bash with any argument. 

Reference:  
  * https://github.com/vbabak/docker-mysql-master-slave
  * https://tarunlalwani.com/post/mysql-master-slave-using-docker/
  * https://github.com/tegansnyder/docker-mysql-master-slave
