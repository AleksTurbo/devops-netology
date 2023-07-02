# Домашнее задание к занятию "3.5 Troubleshooting"

## Задание 1 - При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

### Установим тестовое приложение по команде:

```bash
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml

root@kube-master:~# kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
```
- ошибка - отсутствуют необходимые namespaces "web" и "data"

- исправляем:

```bash
root@kube-master:~# kubectl create namespace web
namespace/web created

root@kube-master:~# kubectl create namespace data
namespace/data created

root@kube-master:~# kubectl get ns
NAME              STATUS   AGE
data              Active   11s
default           Active   35h
ingress-nginx     Active   17h
kube-flannel      Active   35h
kube-node-lease   Active   35h
kube-public       Active   35h
kube-system       Active   35h
metallb-system    Active   17h
portainer         Active   35h
web               Active   13s
```

- пробуем развернуть приложение:

```bash
root@kube-master:~# kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created

root@kube-master:~# kubectl get deployment --all-namespaces
NAMESPACE        NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
data             auth-db                    1/1     1            1           39m
default          netology-deployment        5/5     5            5           17h
default          netology-deployment-new    5/5     5            5           15h
ingress-nginx    ingress-nginx-controller   1/1     1            1           17h
kube-system      coredns                    2/2     2            2           36h
metallb-system   controller                 1/1     1            1           17h
portainer        portainer-agent            1/1     1            1           35h
web              web-consumer               2/2     2            2           39m

root@kube-master:~# kubectl get svc -n data -o wide
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
auth-db   ClusterIP   10.105.248.69   <none>        80/TCP    46m   app=auth-db
```

- установлено успешно

- проверяем работоспособность подов

```
root@kube-master:~# kubectl get po -n data
NAME                       READY   STATUS    RESTARTS   AGE
auth-db-864ff9854c-ssb2g   1/1     Running   0          41m

root@kube-master:~# kubectl get po -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-84fc79d94d-dngjw   1/1     Running   0          41m
web-consumer-84fc79d94d-k2zlv   1/1     Running   0          41m

root@kube-master:~# kubectl logs -n data pod/auth-db-864ff9854c-ssb2g
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up

root@kube-master:~# kubectl logs -n web pod/web-consumer-84fc79d94d-dngjw
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db
```

- наблюдаем ошибку в подах web-consumer

- локализуем проблему:

```bash
root@kube-master:~# kubectl exec -it pod/web-consumer-84fc79d94d-dngjw -n web -- bin/sh

[ root@web-consumer-84fc79d94d-dngjw:/ ]$ nslookup auth-db
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'auth-db'

[ root@web-consumer-84fc79d94d-dngjw:/ ]$ nslookup kubernetes.default
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes.default
Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local

[ root@web-consumer-84fc79d94d-dngjw:/ ]$ curl 10.105.248.69 -I
HTTP/1.1 200 OK
Server: nginx/1.19.1
Date: Sun, 02 Jul 2023 07:21:19 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 07 Jul 2020 15:52:25 GMT
Connection: keep-alive
ETag: "5f049a39-264"
Accept-Ranges: bytes
```

- Диагноз: PODы "web-consumer" не могут разрешить имя PODа "auth-db". Вцелом DNS работает.

- Предполагаемая причина неисправности: приложения работают в разных namespace.

- Проверка предположения:

```bash
root@kube-master:~# kubectl exec -it pod/web-consumer-84fc79d94d-dngjw -n web -- bin/sh

[ root@web-consumer-84fc79d94d-dngjw:/ ]$ nslookup auth-db.data
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      auth-db.data
Address 1: 10.105.248.69 auth-db.data.svc.cluster.local

[ root@web-consumer-84fc79d94d-dngjw:/ ]$ curl auth-db.data -I
HTTP/1.1 200 OK
Server: nginx/1.19.1
Date: Sun, 02 Jul 2023 16:19:33 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 07 Jul 2020 15:52:25 GMT
Connection: keep-alive
ETag: "5f049a39-264"
Accept-Ranges: bytes
```

- Исправление неисправности:

```bash
root@kube-master:~# KUBE_EDITOR=nano kubectl edit deployment/web-consumer -n web
deployment.apps/web-consumer edited
```

- Исправляем в блоке "spec.containers.command" строку "- while true; do curl auth-db.data; sleep 5; done"

```yaml
spec:
      containers:
      - command:
        - sh
        - -c
        - while true; do curl auth-db.data; sleep 5; done
        image: radial/busyboxplus:curl
        imagePullPolicy: IfNotPresent
        name: busybox
```

<img src="img/HW 13 K8S 3.5 fix dplmnt.png"/>

- Проверяем результат:

```bash
root@kube-master:~# kubectl get po -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-5769f9f766-r27cp   1/1     Running   0          14m
web-consumer-5769f9f766-rd2fv   1/1     Running   0          14m

root@kube-master:~# kubectl logs -n web web-consumer-5769f9f766-r27cp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  93922      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

<img src="img/HW 13 K8S 3.5 pod log.png"/>