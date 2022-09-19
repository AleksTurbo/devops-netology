# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Разворачиваем MySQL 8:

docker-compose.yml:

```yml
version: '3.8'
services:
  db:
    build: mysql:8.0.21
    container_name: mysql
    restart: always
    environment:
      - MYSQL_DATABASE=test_db
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_USER=mysql
      - MYSQL_PASSWORD=mysql
    ports:
      - '3306:3306'
    volumes:
      - db:/var/lib/mysql
volumes:
  db:
    driver: local
```

-Стартуем:

```bash
PS D:\netology\mysql> docker compose up -d
[+] Running 3/3
 - Network mysql_default  Created                                                                                   0.9s 
 - Volume "mysql_db"      Created                                                                                   0.0s 
 - Container mysql        Started                                                                                   2.5s 
PS D:\netology\mysql> docker ps
CONTAINER ID   IMAGE         COMMAND                 CREATED          STATUS         PORTS                                    NAMES
b539f904cfa3   mysql-db   "docker-entrypoint.s…"   11 seconds ago   Up 8 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp          mysql
```

- Подключаемся к базе и проверяем состояние:

```bash
PS D:\netology\mysql> docker exec -it mysql bash
root@99f239cc5411:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.21 MySQL Community Server - GPL

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \h

For information about MySQL products and services, visit:    http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.

For server side help, type 'help contents'

mysql> \s
--------------
mysql  Ver 8.0.21 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          10
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.21 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 3 min 57 sec

Threads: 3  Questions: 36  Slow queries: 0  Opens: 144  Flush tables: 3  Open tables: 65  Queries per second avg: 0.151
--------------
```

- восстанавливаем данные:

```ps
copy d:\netology\mysql\test_dump.sql \\wsl$\docker-desktop-data\data\docker\volumes\mysql_db\_data\backup\
```

```bash
root@99f239cc5411:/# ls -la /var/lib/mysql/backup/
total 12
drwxr-xr-x 2 mysql root  4096 Sep 19 18:04 .
drwxrwxrwt 7 mysql mysql 4096 Sep 19 18:03 ..
-rw-r--r-- 1 mysql root  2073 Apr 14 22:04 test_dump.sql

root@99f239cc5411:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.21 MySQL Community Server - GPL

mysql> CREATE DATABASE test_db;
Query OK, 1 row affected (0.03 sec)
mysql> exit

mysql -u root -p test_db < /var/lib/mysql/backup/test_dump.sql;

```

```sql
root@99f239cc5411:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.21 MySQL Community Server - GPL

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.  

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.02 sec)

mysql> CREATE DATABASE test_db;
Query OK, 1 row affected (0.03 sec)

mysql> exit
Bye
root@99f239cc5411:/# mysql -u root -p test_db < /var/lib/mysql/backup/test_dump.sql;
Enter password: 

root@99f239cc5411:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.21 MySQL Community Server - GPL
Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

mysql> USE test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
Database changed
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.01 sec)

mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

mysql> SELECT * FROM orders WHERE price > '300';
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.01 sec)
```

## Задача 2

-Создаем пользователя:

```sql
mysql> CREATE USER 'test'@'localhost'
    ->     IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->     WITH MAX_CONNECTIONS_PER_HOUR 100
    ->     PASSWORD EXPIRE INTERVAL 180 DAY
    ->     FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ->     ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT SELECT ON test_db.* TO test@localhost;
Query OK, 0 rows affected, 1 warning (0.02 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.01 sec)
```

```sql

```

## Задача 3

- Текущий движок:

```sql
mysql> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.01 sec)
```

- Работаем с профайлером и переконфигурируем "движок":

```sql
mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.10105175 | ALTER TABLE orders ENGINE = MyISAM |
|        2 | 0.07635600 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)
```



## Задача 4

Переконфигурируем MySQL:

- Модифицируем docker-compose.yml:

```yml
version: '3.8'
services:
  db:
    build: .
    container_name: mysql
    command: >
          bash -c "
          chmod 644 /etc/mysql/*.cnf
          && /entrypoint.sh mysqld
          "
    restart: always
    environment:
      - MYSQL_DATABASE=test_db
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_USER=mysql
      - MYSQL_PASSWORD=mysql
    ports:
      - '3306:3306'
    volumes:
      - db:/var/lib/mysql
volumes:
  db:
    driver: local
```

Подготовим дополнительные фаилы:

- Dockerfile:

```yml
FROM mysql:8.0.21
COPY ./cfg/my.cnf /etc/mysql/
```

- my.cnf:
```ini
[mysqld]

pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M
```

Запускаем:

```bash
PS D:\netology\mysql> docker compose up -d
[+] Building 0.4s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                                                        0.0s 
 => => transferring dockerfile: 86B                                                                                         0.0s 
 => [internal] load .dockerignore                                                                                           0.0s 
 => => transferring context: 2B                                                                                             0.0s 
 => [internal] load metadata for docker.io/library/mysql:8.0.21                                                             0.0s 
 => CACHED [1/2] FROM docker.io/library/mysql:8.0.21                                                                        0.0s 
 => [internal] load build context                                                                                            0.0s 
 => => transferring context: 434B                                                                                            0.0s 
 => [2/2] COPY ./cfg/my.cnf /etc/mysql/                                                                                      0.1s 
 => exporting to image                                                                                                        0.1s 
 => => exporting layers                                                                                                       0.1s 
 => => writing image sha256:f8edf64a38887bb402c3d2cb45f69f28aba2110389be4427708df7abd95c922c                                 0.0s 
 => => naming to docker.io/library/mysql-db                                                                                  0.0s 

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
[+] Running 2/2
 - Network mysql_default  Created                                                                                             0.9s 
 - Container mysql        Started                                                                                             3.3s 
PS D:\netology\mysql> docker exec -it mysql bash
root@eeb5256ad65d:/# mysql -u root -p
```

Проверяем настройки:

```ps
PS D:\netology\mysql> docker exec -it mysql bash
root@6b408f87e58f:/# cat /etc/mysql/my.cnf
[mysqld]

pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M
```

```bash
mysql> SHOW VARIABLES WHERE Variable_name IN ('innodb_flush_log_at_trx_commit','innodb_file_per_table','innodb_log_buffer_size','innodb_buffer_pool_size','innodb_log_file_size');
+--------------------------------+------------+
| Variable_name                  | Value      |
+--------------------------------+------------+
| innodb_buffer_pool_size        | 2147483648 |
| innodb_file_per_table          | ON         |
| innodb_flush_log_at_trx_commit | 0          |
| innodb_log_buffer_size         | 1048576    |
| innodb_log_file_size           | 104857600  |
+--------------------------------+------------+
5 rows in set (0.00 sec)
```
