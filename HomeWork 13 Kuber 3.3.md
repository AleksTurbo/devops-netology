# Домашнее задание к занятию "3.3 работа с сетью в K8s"

## Задание 1 - Создать сетевую политику или несколько политик для обеспечения доступа

1. Создадим deployment'ы приложений frontend, backend и cache и соответсвующие сервисы:

[dplmnt-frontend.yaml](/kubernetes/net-pol/dplmnt-frontend.yaml)

[dplmnt-backend.yaml](/kubernetes/net-pol/dplmnt-backend.yaml)

[dplmnt-cache.yaml](/kubernetes/net-pol/dplmnt-cache.yaml)

2. В качестве образа используем "network-multitool"

```yaml
spec:
      containers:
        - image: praqma/network-multitool
          imagePullPolicy: IfNotPresent
          name: network-multitool
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
```

3. Разместим поды в namespace app:

```bash
root@kube-master:~# kubectl get node -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
kube-master    Ready    control-plane   22h   v1.26.6   192.168.84.79   <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.7.2
kube-worker1   Ready    <none>          22h   v1.26.6   192.168.84.70   <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.7.2
kube-worker2   Ready    <none>          22h   v1.26.6   192.168.84.69   <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.7.2
kube-worker3   Ready    <none>          22h   v1.26.6   192.168.84.68   <none>        Ubuntu 20.04.6 LTS   5.4.0-152-generic   containerd://1.7.2

root@kube-master:~/kubespray# kubectl create namespace app
namespace/app created

root@kube-master:~# kubectl apply -f dplmnt-frontend.yaml
deployment.apps/frontend created
service/frontend created

root@kube-master:~# kubectl apply -f dplmnt-backend.yaml
deployment.apps/backend created
service/backend created

root@kube-master:~# kubectl apply -f dplmnt-cache.yaml
deployment.apps/cache created
service/cache created

root@kube-master:~# kubectl get -n app deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    1/1     1            1           59s
cache      1/1     1            1           53s
frontend   1/1     1            1           71s

root@kube-master:~# kubectl get -n app deployments -o wide
NAME       READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS          IMAGES                     SELECTOR
backend    1/1     1            1           97s    network-multitool   praqma/network-multitool   app=backend
cache      1/1     1            1           91s    network-multitool   praqma/network-multitool   app=cache
frontend   1/1     1            1           109s   network-multitool   praqma/network-multitool   app=frontend

root@kube-master:~# kubectl get -n app svc -o wide
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE     SELECTOR
backend    ClusterIP   10.233.16.88    <none>        80/TCP    2m41s   app=backend
cache      ClusterIP   10.233.5.31     <none>        80/TCP    2m35s   app=cache
frontend   ClusterIP   10.233.42.233   <none>        80/TCP    2m53s   app=frontend

root@kube-master:~# kubectl get -n app pod -o wide
NAME                        READY   STATUS    RESTARTS   AGE     IP              NODE           NOMINATED NODE   READINESS GATES
backend-775456d9d8-5rbqr    1/1     Running   0          3m56s   10.233.84.1     kube-worker1   <none>           <none>
cache-8db8874-lkvq4         1/1     Running   0          3m50s   10.233.97.194   kube-worker2   <none>           <none>
frontend-6c79d98fd4-tqkwr   1/1     Running   0          4m8s    10.233.66.131   kube-worker3   <none>           <none>

```

- на данный момент никакие политики не применены, проверяем взаимную доступность подов:

```bash
root@kube-master:~# kubectl exec backend-775456d9d8-5rbqr -- curl backend:80 -I
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0  1575    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Mon, 26 Jun 2023 15:53:56 GMT
Content-Type: text/html
Content-Length: 1575
Last-Modified: Mon, 26 Jun 2023 15:47:44 GMT
Connection: keep-alive
ETag: "6499b320-627"
Accept-Ranges: bytes

root@kube-master:~# kubectl exec cache-8db8874-lkvq4 -- curl backend:80 -I
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Mon, 26 Jun 2023 16:39:25 GMT
Content-Type: text/html
Content-Length: 1575
Last-Modified: Mon, 26 Jun 2023 15:47:44 GMT
Connection: keep-alive
ETag: "6499b320-627"
Accept-Ranges: bytes

root@kube-master:~# kubectl exec frontend-6c79d98fd4-tqkwr -- curl backend:80 -I
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0  1575    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Mon, 26 Jun 2023 16:40:06 GMT
Content-Type: text/html
Content-Length: 1575
Last-Modified: Mon, 26 Jun 2023 15:47:44 GMT
Connection: keep-alive
ETag: "6499b320-627"
Accept-Ranges: bytes

```

4. Создадим политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены:

- общее запрещающее правило:
[np-default.yaml](/kubernetes\net-pol\np-default.yaml)

- Разрешаем frontend -> backend
[np-backend.yaml](/kubernetes\net-pol\np-backend.yaml)

- Разрешаем backend -> cache
[np-cache.yaml](/kubernetes\net-pol\np-cache.yaml)

5. Демонстрация действия политик:

- применяем запрещающее правило:

```bash
root@kube-master:~# kubectl apply -f np-default.yaml
networkpolicy.networking.k8s.io/deny-ingress created
```

- проверяем запрет:

```bash
root@kube-master:~# kubectl exec cache-8db8874-lkvq4 -- curl backend:80 -I --connect-timeout 30
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:30 --:--:--     0
curl: (28) Connection timeout after 30001 ms
command terminated with exit code 28

root@kube-master:~# kubectl exec frontend-6c79d98fd4-tqkwr -- curl cache:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timeout after 10000 ms
command terminated with exit code 28

root@kube-master:~# kubectl exec backend-775456d9d8-5rbqr -- curl frontend:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timeout after 10000 ms
command terminated with exit code 28
```

- применяем разрешающие правила:

```bash
root@kube-master:~# kubectl apply -f np-backend.yaml
networkpolicy.networking.k8s.io/backend created

root@kube-master:~# kubectl apply -f np-cache.yaml
networkpolicy.networking.k8s.io/cache created

root@kube-master:~# kubectl get networkpolicy -o wide
NAME           POD-SELECTOR   AGE
backend        app=backend    54m
cache          app=cache      53m
deny-ingress   <none>         61m

```

- проверяем разрешенное:

```bash
root@kube-master:~# kubectl exec frontend-6c79d98fd4-tqkwr -- curl backend:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0  1575    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Mon, 26 Jun 2023 17:47:07 GMT
Content-Type: text/html
Content-Length: 1575
Last-Modified: Mon, 26 Jun 2023 15:47:44 GMT
Connection: keep-alive
ETag: "6499b320-627"
Accept-Ranges: bytes

root@kube-master:~# kubectl exec backend-775456d9d8-5rbqr -- curl cache:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0  1572    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Mon, 26 Jun 2023 17:47:39 GMT
Content-Type: text/html
Content-Length: 1572
Last-Modified: Mon, 26 Jun 2023 15:47:52 GMT
Connection: keep-alive
ETag: "6499b328-624"
Accept-Ranges: bytes
```

- контрольно проверяем запрет обратного подключения:

```bash
root@kube-master:~# kubectl exec cache-8db8874-lkvq4 -- curl backend:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timeout after 10000 ms
command terminated with exit code 28

root@kube-master:~# kubectl exec backend-775456d9d8-5rbqr -- curl frontend:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timeout after 10001 ms
command terminated with exit code 28

root@kube-master:~# kubectl exec frontend-6c79d98fd4-tqkwr -- curl cache:80 -I --connect-timeout 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:09 --:--:--     0
curl: (28) Connection timeout after 10000 ms
command terminated with exit code 28
```

-

<img src="img/HW 13 K8S 3.3 netpol 1.png"/>

-

<img src="img/HW 13 K8S 3.3 netpol 2 pods.png"/>

-

<img src="img/HW 13 K8S 3.3 netpol 3 svc.png"/>