# Домашнее задание к занятию "3.4 Обновление приложений"

## Задание 1 - Выбрать стратегию обновления приложения и описать ваш выбор

### Выберем стратегию обновления приложения:

 Согласно вводным данным ресурсы на расширение ограничены - Запас по ресурсам в менее загруженный момент времени составляет 20%. Значит обновление нужно производить по 1 ноде. Используем стратегию обновления Rolling Update - встроенный функционал kubernetes. Настраиваем параметры "maxSurge=1" и  "maxUnavailable=1" - процесс обновления происходит на 1 ноде из 5 - для контроля задействованных ресурсов. Процесс обновление проводим в периоды наименьшей загрузки всего сервиса. В данном варианте стратегии(Rolling Update) кластер постепенно заменит все поды без прерывания обслуживания. В этом варианте имеется штатный механизм "отката" - возможность возврата версий приложения к предыдущему состоянию.

## Задание 2. Обновление приложения:

### 1. Подготавливаем исходную версию деплоймента: Nginx v1.19.1 + multitool

[netology-depl-1.19.yaml](/kubernetes/upd/netology-depl-1.19.yaml)

```bash
root@kube-master:~# kubectl apply -f netology-depl-1.19.yaml
deployment.apps/netology-deployment created

root@kube-master:~# kubectl get pods -w
NAME                                   READY   STATUS    RESTARTS   AGE
netology-deployment-7867ffbfcd-clrd2   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-clrd2   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-fdb6c   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-sgc5h   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-nl8xh   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-fdb6c   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-w97nj   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-sgc5h   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-clrd2   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-w97nj   0/2     Pending             0          0s
netology-deployment-7867ffbfcd-nl8xh   0/2     Pending             0          0s
netology-deployment-7867ffbfcd-fdb6c   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-sgc5h   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-nl8xh   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-w97nj   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-clrd2   2/2     Running             0          3s
netology-deployment-7867ffbfcd-w97nj   2/2     Running             0          3s
netology-deployment-7867ffbfcd-fdb6c   2/2     Running             0          4s
netology-deployment-7867ffbfcd-sgc5h   2/2     Running             0          4s
netology-deployment-7867ffbfcd-nl8xh   2/2     Running             0          5s

root@kube-master:~# kubectl get pods -o wide
NAME                                   READY   STATUS    RESTARTS   AGE     IP            NODE           NOMINATED NODE   READINESS GATES
netology-deployment-7867ffbfcd-clrd2   2/2     Running   0          2m13s   10.244.3.11   kube-worker3   <none>           <none>
netology-deployment-7867ffbfcd-fdb6c   2/2     Running   0          2m13s   10.244.2.7    kube-worker2   <none>           <none>
netology-deployment-7867ffbfcd-nl8xh   2/2     Running   0          2m13s   10.244.3.12   kube-worker3   <none>           <none>
netology-deployment-7867ffbfcd-sgc5h   2/2     Running   0          2m13s   10.244.1.11   kube-worker1   <none>           <none>
netology-deployment-7867ffbfcd-w97nj   2/2     Running   0          2m13s   10.244.1.10   kube-worker1   <none>           <none>

root@kube-master:~# kubectl get svc
NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                         AGE
combo-svc       ClusterIP   10.110.154.7   <none>        9001/TCP,9002/TCP               19h
ext-combo-svc   NodePort    10.105.22.45   <none>        9001:30080/TCP,9002:30880/TCP   19h
kubernetes      ClusterIP   10.96.0.1      <none>        443/TCP                         19h

root@kube-master:~# curl 10.110.154.7:9001
<html>
<head>
<title>*** TEST NGINX 1.19 ***</title>
</head>
<body>
<h1>*** TEST NGINX 1.19 ***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 3.4</h1>
</body>
</html

```

<img src="img/HW 13 K8S 3.4 nginx 1.19.png"/>

### 2. Изменим версию приложения для проведения процесса обновления:

```yaml
    spec:
      containers:
      - name: nginx
        image: nginx:1.20.2
```

[netology-depl-1.20.yaml](/kubernetes/upd/netology-depl-1.20.yaml)

```bash
root@kube-master:~# kubectl apply -f netology-depl-1.20.yaml
deployment.apps/netology-deployment configured

root@kube-master:~# kubectl get pods -w
NAME                                   READY   STATUS    RESTARTS   AGE
netology-deployment-7867ffbfcd-clrd2   2/2     Running   0          63m
netology-deployment-7867ffbfcd-fdb6c   2/2     Running   0          63m
netology-deployment-7867ffbfcd-nl8xh   2/2     Running   0          63m
netology-deployment-7867ffbfcd-sgc5h   2/2     Running   0          63m
netology-deployment-7867ffbfcd-w97nj   2/2     Running   0          63m
netology-deployment-548958b5b9-4kkh6   0/2     Pending   0          0s
netology-deployment-7867ffbfcd-nl8xh   2/2     Terminating   0          63m
netology-deployment-548958b5b9-4kkh6   0/2     Pending       0          0s
netology-deployment-548958b5b9-4kkh6   0/2     ContainerCreating   0          0s
netology-deployment-548958b5b9-cgbmw   0/2     Pending             0          0s
netology-deployment-548958b5b9-cgbmw   0/2     Pending             0          0s
netology-deployment-548958b5b9-cgbmw   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-nl8xh   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-nl8xh   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-nl8xh   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-nl8xh   0/2     Terminating         0          63m
netology-deployment-548958b5b9-4kkh6   2/2     Running             0          19s
netology-deployment-7867ffbfcd-clrd2   2/2     Terminating         0          63m
netology-deployment-548958b5b9-tsghl   0/2     Pending             0          0s
netology-deployment-548958b5b9-tsghl   0/2     Pending             0          1s
netology-deployment-548958b5b9-tsghl   0/2     ContainerCreating   0          1s
netology-deployment-7867ffbfcd-clrd2   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-clrd2   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-clrd2   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-clrd2   0/2     Terminating         0          63m
netology-deployment-548958b5b9-cgbmw   2/2     Running             0          24s
netology-deployment-7867ffbfcd-sgc5h   2/2     Terminating         0          63m
netology-deployment-548958b5b9-sd7jn   0/2     Pending             0          0s
netology-deployment-548958b5b9-sd7jn   0/2     Pending             0          0s
netology-deployment-548958b5b9-sd7jn   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-sgc5h   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-sgc5h   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-sgc5h   0/2     Terminating         0          63m
netology-deployment-7867ffbfcd-sgc5h   0/2     Terminating         0          63m
netology-deployment-548958b5b9-sd7jn   2/2     Running             0          4s
netology-deployment-7867ffbfcd-fdb6c   2/2     Terminating         0          64m
netology-deployment-548958b5b9-g6bzt   0/2     Pending             0          0s
netology-deployment-548958b5b9-g6bzt   0/2     Pending             0          0s
netology-deployment-548958b5b9-g6bzt   0/2     ContainerCreating   0          0s
netology-deployment-7867ffbfcd-fdb6c   0/2     Terminating         0          64m
netology-deployment-7867ffbfcd-fdb6c   0/2     Terminating         0          64m
netology-deployment-7867ffbfcd-fdb6c   0/2     Terminating         0          64m
netology-deployment-7867ffbfcd-fdb6c   0/2     Terminating         0          64m
netology-deployment-548958b5b9-g6bzt   2/2     Running             0          3s
netology-deployment-7867ffbfcd-w97nj   2/2     Terminating         0          64m
netology-deployment-7867ffbfcd-w97nj   0/2     Terminating         0          64m
netology-deployment-7867ffbfcd-w97nj   0/2     Terminating         0          64m
netology-deployment-7867ffbfcd-w97nj   0/2     Terminating         0          64m
netology-deployment-7867ffbfcd-w97nj   0/2     Terminating         0          64m
netology-deployment-548958b5b9-tsghl   2/2     Running             0          17s

root@kube-master:~# kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
netology-deployment-548958b5b9-4kkh6   2/2     Running   0          2m9s
netology-deployment-548958b5b9-cgbmw   2/2     Running   0          2m9s
netology-deployment-548958b5b9-g6bzt   2/2     Running   0          101s
netology-deployment-548958b5b9-sd7jn   2/2     Running   0          105s
netology-deployment-548958b5b9-tsghl   2/2     Running   0          110s
```

<img src="img/HW 13 K8S 3.4 nginx 1.20.png"/>

### 3. Моделирование неудачного обновления

- подготавливаем манифест:

[netology-depl-1.28.yaml](/kubernetes/upd/netology-depl-1.28.yaml)

```bash
root@kube-master:~# kubectl apply -f netology-depl-1.28.yaml
deployment.apps/netology-deployment configured

root@kube-master:~# kubectl get pods -w
NAME                                   READY   STATUS    RESTARTS   AGE
netology-deployment-548958b5b9-4kkh6   2/2     Running   0          14m
netology-deployment-548958b5b9-cgbmw   2/2     Running   0          14m
netology-deployment-548958b5b9-g6bzt   2/2     Running   0          14m
netology-deployment-548958b5b9-sd7jn   2/2     Running   0          14m
netology-deployment-548958b5b9-tsghl   2/2     Running   0          14m
netology-deployment-858f495bbf-6hs2l   0/2     Pending   0          0s
netology-deployment-858f495bbf-6hs2l   0/2     Pending   0          0s
netology-deployment-548958b5b9-4kkh6   2/2     Terminating   0          14m
netology-deployment-858f495bbf-6hs2l   0/2     ContainerCreating   0          0s
netology-deployment-858f495bbf-twlp2   0/2     Pending             0          0s
netology-deployment-858f495bbf-twlp2   0/2     Pending             0          1s
netology-deployment-858f495bbf-twlp2   0/2     ContainerCreating   0          1s
netology-deployment-548958b5b9-4kkh6   0/2     Terminating         0          14m
netology-deployment-548958b5b9-4kkh6   0/2     Terminating         0          14m
netology-deployment-548958b5b9-4kkh6   0/2     Terminating         0          14m
netology-deployment-548958b5b9-4kkh6   0/2     Terminating         0          14m
netology-deployment-858f495bbf-twlp2   1/2     ErrImagePull        0          4s
netology-deployment-858f495bbf-6hs2l   1/2     ErrImagePull        0          5s
netology-deployment-858f495bbf-twlp2   1/2     ImagePullBackOff    0          5s
netology-deployment-858f495bbf-6hs2l   1/2     ImagePullBackOff    0          6s

root@kube-master:~# kubectl get pods
NAME                                   READY   STATUS         RESTARTS   AGE
netology-deployment-548958b5b9-cgbmw   2/2     Running        0          15m
netology-deployment-548958b5b9-g6bzt   2/2     Running        0          15m
netology-deployment-548958b5b9-sd7jn   2/2     Running        0          15m
netology-deployment-548958b5b9-tsghl   2/2     Running        0          15m
netology-deployment-858f495bbf-6hs2l   1/2     ErrImagePull   0          40s
netology-deployment-858f495bbf-twlp2   1/2     ErrImagePull   0          40s
```

- проверяем доступность приложения

```bash
root@kube-master:~# kubectl get ing
NAME               CLASS   HOSTS   ADDRESS         PORTS   AGE
netology-ingress   nginx   *       192.168.84.50   80      123m

root@kube-master:~# ping kubeer.loc
PING kubeer.loc (192.168.84.50) 56(84) bytes of data.
From kube-worker3 (192.168.84.64) icmp_seq=2 Redirect Host(New nexthop: rrcs-50-84-168-192.sw.biz.rr.com (50.84.168.192))

root@kube-master:~# curl http://kubeer.loc
<html>
<head>
<title>*** TEST NGINX 1.19 ***</title>
</head>
<body>
<h1>*** TEST NGINX 1.19 ***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 3.4</h1>
</body>
</html
```

### 4. Откатываем изменения

- наблюдаем статус обновления:

```bash
root@kube-master:~# kubectl rollout status deployment netology-deployment
error: deployment "netology-deployment" exceeded its progress deadline
```

- производим "откат"

```bash
root@kube-master:~# kubectl rollout undo deployment netology-deployment
deployment.apps/netology-deployment rolled back

root@kube-master:~# kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
netology-deployment-548958b5b9-cgbmw   2/2     Running   0          30m
netology-deployment-548958b5b9-g6bzt   2/2     Running   0          30m
netology-deployment-548958b5b9-hrg4b   2/2     Running   0          14s
netology-deployment-548958b5b9-sd7jn   2/2     Running   0          30m
netology-deployment-548958b5b9-tsghl   2/2     Running   0          30m
```

## Задание 3*. Создать Canary deployment

- подготовим 2 вариант приложения

[netology-depl-new.yaml](/kubernetes/upd/netology-depl-new.yaml)

[netology-cm-1.20.yaml](/kubernetes/upd/netology-cm-1.20.yaml)

[combo-svc-new.yaml](/kubernetes/upd/combo-svc-new.yaml)

- Разворачиваем новое приложение паралельно:

```bash
root@kube-master:~# kubectl apply -f '/root/netology-cm-1.20.yaml'
configmap/nginx-configmap-new created
root@kube-master:~# kubectl apply -f '/root/netology-cm-1.20.yaml'
configmap/nginx-configmap-new configured
root@kube-master:~# kubectl apply -f '/root/netology-depl-new.yaml'
deployment.apps/netology-deployment-new created
root@kube-master:~# kubectl apply -f '/root/combo-svc-new.yaml'
service/combo-svc-new created
root@kube-master:~# kubectl apply -f '/root/ext-combo-svc-new.yaml'
service/ext-combo-svc-new created
```

- Настраиваем ingress (для наглядности устанавливаем % распределения 50%):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: canary-ingress
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "50"
```

```bash
root@kube-master:~# kubectl get svc
NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
canary-service      ClusterIP   10.102.0.217    <none>        9003/TCP,9004/TCP               12m
combo-svc           ClusterIP   10.110.154.7    <none>        9001/TCP,9002/TCP               46h
ext-combo-svc       NodePort    10.105.22.45    <none>        9001:30080/TCP,9002:30880/TCP   46h
ext-combo-svc-new   NodePort    10.96.239.237   <none>        9003:30081/TCP,9004:30881/TCP   25h
kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP                         46h

root@kube-master:~# kubectl get ing
NAME               CLASS   HOSTS   ADDRESS         PORTS   AGE
canary-ingress     nginx   *       192.168.84.50   80      5m10s
netology-ingress   nginx   *       192.168.84.50   80      28h

root@kube-master:~# kubectl describe ing
Name:             canary-ingress
Labels:           <none>
Namespace:        default
Address:          192.168.84.50
Ingress Class:    nginx
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /   canary-service:80 ()
Annotations:  nginx.ingress.kubernetes.io/canary: true
              nginx.ingress.kubernetes.io/canary-weight: 50
Events:
  Type    Reason  Age                    From                      Message
  ----    ------  ----                   ----                      -------
  Normal  Sync    5m26s (x2 over 5m41s)  nginx-ingress-controller  Scheduled for sync


Name:             netology-ingress
Labels:           <none>
Namespace:        default
Address:          192.168.84.50
Ingress Class:    nginx
Default backend:  combo-svc:80 ()
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /               combo-svc:80 ()
              /new(/|$)(.*)   combo-svc-new:80 (<error: endpoints "combo-svc-new" not found>)
Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /$2
              nginx.ingress.kubernetes.io/use-regex: true
Events:       <none>
```

- Проверяем работоспособность 2 версий приложения:

```bash
root@kube-master:~# curl http://kubeer.loc/
<html>
<head>
<title>*** TEST NGINX 1.19 ***</title>
</head>
<body>
<h1>*** TEST NGINX 1.19 ***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 3.4</h1>
</body>
</html
root@kube-master:~# curl http://kubeer.loc/
<html>
<head>
<title>*** TEST NGINX 1.19 ***</title>
</head>
<body>
<h1>*** TEST NGINX 1.19 ***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 3.4</h1>
</body>
</html
root@kube-master:~# curl http://kubeer.loc/
<html>
<head>
<title>*** TEST NGINX 1.20 ***</title>
</head>
<body>
<h1>*** TEST NGINX 1.20 ***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 3.4</h1>
</body>
</html
root@kube-master:~# curl http://kubeer.loc/
<html>
<head>
<title>*** TEST NGINX 1.20 ***</title>
</head>
<body>
<h1>*** TEST NGINX 1.20 ***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 3.4</h1>
</body>
</html

```

- Тестируем - обновляем страницу браузера несколько раз - с вероятностью 50% выводится или версия 1.19 или версия 1.20 приложения

<img src="img/HW 13 K8S 3.4 canary 1.19.png"/>

<img src="img/HW 13 K8S 3.4 canary 1.20.png"/>