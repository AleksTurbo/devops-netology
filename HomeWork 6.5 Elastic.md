# Домашнее задание к занятию "6.5 Elastic "

## Задача 1

- Подготавливаем и запускаем elasticsearch в докере:

  - Dockerfile-манифест:

  ```yuml
  FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.6
  EXPOSE 9200 9300
  USER 0
  RUN mkdir /var/lib/elasticsearch
  RUN mkdir /var/lib/nodes && chown elasticsearch:elasticsearch -R /var/lib/nodes
  RUN export ES_HOME="/var/lib/elasticsearch" && \
      chown elasticsearch:elasticsearch -R ${ES_HOME}
  COPY --chown=elasticsearch:elasticsearch conf/* /usr/share/elasticsearch/config/
  USER 1000
  ENV ES_HOME="/usr/share/elasticsearch" \
      ES_PATH_CONF="/usr/share/elasticsearch/config"
  WORKDIR ${ES_HOME}
  CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]
  ```
  
  - conf/elasticsearch.yml:

  ```yuml
  path.data: /var/lib
  path.logs: /var/log
  node.name: netology_test
  network.host: 0.0.0.0
  http.port: 9200
  xpack.security.enabled: false
  discovery.type: single-node
  ```

  - Собираем и пушим:

```bash
  PS D:\netology\65elastic> docker build . -t aleksturbo/netology-devops-elasticsearch:7.17.6
  [+] Building 0.6s (11/11) FINISHED
   => [internal] load build definition from Dockerfile                                                                       0.1s
   => => transferring dockerfile: 32B                                                                                        0.0s
   => [internal] load .dockerignore                                                                                          0.0s
   => => transferring context: 2B                                                                                            0.0s
   => [internal] load metadata for docker.elastic.co/elasticsearch/elasticsearch:7.17.6                                       0.0s
   => [1/6] FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.6                                                         0.0s
   => [internal] load build context                                                                                           0.0s
   => => transferring context: 247B                                                                                           0.0s
   => CACHED [2/6] RUN mkdir /var/lib/elasticsearch                                                                           0.0s
   => CACHED [3/6] RUN mkdir /var/lib/nodes && chown elasticsearch:elasticsearch -R /var/lib/nodes                            0.0s
   => CACHED [4/6] RUN export ES_HOME="/var/lib/elasticsearch" &&     chown elasticsearch:elasticsearch -R ${ES_HOME}         0.0s
   => [5/6] COPY --chown=elasticsearch:elasticsearch conf/* /usr/share/elasticsearch/config/                                   0.1s
   => [6/6] WORKDIR /usr/share/elasticsearch                                                                                  0.1s
   => exporting to image                                                                                                      0.2s
   => => exporting layers                                                                                                     0.1s
   => => writing image sha256:df02ae0c38d9e7cf2318b1c476a1dd734d1dcad1212265571087452d76078398                                 0.0s
   => => naming to docker.io/aleksturbo/netology-devops-elasticsearch:7.17.6

  PS D:\netology\65elastic> docker login
  Authenticating with existing credentials...
  Login Succeeded

  PS D:\netology\65elastic> docker push aleksturbo/netology-devops-elasticsearch:7.17.6
  The push refers to repository [docker.io/aleksturbo/netology-devops-elasticsearch]
  5f70bf18a086: Layer already exists
  98c910bf47c3: Pushed
  7e3572ce1b38: Layer already exists
  331dcc4fd2da: Layer already exists
  03afb3082a4d: Layer already exists
  c97233464887: Layer already exists 
  c13324df277a: Layer already exists
  81af5c805f25: Layer already exists
  c886e3877786: Layer already exists
  47f301716812: Layer already exists
  463f9d87a845: Layer already exists
  c937e8a283ad: Layer already exists
  3a02fee6e36b: Layer already exists
  c3f11d77a5de: Layer already exists
  7.17.6: digest: sha256:b1d2dbfd9055d301a56d5ba0dc1f6bcb3b0b92023f8a78cf64944e7096b45cdd size: 3238

```

- Cсылка на образ в репозитории dockerhub:  <https://hub.docker.com/r/aleksturbo/netology-devops-elasticsearch>

- Запускаем и проверяем:

```bash
PS D:\netology\65elastic> docker run --rm -d --name elastic --network 65elastic_es-network -p 9200:9200 -p 9300:9300 aleksturbo/netology-devops-elasticsearch:7.17.6
a268a2924b977bc74c38e2b5befe4d99ee464c6aa9d75066d440e784791ad52e

PS D:\netology\65elastic> docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS          PORTS                                                      NAMES
a268a2924b97   aleksturbo/netology-devops-elasticsearch:7.17.6   "/bin/tini -- /usr/l…"   30 seconds ago   Up 28 seconds   0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp             elastic

user@AlksTrbNoute ~
$ curl -X GET 'localhost:9200/'
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Q8z-nfUhSY-YxF_g3tK-yw",
  "version" : {
    "number" : "7.17.6",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "f65e9d338dc1d07b642e14a27f338990148ee5b6",
    "build_date" : "2022-08-23T11:08:48.893373482Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```

## Задача 2

- Работаем с индексами. Создаем 3 индекса и выводим содержимое:

```bash
user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 1,"number_of_replicas": 0}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}

user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 2,"number_of_replicas": 1}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}

user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 4,"number_of_replicas": 2}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}

user@AlksTrbNoute ~
$ curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases RNyDvFfBRFe1_PBxz30T2g   1   0         40            0     38.3mb         38.3mb
green  open   ind-1            u8tOH8ZvR9WeU8GVIVX_RA   1   0          0            0       226b           226b
yellow open   ind-3            J6gH2BxjQZqHB68eB3RKkQ   4   2          0            0       904b           904b
yellow open   ind-2            SFUarUpIQOuJPTjzXOjHvw   2   1          0            0       452b           452b
```

- Проверяем состояние кластера:

``` bash
user@AlksTrbNoute ~
$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

- Status : "yellow" : Первичный шард и реплика не могут размещаться на одной ноде, если копия не созданы - один узел не может размещать копии сам на себе.

- Удаляем индексы:

```bash
user@AlksTrbNoute ~
$ curl -X DELETE 'http://localhost:9200/_all'
{"acknowledged":true}

user@AlksTrbNoute ~
$ curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases RNyDvFfBRFe1_PBxz30T2g   1   0         40            0     38.3mb         38.3mb
```

## Задача 3

- Работаем с бэкапами:

- Подготавливаем директории:

```bash
PS D:\netology\65elastic> docker exec -u root -it elastic bash
root@a268a2924b97:/usr/share/elasticsearch# mkdir $ES_HOME/snapshots
root@a268a2924b97:/usr/share/elasticsearch# chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots
root@a268a2924b97:/usr/share/elasticsearch# ls -la /usr/share/elasticsearch/snapshots
total 12
drwxr-xr-x 2 elasticsearch elasticsearch 4096 Oct  6 18:27 .
drwxrwxr-x 1 root          root          4096 Oct  6 18:27 ..
root@a268a2924b97:/usr/share/elasticsearch#
```

- модифицируем настройки elasticsearch:

```bash
root@a268a2924b97:/usr/share/elasticsearch# echo path.repo: [ "/usr/share/elasticsearch/snapshots" ] >> "$ES_HOME/config/elasticsearch.yml"

root@a268a2924b97:/usr/share/elasticsearch# cat /usr/share/elasticsearch/config/elasticsearch.yml
path.data: /var/lib
path.logs: /var/log
node.name: netology_test
network.host: 0.0.0.0
http.port: 9200
xpack.security.enabled: false
discovery.type: single-node
path.repo: [ /usr/share/elasticsearch/snapshots ]
```

- Регистрируем расположение snapshot:

```bash
user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'{"type": "fs","settings": {"location": "/usr/share/elasticsearch/snapshots"}}'
{
  "acknowledged" : true
}
```

- Работаем с индексамию Создаем тестовый №1:

```bash
user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'{"settings": {"number_of_shards": 1,"number_of_replicas": 0}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}

user@AlksTrbNoute ~
$ curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases RNyDvFfBRFe1_PBxz30T2g   1   0         40            0     38.3mb         38.3mb
green  open   test             RPWljiMlSgK81XVQYv7GSA   1   0          0            0       226b           226b
```

- Делаем snapshot:

```bash
user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "auSwP5bUQC2nJmnCv8W9DA",
    "repository" : "netology_backup",
    "version_id" : 7170699,
    "version" : "7.17.6",
    "indices" : [
      "test",
      ".ds-.logs-deprecation.elasticsearch-default-2022.10.06-000001",
      ".geoip_databases",
      ".ds-ilm-history-5-2022.10.06-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-10-06T18:41:52.678Z",
    "start_time_in_millis" : 1665081712678,
    "end_time" : "2022-10-06T18:41:54.680Z",
    "end_time_in_millis" : 1665081714680,
    "duration_in_millis" : 2002,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}

root@a268a2924b97:/usr/share/elasticsearch# ls -la /usr/share/elasticsearch/snapshots
total 60
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Oct  6 18:41 .
drwxrwxr-x 1 root          root           4096 Oct  6 18:27 ..
-rw-rw-r-- 1 elasticsearch elasticsearch  1422 Oct  6 18:41 index-0
-rw-rw-r-- 1 elasticsearch elasticsearch     8 Oct  6 18:41 index.latest
drwxrwxr-x 6 elasticsearch elasticsearch  4096 Oct  6 18:41 indices
-rw-rw-r-- 1 elasticsearch elasticsearch 29296 Oct  6 18:41 meta-auSwP5bUQC2nJmnCv8W9DA.dat
-rw-rw-r-- 1 elasticsearch elasticsearch   709 Oct  6 18:41 snap-auSwP5bUQC2nJmnCv8W9DA.dat
```

- Удаляем Индекс №1 и создаем №2:

```bash
user@AlksTrbNoute ~
$ curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}

user@AlksTrbNoute ~
$ curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'{"settings": {"number_of_shards": 1,"number_of_replicas": 0}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

user@AlksTrbNoute ~
$ curl 'localhost:9200/_cat/indices?pretty'
green open .geoip_databases RNyDvFfBRFe1_PBxz30T2g 1 0 40 0 38.3mb 38.3mb
green open test-2           JuDtXCNnQLiWYvbBOSka6w 1 0  0 0   226b   226b

```

- Восстанавливаем данные кластера:

```bash
user@AlksTrbNoute ~
$ curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'{"indices":"*","include_global_state": true}'
{
  "accepted" : true
}

user@AlksTrbNoute ~
$ curl 'localhost:9200/_cat/indices?pretty'
green open test-2           XuiEwT5eQuKEU0d2q6A6Dg 1 0  0 0   226b   226b
green open .geoip_databases aIflsn1cQKyUVPV3ucLQiw 1 0 40 0 38.3mb 38.3mb
green open test             pEXngoYHSDS7wSN1CaoakA 1 0  0 0   226b   226b
```
