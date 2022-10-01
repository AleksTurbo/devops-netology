# Домашнее задание к занятию "6.4. PgSQL"

## Задача 1

Используя docker поднимаем инстанс PostgreSQL (версию 13):

Используем docker-compose.yml:

```yuml
version: '3.8'

volumes:
  db:
  backup:

services:
  pgdb:
    image: postgres:13
    restart: always
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_DB=pgdata
    volumes:
      - db:/var/lib/postgresql/data
      - backup:/var/lib/postgresql/backup
    ports:
      - ${POSTGRES_PORT:-5432}:5432
```

Запускаем:

```bash
PS D:\netology\63PGSQL> docker-compose up -d
[+] Running 4/4
 - Network 63pgsql_default   Created                                                                           0.9s 
 - Volume "63pgsql_db"       Created                                                                           0.0s 
 - Volume "63pgsql_backup"   Created                                                                           0.0s 
 - Container 63pgsql-pgdb-1  Started                                                                           1.7s 
PS D:\netology\63PGSQL> docker ps  
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                                       NAMES
211c049dbc5f   postgres:13        "docker-entrypoint.s…"   9 seconds ago   Up 6 seconds   0.0.0.0:5432->5432/tcp              63pgsql-pgdb-1
```

Работаем с БД.

- Подключаемся и выводим информацию по базам:

```sql
postgres=# ~psql -h localhost -U postgres -d postgres
postgres-# ~\l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 pgdata    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7753 kB | pg_default |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7901 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
(4 rows)
```

- Информация о подключении:

```sql
postgres-# \conninfo
You are connected to database "postgres" as user "postgres" on host "localhost" (address "127.0.0.1") at port "5432".
```

- Вывод списка и описание содержимого таблиц:

```sql
postgres-# \dtS+
                                        List of relations
   Schema   |          Name           | Type  |  Owner   | Persistence |    Size    | Description
------------+-------------------------+-------+----------+-------------+------------+-------------
 pg_catalog | pg_aggregate            | table | postgres | permanent   | 56 kB      |
 pg_catalog | pg_am                   | table | postgres | permanent   | 40 kB      |
 pg_catalog | pg_amop                 | table | postgres | permanent   | 80 kB      |
 pg_catalog | pg_amproc               | table | postgres | permanent   | 64 kB      |
 pg_catalog | pg_attrdef              | table | postgres | permanent   | 8192 bytes |
 pg_catalog | pg_attribute            | table | postgres | permanent   | 456 kB     |
 ...
 pg_catalog | pg_ts_dict              | table | postgres | permanent   | 48 kB      | 
 pg_catalog | pg_ts_parser            | table | postgres | permanent   | 40 kB      |
 pg_catalog | pg_ts_template          | table | postgres | permanent   | 40 kB      |
 pg_catalog | pg_type                 | table | postgres | permanent   | 120 kB     |
 pg_catalog | pg_user_mapping         | table | postgres | permanent   | 8192 bytes |
(62 rows)

```

- Выход из psql

```sql
postgres-# \q
root@211c049dbc5f:/# 
```

## Задача 2

- Используя psql создаем БД:

```sql
root@211c049dbc5f:/# psql -U postgres
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

- Восстановим бэкап БД:

```sql
PS D:\netology\63PGSQL> copy d:\netology\63PGSQL\test_dump.sql \\wsl$\docker-desktop-data\data\docker\volumes\63pgsql_backup\_data\
PS D:\netology\63PGSQL> docker exec -it 63pgsql-pgdb-1 bash

root@211c049dbc5f:/# ls -la /var/lib/postgresql/backup
total 12
drwxr-xr-x 2 root     root     4096 Sep 29 18:03 .
drwxr-xr-x 1 postgres postgres 4096 Sep 29 17:30 ..
-rw-r--r-- 1 root     root     2082 Apr 14 22:04 test_dump.sql

root@211c049dbc5f:/# psql -U postgres -f /var/lib/postgresql/backup/test_dump.sql  test_database
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

- Анализируем содержимое БД:

```bash
root@211c049dbc5f:/# psql -U postgres
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

- Используем таблицу pg_stats:

```sql
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)
```

## Задача 3

- Разбиваем таблицы на 2 части:
(шардировать на orders_1 - price>499 и orders_2 - price<=499)

```sql
test_database=# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE
test_database=# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
INSERT 0 3
test_database=# INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499;
INSERT 0 5

test_database=# \dt
          List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+----------
 public | orders   | table | postgres
 public | orders_1 | table | postgres
 public | orders_2 | table | postgres
(3 rows)

```

- Шардирование на этапе создания таблиц:

```sql
CREATE RULE orders_more499 AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
CREATE RULE orders_less499 AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
```

## Задача 4

- Бэкап БД:

```bash
root@211c049dbc5f:/# export PGPASSWORD=password && pg_dump -h localhost -U postgres test_database > /var/lib/postgresql/backup/test_database_backup_29.04.2022.sql
root@211c049dbc5f:/# ls -la /var/lib/postgresql/backup
total 16
drwxr-xr-x 2 root     root     4096 Sep 29 19:05 .
drwxr-xr-x 1 postgres postgres 4096 Sep 29 17:30 ..
-rw-r--r-- 1 root     root     3536 Sep 29 19:05 test_database_backup_29.04.2022.sql
-rw-r--r-- 1 root     root     2082 Apr 14 22:04 test_dump.sql
```

- Установка уникальность значения столбца title для таблиц test_database:

```bash
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,        ##<< UNIQUE - 29 stroka in test_database_backup_29.04.2022.sql
    price integer DEFAULT 0
)
```
