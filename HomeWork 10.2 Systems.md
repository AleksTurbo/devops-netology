# Домашнее задание к занятию "10.2 (13) Системы мониторинга"

## 5. Плюсы и минусы pull и push систем мониторинга:

### Push

- Плюсы:
  - Можно получать данные при нестабильном канале связи или периодической доступности объекта мониторинга.
  - Можно отправлять данные с объекта мониторинга на несколько систем мониторинга.
  - Отдельная или независимая настройка конфигурации узла каждого объекта мониторинга.
  - Малое время разворачивания объекта мониторинга.

- Минусы:
  - Каждый объект мониторинга настраивается независимо, нет централизованного управления конфигурацией.
  - Вероятность образования очереди сообщений или большего количества идентичных сообщений.
  - Объект мониторинга не имеет обратной связи от системы мониторинга.

### Pull

- Плюсы:
  - Использование обычных WEB протоколов http/https
  - Централизованное управление.
  - Гибкий механизм опроса объекта мониторинга.
  - Имеются механизмы повышения безопасности: шифрование канала сообщений и применение промежуточных прокси-узлов

- Минусы:
  - Высокие требования к ресурсам и надежности самой системы мониторинга.
  - Более высокая утилизация сети - обмен информацией идет более активно и в обе стороны.

## 6. Классификация систем мониторинга:

### - Гибридные (Push/Pull)

  - Prometheus
  - Zabbix
  - VictoriaMetrics

### - Push

  - TICK

### - Pull

  - Nagios

## 7. TICK-стэк

```bash
aleksturbo@AlksTrbNoute:~/netology/sandbox$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                 NAMES
959cde16ab46   chrono_config      "/entrypoint.sh chro…"   About a minute ago   Up About a minute   0.0.0.0:8888->8888/tcp                                        sandbox-chronograf-1
733ce42911d7   telegraf  "/entrypoint.sh tele…"   About a minute ago   Up About a minute   8092/udp, 8125/udp, 8094/tcp                                           sandbox-telegraf-1
541bc56b81be   kapacitor  "/entrypoint.sh kapa…"   About a minute ago   Up About a minute   0.0.0.0:9092->9092/tcp                                                sandbox-kapacitor-1
c11025c58b6b   influxdb  "/entrypoint.sh infl…"   About a minute ago   Up About a minute   0.0.0.0:8082->8082/tcp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:8089->8089/udp   sandbox-influxdb-1
3828724a463d   sandbox-documentation  "/documentation/docu…"   About a minute ago   Up About a minute   0.0.0.0:3010->3000/tcp                                    sandbox-documentation-1
```

telegraf 
kapacitor http://kapacitor:9092  curl http://localhost:9092/kapacitor/v1/ping
influxdb http://influxdb:8086      curl http://localhost:8086/ping
Chronograf - http://localhost:8888/    curl http://localhost:8888

```bash
aleksturbo@AlksTrbNoute:~/netology/sandbox$ curl http://localhost:9092/kapacitor/v1/ping
aleksturbo@AlksTrbNoute:~/netology/sandbox$ curl http://localhost:8086/ping
aleksturbo@AlksTrbNoute:~/netology/sandbox$ curl http://localhost:8888
<!DOCTYPE html><html><head><link rel="stylesheet" href="/index.c708214f.css">
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>Chronograf</title><link rel="icon shortcut" href="/favicon.70d63073.ico"></head>
<body> <div id="react-root" data-basepath=""></div> <script type="module" src="/index.e81b88ee.js"></script>
<script src="/index.a6955a67.js" nomodule="" defer></script> </body></html>
```

Chronograf - DASHBOARD
<img src="img/HW 10.2 Chronograf.png"/>

## 8. Chronograf WEB-GUI - MEM & DISK metrics

```bash
aleksturbo@AlksTrbNoute:~/netology/sandbox/telegraf$ cat telegraf.conf
[agent]
  interval = "5s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
.....

[[inputs.cpu]]
[[inputs.disk]]
[[inputs.mem]]
[[inputs.system]]
.....

```

- MEM:

<img src="img/HW 10.2 Chronograf MEM.png"/>

- DISK:

<img src="img/HW 10.2 Chronograf DISK.png"/>

## 9. Chronograf WEB-GUI -  docker metrics:

<img src="img/HW 10.2 ChronografDocker.png"/>
