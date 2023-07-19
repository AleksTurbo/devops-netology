# Домашнее задание к занятию "15.2 Вычислительные мощности. Балансировщики нагрузки"

## Задание 1 - Yandex Cloud

### 1. Создать бакет Object Storage и разместить в нём файл с картинкой:

- Подготовим бакет "pustovit-netology-bucket"
[bucket.tf](/clopro/trfrm2/bucket.tf)

<img src="img/HW 15.2 YC buket.png"/>
-

- Разместим в бакет файл с картинкой. Предоставим файлу доступ из интернета.
[upload.tf](/clopro/trfrm2/upload.tf)

```yaml
  acl        = "public-read"
```

<img src="img/HW 15.2 YC S3 img.png"/>

### 2. Создадим группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

- Создадим Instance Group с тремя ВМ и шаблоном LAMP. Используем image_id = fd827b91d99psvq5fjit
[instance-group.tf](/clopro/trfrm2/instance-group.tf)
[network.tf](/clopro/trfrm2/network.tf)
[variables.tf](/clopro/trfrm2/variables.tf)
[outputs.tf](/clopro/trfrm2/outputs.tf)
-

<img src="img/HW 15.2 YC inct-grp.png"/>
-
<img src="img/HW 15.2 YC vm.png"/>

- Для создания стартовой веб-страницы используем раздел user_data в meta_data. Разместим в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.:

```tf
metadata = {
            ssh-keys   = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
            user-data  = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><head><title>Netology Test YC site</title></head> <body><h1>Netology Test YC PAGE </h1><img src="http://${yandex_storage_bucket.netology-test-bucket.bucket_domain_name}/AlksTrbLogo0.jpg"/></body></html>' > index.html
service httpd start
EOF
      }
```

- Настроим проверку состояния ВМ:

```tf
health_check {
        http_options {
            port    = 80
            path    = "/"
        }
    }

```

### 3. Подключим группу к сетевому балансировщику:

- [lb.tf](/clopro/trfrm2/lb.tf)

<img src="img/HW 15.2 YC nlb.png"/>

- Проверка восстановление группы

```log
19.07.2023, в 11:44:23	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 19s OPENING_TRAFFIC -> RUNNING_ACTUAL
19.07.2023, в 11:44:03	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 43s CHECKING_HEALTH -> OPENING_TRAFFIC
19.07.2023, в 11:44:03	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal is healthy
19.07.2023, в 11:43:42	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal is unhealthy: failed http :80 /
19.07.2023, в 11:43:20	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 3s AWAITING_STARTUP_DURATION -> CHECKING_HEALTH
19.07.2023, в 11:43:17	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 1m CREATING_INSTANCE -> AWAITING_STARTUP_DURATION
19.07.2023, в 11:42:13	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 0s DELETED -> CREATING_INSTANCE
19.07.2023, в 11:42:13	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 0s STARTING_INSTANCE -> DELETED
19.07.2023, в 11:42:12	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 0s STOPPED -> STARTING_INSTANCE
19.07.2023, в 11:42:12	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 4m STOPPING_INSTANCE -> STOPPED
19.07.2023, в 11:37:21	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 13s CLOSING_TRAFFIC -> STOPPING_INSTANCE
19.07.2023, в 11:37:07	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal 14h RUNNING_ACTUAL -> CLOSING_TRAFFIC
19.07.2023, в 11:37:06	cl1non24ri7r9mnbrbpo-uhop.ru-central1.internal is unhealthy: failed http :80 /
```

- демонстрация работы:

<img src="img/HW 15.2 YC nlb site.png"/>

### 4. Создадим Application Load Balancer с использованием Instance group и проверкой состояния:

- [alb_target_group.tf](/clopro/trfrm2/alb_target_group.tf)

```bash
[root@oracle clopro2]# yc alb target-group list
+----------------------+------------------+--------------+
|          ID          |       NAME       | TARGET COUNT |
+----------------------+------------------+--------------+
| ds7upkqdrr4opd3i7l72 | alb-target-group |            3 |
+----------------------+------------------+--------------+
```

<img src="img/HW 15.2 YC alb target-group.png"/>

- [alb_backend_group.tf](/clopro/trfrm2/alb_backend_group.tf)

```bash
[root@oracle clopro2]# yc alb backend-group list
+----------------------+-------------+---------------------+--------------+---------------+----------------------------+
|          ID          |    NAME     |       CREATED       | BACKEND TYPE | BACKEND COUNT |          AFFINITY          |
+----------------------+-------------+---------------------+--------------+---------------+----------------------------+
| ds7ara226fdbcq73mm2m | grp-backend | 2023-07-18 19:40:02 | HTTP         |             1 | connection(source_ip=true) |
+----------------------+-------------+---------------------+--------------+---------------+----------------------------+
```

<img src="img/HW 15.2 YC alb backend-group.png"/>

- [alb_http_router.tf](/clopro/trfrm2/alb_http_router.tf)

```bash
[root@oracle clopro2]# yc alb http-router list
+----------------------+--------+-------------+-------------+
|          ID          |  NAME  | VHOST COUNT | ROUTE COUNT |
+----------------------+--------+-------------+-------------+
| ds70r3tprc1575ros6h8 | router |           1 |           1 |
+----------------------+--------+-------------+-------------+
```

<img src="img/HW 15.2 YC alb backend-group.png"/>

- [alb_load_balancer.tf](/clopro/trfrm2/alb_load_balancer.tf)

```bash
[root@oracle clopro2]# yc alb load-balancer list
+----------------------+-------------------+-----------+----------------+--------+
|          ID          |       NAME        | REGION ID | LISTENER COUNT | STATUS |
+----------------------+-------------------+-----------+----------------+--------+
| ds7829ej1n9ti70orojs | alb-load-balancer |           |              1 | ACTIVE |
+----------------------+-------------------+-----------+----------------+--------+
```

-
<img src="img/HW 15.2 YC alb.png"/>

-
<img src="img/HW 15.2 YC map-balance.png"/>

- настройка проверки состояния:

```bash
healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
```

<img src="img/HW 15.2 YC alb health.png"/>

- Демонстрация работоспособности:

<img src="img/HW 15.2 YC alb site.png"/>

- [terraform manifest's](/clopro/trfrm2)