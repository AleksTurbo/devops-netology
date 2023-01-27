# Домашнее задание к занятию "10.3 (14) Средство визуализации Grafana"

### 1. Cвязка prometheus-grafana:

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