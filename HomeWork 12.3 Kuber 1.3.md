# Домашнее задание к занятию "12.3  "Kubernetes 1.2 Запуск приложений в K8S"

## Задание 1 - Deployment и доступ к репликам приложения из другого Pod

1. Deployment из двух контейнеров — nginx и multitool:

[netology-depl.yaml](/kubernetes/netology-depl.yaml)

```bash
root@microk8s:~# kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
multitool          1/1     1            1           43m
nginx-deployment   1/1     1            1           4m22s

root@microk8s:~# kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP    3d23h
nginx-svc      ClusterIP   10.152.183.232   <none>        80/TCP     49m
```

2. Маштабируем реплики:

```yaml
spec:
  replicas: 2
```

3. Проверяем маштабирование

```bash
root@microk8s:~# kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
multitool          1/1     1            1           43m
nginx-deployment   1/1     1            1           4m22s

root@microk8s:~# kubectl apply -f netology-depl.yaml
deployment.apps/nginx-deployment configured
deployment.apps/multitool unchanged
service/nginx-svc unchanged

root@microk8s:~# kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
multitool          1/1     1            1           44m
nginx-deployment   2/2     2            2           5m13s
```

4. Service для обеспечения доступа до реплик приложений из п.1.

- Сервис для nginx - уже имеется в составе "nginx-deployment"
- [multitool-svc](/kubernetes/multitool-svc.yaml)

```bash
root@microk8s:~# kubectl apply -f multitool-svc.yaml
service/multitool-svc created

root@microk8s:~# kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kubernetes      ClusterIP   10.152.183.1     <none>        443/TCP    3d23h
nginx-svc       ClusterIP   10.152.183.232   <none>        80/TCP     61m
multitool-svc   ClusterIP   10.152.183.44    <none>        8080/TCP   4s
```


5. Проверяем доступность PODов из PODов

- [multitool.yaml](/kubernetes/multitool.yaml)

```bash
root@microk8s:~# kubectl get pods -n default -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
multitool-5c8cbc9b6c-s8prs          1/1     Running   0          69m   10.1.128.247   microk8s   <none>           <none>
nginx-deployment-6c685d84f8-72vxz   1/1     Running   0          29m   10.1.128.248   microk8s   <none>           <none>
nginx-deployment-6c685d84f8-wksvj   1/1     Running   0          24m   10.1.128.251   microk8s   <none>           <none>


root@microk8s:~# kubectl exec multitool-5c8cbc9b6c-s8prs -- ping 10.1.128.248
PING 10.1.128.248 (10.1.128.248) 56(84) bytes of data.
64 bytes from 10.1.128.248: icmp_seq=1 ttl=63 time=0.158 ms
64 bytes from 10.1.128.248: icmp_seq=2 ttl=63 time=0.049 ms
64 bytes from 10.1.128.248: icmp_seq=3 ttl=63 time=0.061 ms

root@microk8s:~# kubectl exec multitool-5c8cbc9b6c-s8prs -- ping 10.1.128.251
PING 10.1.128.251 (10.1.128.251) 56(84) bytes of data.
64 bytes from 10.1.128.251: icmp_seq=1 ttl=63 time=0.126 ms
64 bytes from 10.1.128.251: icmp_seq=2 ttl=63 time=0.063 ms
64 bytes from 10.1.128.251: icmp_seq=3 ttl=63 time=0.073 ms


root@microk8s:~# kubectl exec multitool-5c8cbc9b6c-s8prs -- curl 10.1.128.251
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   950k      0 --:--:-- --:--:-- --:--:--  597k
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
<p>If you see this page, the nginx web server is successfully installed and working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

## Задание 2 - Deployment и старт основного контейнера при выполнении условий

1. Deployment приложения nginx со стартом контейнера после запуска сервиса этого приложения:

- [deployment-nginx.yaml](/kubernetes/deployment-nginx.yaml)

```yaml
 initContainers:
      - name: init-nginx
        image: busybox:1.28
        command: ['sh', '-c', "until nslookup nginx.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for init-nginx; sleep 2; done"]
```

2. Ожидание запуска

```bash
root@microk8s:~# kubectl apply -f deployment-nginx.yaml
deployment.apps/nginx created

root@microk8s:~# kubectl get -f deployment-nginx.yaml
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   0/1     1            0           41s

root@microk8s:~# kubectl get pods
NAME                     READY   STATUS     RESTARTS   AGE
nginx-68d4fd8999-hmlk4   0/1     Init:0/1   0          96s
```

3. INIT Service

- [init-nginx-svc.yaml](/kubernetes/init-nginx-svc.yaml)

4. Запуск PODа по наличию сервиса

```bash
root@microk8s:~# kubectl get pods
NAME                     READY   STATUS     RESTARTS   AGE
nginx-5fc697bc8d-68jjf   0/1     Init:0/1   0          14s

root@microk8s:~# kubectl apply -f init-nginx-svc.yaml
service/nginx created

root@microk8s:~# kubectl get svc -o wide
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP   37m   <none>
nginx        ClusterIP   10.152.183.89   <none>        80/TCP    13m   <none>

root@microk8s:~# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-5fc697bc8d-68jjf   1/1     Running   0          77s

```

```bash
root@microk8s:~# kubectl logs nginx-5fc697bc8d-68jjf
Defaulted container "nginx" out of: nginx, init-nginx (init)
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
```
