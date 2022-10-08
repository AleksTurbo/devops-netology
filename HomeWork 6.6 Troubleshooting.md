# Домашнее задание к занятию "6.6 Troubleshooting "

## Задача 1

- Прерываем продолжительную CRUD операцию в MongoDB:

- ищем длительное соединение и получаем его "opid":

```nongo
db.currentOp({ "active" : true, "secs_running" : { "$gt" : 180 }})

{
  inprog: [
    {
      type: 'op',
      host: '1f772ed8bcc8:27017',
      desc: 'conn17',
      connectionId: 17,
      client: '172.17.0.1:42908',
      appName: 'MongoDB Compass',
...
      currentOpTime: '2022-10-08T14:42:02.504+00:00',
      threaded: true,
      opid: 93882,                                        # <<<=================
      secs_running: Long("9"),
      microsecs_running: Long("9508297"),
      op: 'command',
      ns: 'admin.$cmd',
      command: {
        hello: true,
...,
      flowControlStats: {}
    }
  ],
  ok: 1
}

```

- Прерываем операцию:

```mongo
test> db.killOp(93882)
{ info: 'attempting to kill op', ok: 1 }
```

- Решение проблемм с долгими (зависающими) запросами в MongoDB:

  - Предварительное включение MongoDB Profiler для отлова задержек:
    db.setProfilingLevel(1) – профилировщик собирает данные для операций, которые занимают больше времени, чем значение slowms
    Образец документа, который будет храниться в коллекции system.profile, будет:
    { "was" : 0, "slowms" : 100, "sampleRate" : 1.0, "ok" : 1 }
    Для запроса данных в system.profile collection запустим: db.system.profile.find().pretty()
  - Использование помощника db.currentOp()
    Эта функция выводит список текущих запущенных запросов с очень подробной информацией, например, о том, как долго они выполнялись.
    В запущенной оболочке mongo: db.currenttop({“secs_running”: {$gte: 5}})
  - После определения долгих запросов мы используем помощник explain для этих запросов, чтобы получить более подробную информацию, например, если запрос использует какой-либо индекс.
    Без индексации операции становятся продолжительными, поскольку перед применением изменений необходимо отобрать множество документов.
    Как следствие процессор будет перегружен, что приведет к замедлению запросов и увеличению загрузки процессора.
    Основной ошибкой, которая приводит к медленным запросам, является неэффективное планирование выполнения, которое можно легко устранить, используя индекс с задействованной коллекцией.
  - Использовать maxTimeMS() для установки предела времени выполнения операций.
  - Применять горизонтальное маштабирование, настроить шардинг.

## Задача 2

- Redis latency troobleshooting :
  - Начался рост отношения записанных значений к истекшим
  - Redis блокирует операции записи

```txt
- Возможно наблюдается нехватка памяти. Выходы:
  - Добавить памяти (для виртуальных машин)
  - Удаления данных с истекшим сроком действия: отложенное удаление и периодическое удаление:
  - Настроить redis.conf:
    - timeout - Отключать соединение при неактивности клиента заданное количество секунд.
    - tcp-keepalive - параметр опроса клиента
    - maxmemory - задаёт максимальный размер памяти сервера, который будет доступен Redis-у для хранения данных.
    - maxmemory-policy - Определяет политику, которая будет использовать Redis при достижении maxmemory.
    - unixsocket - использование сокета вместо TCP-порта.
    - maxclients и fs.file-max - Задаёт максимальное количество одновременно подключенных клиентов.
```

## Задача 3

- MySQL ошибки "Lost connection to MySQL server during query u'SELECT.." при использования в гис-системе:

- Вероятные причины:
  - Большие обьемы данных на запись или чтение.
  - Проблемы с каналом связи.
  - Большое число клиентов.

- Пути решения:
  - Увеличить время ожидания соединения из командной строки, используя опцию –connect-timeout
  - Настроить глобальные переменные тайм-аута на сервере базы данных MySQL - "connect_timeout" и "net_read_timeout":

```sql
    SHOW VARIABLES LIKE "%timeout";

    +-----------------------------------+----------+
    | Variable_name                     | Value    |
    +-----------------------------------+----------+
    | connect_timeout                   | 10       |
    | delayed_insert_timeout            | 300      |
    | have_statement_timeout            | YES      |
    | innodb_flush_log_at_timeout       | 1        |
    | innodb_lock_wait_timeout          | 50       |
    | innodb_rollback_on_timeout        | OFF      |
    | interactive_timeout               | 28800    |
    | lock_wait_timeout                 | 31536000 |
    | mysqlx_connect_timeout            | 30       |
    | mysqlx_idle_worker_thread_timeout | 60       |
    | mysqlx_interactive_timeout        | 28800    |
    | mysqlx_port_open_timeout          | 0        |
    | mysqlx_read_timeout               | 30       |
    | mysqlx_wait_timeout               | 28800    |
    | mysqlx_write_timeout              | 60       |
    | net_read_timeout                  | 30       |
    | net_write_timeout                 | 60       |
    | replica_net_timeout               | 60       |
    | rpl_stop_replica_timeout          | 31536000 |
    | rpl_stop_slave_timeout            | 31536000 |
    | slave_net_timeout                 | 60       |
    | wait_timeout                      | 28800    |
    +-----------------------------------+----------+
```

- Настройте переменные тайм-аута в файлах конфигурации MySQL:
      [mysqld]
      connect_timeout = 10
      net_read_timeout = 30
      wait_timeout = 28800
      interactive_timeout = 28800

## Задача 4

- PostgreSQL -  СУБД время от времени становится недоступной и ошибка "postmaster invoked oom-killer":

- Вероятные причины:
  - Postgres испытывает нехватку памяти.
  - OOM Killer - нехватка памяти. Out-Of-Memory Killer — служебный процесс, который завершает приложение, чтобы спасти ядро от сбоя.

- Варианты решения проблемы:
  - Добавить/выделить дополнительной оперативной памяти(RAM)
  - Произвести настройку параметров, определяющих взаимодействие с памятью в Postgres:
    - maintenance_work_mem
    - max_connections
    - shared_buffer
    - work_mem
    - effective_cache_size
    

