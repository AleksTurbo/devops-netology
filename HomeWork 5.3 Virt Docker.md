# Домашнее задание к занятию "5.3. Применение Docker"

## Задача 1

- создал репозиторий Docker: <https://hub.docker.com/r/aleksturbo/devops-nginx>
- используем образ nginx:latest

```bash
aleksturbo@ubuntu:~/docker$ docker exec -it web bash
root@8056d93ca805:/# nginx -v
nginx version: nginx/1.23.1
```

- создал на его базе форк и модифицировал index.html, опубликовал в репозитории docker:  

```bash
docker pull aleksturbo/devops-nginx
```

- запускаем и проверяем работоспособность:

```bash
aleksturbo@ubuntu:~/docker$ docker run --rm -d --name web -p 80:80 aleksturbo/devops-nginx:1.1.1
8056d93ca805d7454efdd305ad1addc632788fc9e55cc8e88efa857e821ffe87
aleksturbo@ubuntu:~/docker$ docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                               NAMES
8056d93ca805   aleksturbo/devops-nginx:1.1.1   "/docker-entrypoint.…"   9 seconds ago   Up 8 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   web
aleksturbo@ubuntu:~/docker$ curl http://192.168.153.147/
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

<https://hub.docker.com/r/aleksturbo/devops-nginx>

## Задача 2

Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?
Сценарии:

-Высоконагруженное монолитное java веб-приложение; - Физический сервер или VM лучше - необходим прямой доступ к ресурсам;
-Nodejs веб-приложение - Подойдет Docker, так как это web-приложение с подключаемыми библиотеками;
-Мобильное приложение c версиями для Android и iOS; - Потребуется графический интерфейс - применяем виртуальную машину;
-Шина данных на базе Apache Kafka; - задача требовательна к надежности и задержкам - используем виртуальные машины;
-Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; - для Elasticsearсh лучше VM, отказоустойчивость решается применением кластера, kibana и logstash можно вынести в Docker;
-Мониторинг-стек на базе Prometheus и Grafana; - хорошо подойдет Docker;
-MongoDB, как основное хранилище данных для java-приложения; - Для нагруженных применений - физическая среда, Для средних и небольших - достаточно VM;
-Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. - Подойдет VM для DB и файлового хранилища, Docker для сервисов.

## Задача 3

Используем файловые ресурсы хостовой машины внутри различных dockerов

```bash
aleksturbo@ubuntu:~/docker$ docker run -it --rm -d --name centos -v $(pwd)/data:/data centos:latest
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
f6bd5b5165adc376e88f806bfe404841a17b1251ca64dd87fef07940022504f2

aleksturbo@ubuntu:~/docker$ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
f6bd5b5165ad   centos:latest   "/bin/bash"   10 seconds ago   Up 10 seconds             centos

aleksturbo@ubuntu:~/docker$ docker run -it --rm -d --name debian -v $(pwd)/data:/data debian:latest
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
1671565cc8df: Pull complete
Digest: sha256:d52921d97310d0bd48dab928548ef539d5c88c743165754c57cfad003031386c
Status: Downloaded newer image for debian:latest
ab6534cc62dec4d200c0d0935e4e05b8e9f841f989bc2d0eb04c8f16168bbf77

aleksturbo@ubuntu:~/docker$ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
ab6534cc62de   debian:latest   "bash"        6 seconds ago    Up 5 seconds              debian
f6bd5b5165ad   centos:latest   "/bin/bash"   42 seconds ago   Up 42 seconds             centos

aleksturbo@ubuntu:~/docker$ docker exec -it centos bash
[root@f6bd5b5165ad /]# echo "This file is written to docker CentOS" >> /data/centos.txt
[root@f6bd5b5165ad /]# exit
exit

aleksturbo@ubuntu:~/docker$ echo "This file is written to host" >> data/host.txt
aleksturbo@ubuntu:~/docker$ docker exec -it debian bash
root@ab6534cc62de:/# ls data/
centos.txt  host.txt
```

## Задача 4

```bash
aleksturbo@ubuntu:~/docker4$ docker build -t netology-ansible:1.1.1.1 .
Sending build context to Docker daemon  3.072kB
Step 1/5 : FROM alpine:3.14
3.14: Pulling from library/alpine
c7ed990a2339: Pull complete
Digest: sha256:1ab24b3b99320975cca71716a7475a65d263d0b6b604d9d14ce08f7a3f67595c
Status: Downloaded newer image for alpine:3.14
 ---> dd53f409bf0b
Step 2/5 : RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 &&     apk --no-cache add         sudo         python3        py3-pip         openssl         ca-certificates         sshpass         openssh-client         rsync         git &&     apk --no-cache add --virtual build-dependencies         python3-dev         libffi-dev         musl-dev         gcc         cargo         openssl-dev         libressl-dev         build-base &&     pip install --upgrade pip wheel &&     pip install --upgrade cryptography cffi &&     pip uninstall ansible-base &&     pip install ansible-core &&     pip install ansible==2.10.0 &&     pip install mitogen ansible-lint jmespath &&     pip install --upgrade pywinrm &&     apk del build-dependencies &&     rm -rf /var/cache/apk/* &&     rm -rf /root/.cache/pip &&     rm -rf /root/.cargo
 ---> Running in 70ca429b836d
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86_64/APKINDEX.tar.gz
(1/55) Installing ca-certificates (20220614-r0)
(2/55) Installing brotli-libs (1.0.9-r5)
(3/55) Installing nghttp2-libs (1.43.0-r0)
(4/55) Installing libcurl (7.79.1-r3)
(5/55) Installing expat (2.4.7-r0)
(6/55) Installing pcre2 (10.36-r1)
(7/55) Installing git (2.32.3-r0)
(8/55) Installing openssh-keygen (8.6_p1-r3)
...
 ---> 7d36cf0eeb97
Step 3/5 : RUN mkdir /ansible &&     mkdir -p /etc/ansible &&     echo 'localhost' > /etc/ansible/hosts
 ---> Using cache
 ---> 706659b5f0dc
Step 4/5 : WORKDIR /ansible
 ---> Using cache
 ---> 153c30c481a7
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Using cache
 ---> cfaad1fef269
Successfully built cfaad1fef269
Successfully tagged netology-ansible:1.1.1.1
```

```bash
aleksturbo@ubuntu:~/docker4$ docker run netology-ansible:1.1.1.1
ansible-playbook 2.10.17
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
```

```bash
aleksturbo@ubuntu:~/docker4$ docker tag netology-ansible:1.1.1.1 aleksturbo/netology-ansible:1.1.1.1
aleksturbo@ubuntu:~/docker4$ docker push aleksturbo/netology-ansible:1.1.1.1
The push refers to repository [docker.io/aleksturbo/netology-ansible]
70acf9bf112b: Pushed
788aa742a0ee: Pushed
63493a9ab2d4: Pushed
1.1.1.1: digest: sha256:439435183258f493a8f3d7129b0ee3ecf37db3d17ec0636f88c4ce64c44b112d size: 947
```

<https://hub.docker.com/r/aleksturbo/netology-ansible>
