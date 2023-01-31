# Домашнее задание к занятию "10.4 (15) Система сбора логов Elastic Stack"

## Задание 1 - Запускаем стек ELK в docker

- Docker:

```bash
[root@oracle elk]# docker ps
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED         STATUS          PORTS                                                                                            NAMES
6c430224c571   docker.elastic.co/elasticsearch/elasticsearch:7.11.0   "/bin/tini -- /usr/l…"   9 minutes ago   Up 9 minutes    0.0.0.0:9200->9200/tcp   es-hot
d03c649f05eb   docker.elastic.co/logstash/logstash:7.3.2              "/usr/local/bin/dock…"   3 hours ago     Up 10 minutes   0.0.0.0:5046->5046/tcp   logstash
d1c624b8b492   docker.elastic.co/beats/filebeat:7.2.0                 "/usr/local/bin/dock…"   4 hours ago     Up 10 minutes                            filebeat
deb5e9180262   docker.elastic.co/kibana/kibana:7.11.0                 "/bin/tini -- /usr/l…"   27 hours ago    Up 10 minutes   0.0.0.0:5601->5601/tcp   kibana
792fe429336e   docker.elastic.co/elasticsearch/elasticsearch:7.11.0   "/bin/tini -- /usr/l…"   3 days ago      Up 10 minutes   9200/tcp, 9300/tcp       es-warm
9e693a098842   python:3.9-alpine                                      "python3 /opt/run.py"    3 days ago      Up 10 minutes                            some_app
```

- Kibana - WEB UI:

<img src="img/HW 10.4 ELK WEB UI.png"/>

- [docker-compose.yml](elk/docker-compose.yml)
- [kibana.yml](elk/kibana.yml)
- [logstash.yml](elk/logstash.yml)
- [logstash.conf](elk/logstash.conf)
- [filebeat.yml](elk/filebeat.yml)

## KIBANA - index-patterns

- Some_App message log:

<img src="img/HW 10.4 ELK some_app message.png"/>
