# Домашнее задание к занятию "10.3 (14) Средство визуализации Grafana"

### 1. Cвязка prometheus-grafana:

Docker:

```bash
aleksturbo@AlksTrbNoute:~/netology/grafana$ docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED        STATUS          PORTS                    NAMES
f609477733fe   grafana/grafana:7.4.0           "/run.sh"                2 days ago     Up 25 minutes   0.0.0.0:3000->3000/tcp   grafana
8bf3e39caa46   prom/prometheus:v2.24.1         "/bin/prometheus --c…"   2 days ago     Up 25 minutes   0.0.0.0:9090->9090/tcp   prometheus
96d2d4b5b8ca   prom/node-exporter:v1.0.1       "/bin/node_exporter …"   2 days ago     Up 25 minutes   0.0.0.0:9100->9100/tcp   nodeexporter
```


Grafana - DATA Source

<img src="img/HW 10.4 GrafanaDATASource.png"/>

### 2. DIY DashBoard:

- Утилизация CPU для nodeexporter (в процентах, 100-idle):

```promql
 100 - (avg by (instance) (rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[1m])) * 100)
```

- CPULA 1/5/15

```promql
 node_load1
 node_load5
 node_load15
```

- Количество свободной оперативной памяти

```promql
node_memory_MemFree_bytes / (1024 * 1024)
```

- Количество места на файловой системе

```promql
node_filesystem_avail_bytes {fstype=~"ext4|xfs"}
```

DashBoard:

<img src="img/HW 10.4 Grafana DIY DashBoard.png"/>

### 3. ALERTING:

Нагружаем систему:

```bash
aleksturbo@AlksTrbNoute:~/netology/grafana$ stress --cpu 4 --vm 10 --hdd 1 --timeout 60
stress: info: [17737] dispatching hogs: 4 cpu, 0 io, 10 vm, 1 hdd
stress: info: [17737] successful run completed in 61s
```

DashBoard with ALERT:

<img src="img/HW 10.4 Grafana DIY Alerting.png"/>

### 4. ALERTING Export:

[NetologyDashBoard.json](grafana/NetologyDashBoard.json)