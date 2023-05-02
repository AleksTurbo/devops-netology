# Домашнее задание к занятию "12.8  2.3 "Конфигурация приложений"

## Задание 1 - Deployment приложения, состоящего из двух контейнеров и обменивающихся данными через PV ресурс

1. Создадим Deployment приложения, состоящего из контейнеров busybox и multitool:

[netology-depl23.yaml](/kubernetes/netology-depl23.yaml)

2. Решить возникшую проблему с помощью ConfigMap:

[netology-cm23.yaml](/kubernetes/netology-cm23.yaml)

```bash
root@microk8s:~# kubectl apply -f netology-cm23.yaml
configmap/netology-configmap created

root@microk8s:~# kubectl get cm
NAME                 DATA   AGE
kube-root-ca.crt     1      12h
netology-configmap   1      11m


root@microk8s:~# kubectl describe cm netology-configmap
Name:         netology-configmap
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
index.html:
----
<html>
<head>
<title>***TEST MultiTool***</title>
</head>
<body>
<h1>***TEST MultiTool***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 2.3</h1>
</body>
</html

BinaryData
====
Events:  <none>
```

3. Демонстрация работоспособности PODа:

```bash
root@microk8s:~# kubectl get pods -n default -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
mtool-pod-597ccbbc49-m22f6   1/1     Running   0          14m   10.1.128.199   microk8s   <none>           <none>

```

4. Подключим модифицированную index.html к Nginx с помощью ConfigMap. Подключим Service для доступа через curl или браузере.

[mtool-svc-23.yaml](/kubernetes/mtool-svc-23.yaml)

```bash
root@microk8s:~# kubectl apply -f mtool-svc-23.yaml
service/mtool-svc created

root@microk8s:~# kubectl get svc -o wide
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE   SELECTOR
kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP        21d   <none>
mtool-svc    NodePort    10.152.183.27   <none>        80:30880/TCP   21m   app=mtool-pod

root@microk8s:~# kubectl describe svc mtool-svc
Name:                     mtool-svc
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=mtool-pod
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.152.183.27
IPs:                      10.152.183.27
Port:                     web-mtools  80/TCP
TargetPort:               80/TCP
NodePort:                 web-mtools  30880/TCP
Endpoints:                10.1.128.199:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

```

- Подключение ConfigMap:

```yaml
  volumeMounts:
    - name: nginx-index
      mountPath: /usr/share/nginx/html/

  volumes:
  - name: nginx-index
    configMap:
      name: netology-configmap
        
```

5. Используемые манифесты и скриншоты:

[netology-depl23.yaml](/kubernetes/netology-depl23.yaml)
[mtool-svc-23.yaml](/kubernetes/mtool-svc-23.yaml)
[netology-cm23.yaml](/kubernetes/netology-cm23.yaml)

<img src="img/HW 12.8 MicroK8S CM 1.png"/>
-
<img src="img/HW 12.8 MicroK8S CM 2.png"/>

## Задание 2 - Приложение с веб-страницей, доступной по HTTPS

1. Создадим Deployment приложения, состоящего из Nginx:

[deployment-nginx-23.yaml](/kubernetes/deployment-nginx-23.yaml)

```bash
root@mikrok8s:~# kubectl apply -f deployment-nginx-23.yaml
deployment.apps/nginx-deployment created

root@mikrok8s:~# kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           34m

root@mikrok8s:~# kubectl describe deployment nginx-deployment
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Tue, 02 May 2023 17:33:31 +0000
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 3
Selector:               app=nginx
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:        nginx:1.22.1
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:
      /usr/share/nginx/html/ from nginx-index-file (rw)
  Volumes:
   nginx-index-file:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      nginx-configmap
    Optional:  false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-86d7bb94cf (1/1 replicas created)
Events:          <none>
```

2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению:

[netology-cm23.yaml](/kubernetes/netology-cm23.yaml)

```bash
root@mikrok8s:~# kubectl apply -f netology-cm23.yaml
configmap/netology-configmap created

root@mikrok8s:~# kubectl get cm -o wide
NAME               DATA   AGE
kube-root-ca.crt   1      8h
nginx-configmap    1      8m15s

root@mikrok8s:~# kubectl describe cm nginx-configmap
Name:         nginx-configmap
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
index.html:
----
<html>
<head>
<title>***TEST MultiTool***</title>
</head>
<body>
<h1>***TEST MultiTool***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 2.3</h1>
</body>
</html

BinaryData
====
Events:  <none>
-----
```

3. Выпустим самоподписной сертификат SSL. Создать Secret для использования сертификата.

```bash
root@mikrok8s:~# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=microk8s/O=Netology/OU=StudentsDevOps19" -addext "subjectAltName = DNS:microk8s"
......+...+......+.+..+..........+...+........+......+...+...+....+.....+...+...+.......+......+.....+....+..+....+............+...+.....+....+...........+....+...........+....+.....+...+....+.....................+.....+.........+.+...+.....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*....+.+.........+..............+....+...+..+...+....+...+........+....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+...+....+........+.........+...+.+............+........+.+.....+.+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.........+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*...+...+....+..+..........+......+...+..+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.......+.+...+.................+....+.....+....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----

root@mikrok8s:~# kubectl create secret tls nginx-tls --key tls.key --cert tls.crt
secret/nginx-tls created

root@mikrok8s:~# kubectl get secret
NAME        TYPE                DATA   AGE
nginx-tls   kubernetes.io/tls   2      5h57m

root@mikrok8s:~# kubectl get secret
NAME        TYPE                DATA   AGE
nginx-tls   kubernetes.io/tls   2      5h57m

root@mikrok8s:~# kubectl describe secret nginx-tls
Name:         nginx-tls
Namespace:    default
Labels:       io.portainer.kubernetes.configuration.owner=
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1265 bytes
tls.key:  1704 bytes
```

4. Создадим Ingress и необходимый Service, подключим к нему SSL. Продемонстрируем доступ к приложению по HTTPS

[nginx-svc-23.yaml](/kubernetes/nginx-svc-23.yaml)

[ingress-23-https.yaml](/kubernetes/ingress-23-https.yaml)

```bash
root@mikrok8s:~# kubectl apply -f nginx-svc-23.yaml
service/nginx-svc created

root@mikrok8s:~# kubectl apply -f ingress-23-https.yaml
ingress.networking.k8s.io/nginx-ingress-https created

root@mikrok8s:~# kubectl get ingress
NAME                  CLASS    HOSTS      ADDRESS     PORTS     AGE
nginx-ingress-https   public   microk8s   127.0.0.1   80, 443   45s

root@mikrok8s:~# kubectl describe ingress nginx-ingress-https
Name:             nginx-ingress-https
Labels:           <none>
Namespace:        default
Address:          127.0.0.1
Ingress Class:    public
Default backend:  <default>
TLS:
  nginx-tls terminates microk8s
Rules:
  Host        Path  Backends
  ----        ----  --------
  microk8s
              /   nginx-svc:80 (10.1.196.12:80)
Annotations:  <none>
Events:
  Type    Reason  Age                From                      Message
  ----    ------  ----               ----                      -------
  Normal  Sync    36s (x2 over 80s)  nginx-ingress-controller  Scheduled for sync

```

```bash
root@mikrok8s:~# curl -k https://microk8s/
<html>
<head>
<title>***TEST MultiTool***</title>
</head>
<body>
<h1>***TEST MultiTool***</h1>
</br>
<h1>TEST ConfigMap Netology Kuber 2.3</h1>
</body>
</html


root@mikrok8s:~# curl --insecure -vvI https://microk8s 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=microk8s; O=Netology; OU=StudentsDevOps19
*  start date: May  2 12:20:46 2023 GMT
*  expire date: May  1 12:20:46 2024 GMT
*  issuer: CN=microk8s; O=Netology; OU=StudentsDevOps19
*  SSL certificate verify result: self-signed certificate (18), continuing anyway.
* Using HTTP2, server supports multiplexing
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* Using Stream ID: 1 (easy handle 0x561f0126a970)
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* Connection #0 to host microk8s left intact
```

5. Манифесты скриншоты или вывод необходимых команд:

[deployment-nginx-23.yaml](/kubernetes/deployment-nginx-23.yaml)
[netology-cm23.yaml](/kubernetes/netology-cm23.yaml)
[nginx-svc-23.yaml](/kubernetes/nginx-svc-23.yaml)
[ingress-23-https.yaml](/kubernetes/ingress-23-https.yaml)

<img src="img/HW 12.8 MicroK8S CM https 1.png"/>

- 

<img src="img/HW 12.8 MicroK8S CM https 2.png"/>

-

<img src="img/HW 12.8 MicroK8S CM https 3.png"/>