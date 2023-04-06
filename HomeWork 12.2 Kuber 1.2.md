# Домашнее задание к занятию "12.2  "Kubernetes 1.2. Базовые объекты K8S"

## Задание 1 - Запуск Pod  hello-world

1. Манифест:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  containers:
  - name: hello-world
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 80
```

2. Запускаем POD echoserver:

```bash
root@microk8s:~# kubectl get pods -n default
No resources found in default namespace.
root@microk8s:~# kubectl apply -f hello-world.yaml
pod/hello-world created
root@microk8s:~# kubectl get pods -n default
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          7s
```

```bash
root@microk8s:~# kubectl describe pod hello-world
Name:             hello-world
Namespace:        default
Priority:         0
Service Account:  default
Node:             microk8s/192.168.153.124
Start Time:       Thu, 06 Apr 2023 16:47:39 +0000
Labels:           <none>
Annotations:      cni.projectcalico.org/containerID: e33b4d54cd1c64a8cca4bec05b112785c35716be8a3ab01562a68b9ecca8c175
                  cni.projectcalico.org/podIP: 10.1.128.242/32
                  cni.projectcalico.org/podIPs: 10.1.128.242/32
Status:           Running
IP:               10.1.128.242
IPs:
  IP:  10.1.128.242
Containers:
  hello-world:
    Container ID:   containerd://336e2934129ea18704edb6ed4aa4d0d9bc43365f81de1820d939fac059ec2ff4
    Image:          gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    Image ID:       gcr.io/kubernetes-e2e-test-images/echoserver@sha256:e9ba514b896cdf559eef8788b66c2c3ee55f3572df617647b4b0d8b6bf81cf19
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 06 Apr 2023 16:47:46 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-75plm (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-75plm:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
```

3. Подключаемся локально к PODу:

```bash
root@microk8s:~# kubectl port-forward hello-world 80:8080
Forwarding from 127.0.0.1:80 -> 8080
Forwarding from [::1]:80 -> 8080
Handling connection for 80
```

```bash
root@microk8s:~# curl localhost

Hostname: hello-world

Pod Information:
        -no pod information available-

Server values:
        server_version=nginx: 1.12.2 - lua: 10010

Request Information:
        client_address=127.0.0.1
        method=GET
        real path=/
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://localhost:8080/

Request Headers:
        accept=*/*
        host=localhost
        user-agent=curl/7.68.0

Request Body:
        -no body in request-
```

## Задание 2 - Создаем Service и подключим его к Pod

1. Pod с именем netology-web:

[netology-web.yaml](/kubernetes/netology-web.yaml)

2. Запускаем POD

```bash
root@microk8s:~# kubectl apply -f netology-web.yaml
pod/netology-web created

```

```bash
root@microk8s:~# kubectl get pods -n default
NAME           READY   STATUS    RESTARTS   AGE
hello-world    1/1     Running   0          11m
netology-web   1/1     Running   0          12s

root@microk8s:~# kubectl get pods -n default -o wide
NAME           READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
hello-world    1/1     Running   0          46m   10.1.128.243   microk8s   <none>           <none>
netology-web   1/1     Running   0          11m   10.1.128.245   microk8s   <none>           <none>

```

3. Создаем Service с именем "netology-svc" и подключим к "netology-web":

[netology-svc.yaml](/kubernetes/netology-svc.yaml)

```bash
root@microk8s:~# kubectl apply -f netology-svc.yaml
service/netology-svc created

root@microk8s:~# kubectl get svc -o wide
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE   SELECTOR
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP    47h   <none>
netology-svc   ClusterIP   10.152.183.211   <none>        8080/TCP   31s   app=netology
```

```bash
root@microk8s:~# kubectl get svc -o wide
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE     SELECTOR
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP    2d      <none>
netology-svc   ClusterIP   10.152.183.143   <none>        8080/TCP   2m17s   app=netology

root@microk8s:~# kubectl get endpoints -o wide
NAME           ENDPOINTS               AGE
kubernetes     192.168.153.124:16443   2d
netology-svc   10.1.128.245:8080         3m7s

root@microk8s:~# kubectl describe endpoints netology-svc
Name:         netology-svc
Namespace:    default
Labels:       <none>
Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2023-04-06T17:45:14Z
Subsets:
  Addresses:          10.1.128.245
  NotReadyAddresses:  <none>
  Ports:
    Name  Port  Protocol
    ----  ----  --------
    web   8080    TCP
Events:  <none>
```

4. Подключимся локально к Service с помощью kubectl port-forward

- port-forward:

```bash
root@microk8s:~# kubectl get endpoints -o wide
NAME           ENDPOINTS               AGE
kubernetes     192.168.153.124:16443   2d
netology-svc   10.1.128.245:8080       5s

root@microk8s:~# kubectl port-forward Service/netology-svc 80:8080
Forwarding from 127.0.0.1:80 -> 8080
Forwarding from [::1]:80 -> 8080
Handling connection for 80
```

- Проверяем работоспособность публикации:

```bash
root@microk8s:~# curl http://localhost

Hostname: netology-web

Pod Information:
        -no pod information available-

Server values:
        server_version=nginx: 1.12.2 - lua: 10010

Request Information:
        client_address=127.0.0.1
        method=GET
        real path=/
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://localhost:8080/

Request Headers:
        accept=*/*
        host=localhost
        user-agent=curl/7.68.0

Request Body:
        -no body in request-
```
