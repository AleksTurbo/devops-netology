# Домашнее задание к занятию "6.2. SQL"

## Задача 1

docker-compose.yml:

```yml
version: '3.8'

volumes:
  db:
  backup:

services:
  pgdb:
    image: postgres:12.6
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
PS D:\netology\62DB> docker-compose up -d   
Starting 62db_pgdb_1 ... done
PS D:\netology\62DB> docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS         PORTS                                                      NAMES
bd9c7cbb2356   postgres:12.6                   "docker-entrypoint.s…"   38 minutes ago   Up 9 seconds   0.0.0.0:5432->5432/tcp                                     62db_pgdb_1
PS D:\netology\62DB> docker exec -it 62db_pgdb_1 bash
root@bd9c7cbb2356:/# psql -V
psql (PostgreSQL) 12.6 (Debian 12.6-1.pgdg100+1)
```

## Задача 2

Работаем с БД:

```bash
root@bd9c7cbb2356:/# psql -h localhost -U postgres -d postgres
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# CREATE USER "test-admin-user";
CREATE ROLE
postgres=# CREATE USER "test-simple-user";
CREATE ROLE
postgres=# \c test_db;
You are now connected to database "test_db" as user "postgres".
test_db=# CREATE TABLE orders (id SERIAL, title CHARACTER, cost INTEGER, PRIMARY KEY (id));
CREATE TABLE
test_db=# CREATE TABLE clients (id SERIAL,family VARCHAR,country VARCHAR,orderid INTEGER, PRIMARY KEY (id),FOREIGN KEY(orderid) REFERENCES orders(id)); 
CREATE TABLE
test_db=# GRANT SELECT, UPDATE, DELETE, INSERT ON TABLE public.clients TO "test-simple-user";
GRANT
test_db=# GRANT ALL ON TABLE public.clients TO "test-admin-user";
GRANT
test_db=# GRANT SELECT, UPDATE, DELETE, INSERT ON TABLE public.orders TO "test-simple-user";
GRANT
test_db=# GRANT ALL ON TABLE public.orders TO "test-admin-user";
GRANT

postgres=# \dt+
                       List of relations
 Schema |  Name   | Type  |  Owner   |    Size    | Description
--------+---------+-------+----------+------------+-------------
 public | clients | table | postgres | 8192 bytes |
 public | orders  | table | postgres | 0 bytes    |
(2 rows)

postgres=# \d+ orders
                                                   Table "public.orders"
 Column |     Type     | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+--------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer      |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character(1) |           |          |                                    | extended |              |
 cost   | integer      |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
Access method: heap

postgres=# \d+ clients
                                                      Table "public.clients"
 Column  |       Type        | Collation | Nullable |               Default               | Storage  | Stats target | Description
---------+-------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id      | integer           |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 family  | character varying |           |          |                                     | extended |              |
 country | character varying |           |          |                                     | extended |              |
 orderid | integer           |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
Access method: heap
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
postgres=# SELECT 
postgres-#     grantee, table_name, privilege_type 
postgres-# FROM 
postgres-#     information_schema.table_privileges
postgres-# WHERE 
postgres-#     grantee in ('test-admin-user','test-simple-user')
postgres-#     and table_name in ('clients','orders')
postgres-# order by 
postgres-#     grantee, table_name;
```

- Вывод

```sql
     grantee      | table_name | privilege_type 
------------------+------------+----------------
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRIGGER
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | SELECT
(22 rows)

postgres=# \dp
                                           Access privileges
 Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies
--------+----------------+----------+------------------------------------+-------------------+----------
 public | clients        | table    | postgres=arwdDxt/postgres         +|                   |
        |                |          | "test-simple-user"=arwd/postgres  +|                   |
        |                |          | "test-admin-user"=arwdDxt/postgres |                   |
 public | clients_id_seq | sequence |                                    |                   |
 public | orders         | table    | postgres=arwdDxt/postgres         +|                   |
        |                |          | "test-simple-user"=arwd/postgres  +|                   |
        |                |          | "test-admin-user"=arwdDxt/postgres |                   |
 public | orders_id_seq  | sequence |                                    |                   |
(4 rows)
```

## Задача 3

Заполняем данные:

```bash
test_db=# INSERT INTO orders (title, cost) VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
INSERT 0 5

test_db=# INSERT INTO clients (family, country) VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
INSERT 0 5

test_db=# SELECT * FROM public.clients ORDER BY id ASC;
 id |        family        | country | orderid 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_db=# SELECT * FROM public.orders ORDER BY id ASC;
 id |        title         | cost 
----+----------------------+------
  1 | Шоколад              |   10
  2 | Принтер              | 3000
  3 | Книга                |  500
  4 | Монитор              | 7000
  5 | Гитара               | 4000
(5 rows)

test_db=# SELECT count(*) FROM clients;
 count 
-------
     5
(1 row)

test_db=# SELECT count(*) FROM orders;
 count 
-------
     5
(1 row)

```

## Задача 4

Связываем данные:

```sql
test_db=# UPDATE clients SET "orderid" = (SELECT id FROM orders WHERE "title"='Книга') WHERE "family"='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET "orderid" = (SELECT id FROM orders WHERE "title"='Монитор') WHERE "family"='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET "orderid" = (SELECT id FROM orders WHERE "title"='Гитара') WHERE "family"='Иоганн Себастьян Бах';
UPDATE 1

test_db=# SELECT * FROM public.clients ORDER BY id ASC;
 id |        family        |       country        | orderid 
----+----------------------+----------------------+---------
  1 | Иванов Иван Иванович | USA                  |       3
  2 | Петров Петр Петрович | Canada               |       4
  3 | Иоганн Себастьян Бах | Japan                |       5
  4 | Ронни Джеймс Дио     | Russia               |
  5 | Ritchie Blackmore    | Russia               |
(5 rows)

test_db=# SELECT c.* FROM clients c JOIN orders o ON c.orderid = o.id;
 id |        family        |       country        | orderid
----+----------------------+----------------------+---------
  1 | Иванов Иван Иванович | USA                  |       3
  2 | Петров Петр Петрович | Canada               |       4
  3 | Иоганн Себастьян Бах | Japan                |       5
(3 rows)

```

## Задача 5

Получаем информацию по выполнению запроса выдачи всех пользователей:

```sql
EXPLAIN analyze verbose lsSELECT c.* FROM clients c JOIN orders o ON c.orderid = o.id;

test_db=# EXPLAIN analyze verbose SELECT c.* FROM clients c JOIN orders o ON c.orderid = o.id;
                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=25.30..40.36 rows=400 width=176) (actual time=0.046..0.051 rows=3 loops=1)
   Output: c.id, c.family, c.country, c.orderid
   Inner Unique: true
   Hash Cond: (c.orderid = o.id)
   ->  Seq Scan on public.clients c  (cost=0.00..14.00 rows=400 width=176) (actual time=0.014..0.016 rows=5 loops=1)
         Output: c.id, c.family, c.country, c.orderid
   ->  Hash  (cost=16.80..16.80 rows=680 width=4) (actual time=0.016..0.017 rows=5 loops=1)
         Output: o.id
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on public.orders o  (cost=0.00..16.80 rows=680 width=4) (actual time=0.006..0.009 rows=5 loops=1)
               Output: o.id
 Planning Time: 0.311 ms
 Execution Time: 0.143 ms
(13 rows)

```

```txt
Разбор "снизу-вверх"
- 10-11 строка - Перебирается таблица orders - 5 строк. 
    cost - затраты процессорного временина поиск первой записи и сбор всей выборки: cost=первая_запись..вся_выборка
    на выходе: список id
- 7 строка - Создается кеш (временная таблица) по полю id для таблицы orders
- 5 строка - Перебирается таблица clients - 5 строк
    на выходе значения столбцов c.id, c.family, c.country, c.orderid
- 4 строка - проверяется соответствие кэша o.id и c.orderid
- 3 строка - получение списка уникальных значений
- 1-2-3 строка - Вывод оставшихся строк со значениями из столбцов c.id, c.family, c.country, c.orderid
```

## Задача 6

BackUp:

```bash
root@bd9c7cbb2356:/# ls -la /var/lib/postgresql/backup
total 8
drwxr-xr-x 2 root     root     4096 Sep 17 11:10 .
drwxr-xr-x 1 postgres postgres 4096 Sep 17 07:13 ..

root@bd9c7cbb2356:/# psql -h localhost -U postgres -d postgres
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# export PGPASSWORD=postgres && pg_dumpall -h localhost -U test-admin-user > /var/lib/postgresql/backup/test_db.sql
postgres-# \q

root@bd9c7cbb2356:/# ls -la /var/lib/postgresql/backup
total 12
drwxr-xr-x 2 root     root     4096 Sep 17 11:12 .
drwxr-xr-x 1 postgres postgres 4096 Sep 17 07:13 ..
-rw-r--r-- 1 root     root      154 Sep 17 11:13 test_db.sql

root@bd9c7cbb2356:/# pg_dump -h localhost -p 5432 -U postgres -C -F p -b -v -f /var/lib/postgresql/backup/test_db.backup test_db
pg_dump: last built-in OID is 16383
pg_dump: reading extensions
pg_dump: identifying extension members
pg_dump: reading schemas
pg_dump: reading user-defined tables
pg_dump: reading user-defined functions
pg_dump: reading user-defined types
pg_dump: reading procedural languages
pg_dump: reading user-defined aggregate functions
pg_dump: reading user-defined operators
pg_dump: reading user-defined access methods
pg_dump: reading user-defined operator classes
pg_dump: reading user-defined operator families
pg_dump: reading user-defined text search parsers
pg_dump: reading user-defined text search templates
pg_dump: reading user-defined text search dictionaries
pg_dump: reading user-defined text search configurations
pg_dump: reading user-defined foreign-data wrappers
pg_dump: reading user-defined foreign servers
pg_dump: reading default privileges
pg_dump: reading user-defined collations
pg_dump: reading user-defined conversions
pg_dump: reading type casts
pg_dump: reading transforms
pg_dump: reading table inheritance information
pg_dump: reading event triggers
pg_dump: finding extension tables
pg_dump: finding inheritance relationships
pg_dump: reading column info for interesting tables
pg_dump: finding the columns and types of table "public.orders"
pg_dump: finding default expressions of table "public.orders"
pg_dump: finding the columns and types of table "public.clients"
pg_dump: finding default expressions of table "public.clients"
pg_dump: flagging inherited columns in subtables
pg_dump: reading indexes
pg_dump: reading indexes for table "public.orders"
pg_dump: reading indexes for table "public.clients"
pg_dump: flagging indexes in partitioned tables
pg_dump: reading extended statistics
pg_dump: reading constraints
pg_dump: reading foreign key constraints for table "public.orders"
pg_dump: reading foreign key constraints for table "public.clients"
pg_dump: reading triggers
pg_dump: reading triggers for table "public.orders"
pg_dump: reading triggers for table "public.clients"
pg_dump: reading rewrite rules
pg_dump: reading policies
pg_dump: reading row security enabled for table "public.orders_id_seq"
pg_dump: reading policies for table "public.orders_id_seq"
pg_dump: reading row security enabled for table "public.orders"
pg_dump: reading policies for table "public.orders"
pg_dump: reading row security enabled for table "public.clients_id_seq"
pg_dump: reading policies for table "public.clients_id_seq"
pg_dump: reading row security enabled for table "public.clients"
pg_dump: reading policies for table "public.clients"
pg_dump: reading publications
pg_dump: reading publication membership
pg_dump: reading subscriptions
pg_dump: reading large objects
pg_dump: reading dependency data
pg_dump: saving encoding = UTF8
pg_dump: saving standard_conforming_strings = on
pg_dump: saving search_path =
pg_dump: saving database definition
pg_dump: creating DATABASE "test_db"
pg_dump: connecting to new database "test_db"
pg_dump: creating TABLE "public.clients"
pg_dump: creating SEQUENCE "public.clients_id_seq"
pg_dump: creating SEQUENCE OWNED BY "public.clients_id_seq"
pg_dump: creating TABLE "public.orders"
pg_dump: creating SEQUENCE "public.orders_id_seq"
pg_dump: creating SEQUENCE OWNED BY "public.orders_id_seq"
pg_dump: creating DEFAULT "public.clients id"
pg_dump: creating DEFAULT "public.orders id"
pg_dump: processing data for table "public.clients"
pg_dump: dumping contents of table "public.clients"
pg_dump: processing data for table "public.orders"
pg_dump: dumping contents of table "public.orders"
pg_dump: executing SEQUENCE SET clients_id_seq
pg_dump: executing SEQUENCE SET orders_id_seq
pg_dump: creating CONSTRAINT "public.clients clients_pkey"
pg_dump: creating CONSTRAINT "public.orders orders_pkey"
pg_dump: creating FK CONSTRAINT "public.clients clients_orderid_fkey"
pg_dump: creating ACL "public.TABLE clients"
pg_dump: creating ACL "public.TABLE orders"

root@bd9c7cbb2356:/# ls -la /var/lib/postgresql/backup
total 20
drwxr-xr-x 2 root     root     4096 Sep 17 11:15 .
drwxr-xr-x 1 postgres postgres 4096 Sep 17 07:13 ..
-rw-r--r-- 1 root     root     5841 Sep 17 11:15 test_db.backup
-rw-r--r-- 1 root     root      154 Sep 17 11:13 test_db.sql

root@bd9c7cbb2356:/# exit
exit
PS D:\netology\62DB> docker compose stop
[+] Running 1/1
 - Container 62db_pgdb_1  Stopped                                                0.8s 
PS D:\netology\62DB> docker ps
CONTAINER ID   IMAGE      COMMAND        CREATED        STATUS        PORTS    NAMES
```

Restore:

```bash
PS D:\netology\62DB2> docker exec -it 62db2-pgdb-1 bash
root@fe0e44583754:/# psql -h localhost -U postgres -d postgres
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# psql -h localhost -U postgres -d postgres
postgres-# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres-# \dp
                            Access privileges
 Schema | Name | Type | Access privileges | Column privileges | Policies
--------+------+------+-------------------+-------------------+----------
(0 rows)

postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 pgdata    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

PS D:\netology\62DB2> docker compose up -d
[+] Running 2/2
 - Container 62db2_pgdb_1  Recreated                                                                                         0.2s 
 - Container 62db2-pgdb-1  Started                                                                                           2.0s 
PS D:\netology\62DB2> docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                               NAMES
fe0e44583754   postgres:12.6                   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:5432->5432/tcp              62db2-pgdb-1

PS D:\netology\62DB2> docker exec -it 62db2-pgdb-1 bash
root@fe0e44583754:/# psql -h localhost -U postgres -d postgres
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# psql -h localhost -U postgres -d postgres
postgres-# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres-# \dp
                            Access privileges
 Schema | Name | Type | Access privileges | Column privileges | Policies
--------+------+------+-------------------+-------------------+----------
(0 rows)

postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 pgdata    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

root@ce8a2782b8dd:/# ls -la /var/lib/postgresql/backup
total 20
drwxr-xr-x 2 root     root     4096 Sep 17 11:27 .
drwxr-xr-x 1 postgres postgres 4096 Sep 17 11:37 ..
-rw-r--r-- 1 root     root     5841 Sep 17 11:15 test_db.backup
-rw-r--r-- 1 root     root      154 Sep 17 11:13 test_db.sql


root@ce8a2782b8dd:/# psql -h localhost -U postgres -d postgres
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# \q
root@ce8a2782b8dd:/# psql -h localhost -p 5432 -U postgres -C -d test_db -f /var/lib/postgresql/backup/test_db.backup
/usr/lib/postgresql/12/bin/psql: invalid option -- 'C'
Try "psql --help" for more information.
root@ce8a2782b8dd:/# psql -h localhost -p 5432 -U postgres -d test_db -f /var/lib/postgresql/backup/test_db.backup
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
.....

SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5

CONTEXT:  COPY orders, line 1
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

root@ce8a2782b8dd:/# psql -h localhost -U postgres -d postgres
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 pgdata    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)

test_db=# SELECT * FROM public.orders ORDER BY id ASC;
 id |        title         | cost 
----+----------------------+------
  1 | Шоколад              |   10
  2 | Принтер              | 3000
  3 | Книга                |  500
  4 | Монитор              | 7000
  5 | Гитара               | 4000
(5 rows)

test_db=# SELECT * FROM public.clients ORDER BY id ASC;
 id |        family        |       country        | orderid 
----+----------------------+----------------------+---------
  1 | Иванов Иван Иванович | USA                  |       3
  2 | Петров Петр Петрович | Canada               |       4
  3 | Иоганн Себастьян Бах | Japan                |       5
  4 | Ронни Джеймс Дио     | Russia               |
  5 | Ritchie Blackmore    | Russia               |
(5 rows)
```
