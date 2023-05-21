# Домашнее задание к занятию "2.5 Helm"

## Задание 1 - Подготовить Helm-чарт для приложения:

1. Подготовим и упакуем приложение в чарт для деплоя в разные окружения:

```bash
root@microk8s:~/helm# tree nginx
nginx
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   └── service.yaml
├── values1.20.yaml
├── values-ltst.yaml
└── values.yaml

1 directory, 8 files

root@microk8s:~/helm# helm package nginx
Successfully packaged chart and saved it to: /root/helm/nginx-app-0.1.1.tgz

```

2. Компоненты приложения деплоится отдельным deployment’ом:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: {{ .Release.Namespace }}
  labels:
    app: nginx-app
```

```bash
root@microk8s:~/helm# helm template -f nginx/values1.20.yaml nginx
---
# Source: nginx-app/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  labels:
    app: nginx-svc
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: nginx-app
---
# Source: nginx-app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: default
  labels:
    app: nginx-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-app
  template:
    metadata:
      labels:
        app: nginx-app
    spec:
      containers:
        - name: nginx-app
          image: "nginx:1.20.2"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            limits:
              cpu: 200m
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 128Mi

```

3. В переменных чарта изменим образ приложения для изменения версии:

```yaml
spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: {{ .Values.appPort }}
              protocol: TCP
```

## Задание 2 - Запустить две версии в разных неймспейсах:

1. Запустим подготовленный чарт:

```bash
root@microk8s:~/helm# helm install nginx-app1 --namespace app1 --create-namespace --wait -f nginx/values1.20.yaml nginx
NAME: nginx-app1
LAST DEPLOYED: Sun May 21 17:36:32 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
NETOLOGY STUDENT`S HOME WORK A.Pustovit DevKub19
Deployed version 1.20.2.
NS: app1

1. Get the application URL running with these commands:
export POD_NAME=$(kubectl get pods --namespace app1 -l "app=nginx-app" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace app1 port-forward $POD_NAME 8080:80
2. Visit http://127.0.0.1:8080 to use your application
or
3. kubectl exec $POD_NAME -n app1 -it -- sh
---------------------------------------------------------

root@microk8s:~/helm# helm list -n app1
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
nginx-app1      app1            1               2023-05-21 17:36:32.002320795 +0000 UTC deployed        nginx-app-0.1.1 1.20.2


root@microk8s:~/helm# kubectl get deployments -n app1 -o wide
NAME        READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES         SELECTOR
nginx-app   1/1     1            1           6m57s   nginx-app    nginx:1.20.2   app=nginx-app


root@microk8s:~/helm# kubectl get pods --namespace app1
NAME                         READY   STATUS    RESTARTS   AGE
nginx-app-68675964c9-hl2l6   1/1     Running   0          7m44s

```

2. Запустим одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2:

- Добавляем еще версию в namespace app1:

```bash

root@microk8s:~/helm# helm upgrade nginx-app1 --namespace app1 --set replicaCount=2 -f nginx/values1.20.yaml nginx
Release "nginx-app1" has been upgraded. Happy Helming!
NAME: nginx-app1
LAST DEPLOYED: Sun May 21 17:45:11 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
NETOLOGY STUDENT`S HOME WORK A.Pustovit DevKub19
Deployed version 1.20.2.
NS: app1

1. Get the application URL running with these commands:
export POD_NAME=$(kubectl get pods --namespace app1 -l "app=nginx-app" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace app1 port-forward $POD_NAME 8080:80
2. Visit http://127.0.0.1:8080 to use your application
or
3. kubectl exec $POD_NAME -n app1 -it -- sh
---------------------------------------------------------
root@microk8s:~/helm# kubectl get pods --namespace app1
NAME                         READY   STATUS    RESTARTS   AGE
nginx-app-68675964c9-hl2l6   1/1     Running   0          8m47s
nginx-app-68675964c9-b6f68   1/1     Running   0          8s

root@microk8s:~/helm# kubectl get pods --namespace app1 -o wide
NAME                         READY   STATUS    RESTARTS   AGE     IP             NODE       NOMINATED NODE   READINESS GATES
nginx-app-68675964c9-hl2l6   1/1     Running   0          12m     10.1.128.236   microk8s   <none>           <none>
nginx-app-68675964c9-b6f68   1/1     Running   0          4m13s   10.1.128.237   microk8s   <none>           <none>


```

- Запускаем другую версию в namespace=app2

```bash
root@microk8s:~/helm# helm install nginx-app2 --namespace app2 --create-namespace --wait -f nginx/values-ltst.yaml nginx
NAME: nginx-app2
LAST DEPLOYED: Sun May 21 17:48:50 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
NETOLOGY STUDENT`S HOME WORK A.Pustovit DevKub19
Deployed version 1.20.2.
NS: app2

1. Get the application URL running with these commands:
export POD_NAME=$(kubectl get pods --namespace app2 -l "app=nginx-app" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace app2 port-forward $POD_NAME 8080:80
2. Visit http://127.0.0.1:8080 to use your application
or
3. kubectl exec $POD_NAME -n app2 -it -- sh
---------------------------------------------------------

root@microk8s:~/helm# kubectl get deployments -n app2 -o wide
NAME        READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES         SELECTOR
nginx-app   1/1     1            1           2m11s   nginx-app    nginx:latest   app=nginx-app


```

3. Демонстрация результата:

```bash
root@microk8s:~/helm# kubectl get pods --all-namespaces
NAMESPACE        NAME                                        READY   STATUS    RESTARTS   AGE
portainer        portainer-agent-657dd786bb-v5zpr            1/1     Running   0          2d22h
ingress          nginx-ingress-microk8s-controller-gpq6f     1/1     Running   0          2d22h
kube-system      coredns-6f5f9b5d74-kgsvx                    1/1     Running   0          2d22h
kube-system      calico-kube-controllers-79568db7f8-dwnfd    1/1     Running   0          2d22h
kube-system      calico-node-6j5xt                           1/1     Running   0          2d22h
kube-system      metrics-server-6f754f88d-2jpf2              1/1     Running   0          2d22h
kube-system      dashboard-metrics-scraper-7bc864c59-d8p5c   1/1     Running   0          2d22h
kube-system      kubernetes-dashboard-dc96f9fc-l8z47         1/1     Running   0          2d22h
kube-system      hostpath-provisioner-69cd9ff5b8-bwr7f       1/1     Running   0          47h
metallb-system   speaker-77f8g                               1/1     Running   0          47h
metallb-system   controller-9556c586f-z84pq                  1/1     Running   0          47h
app1             nginx-app-68675964c9-hl2l6                  1/1     Running   0          15m
app1             nginx-app-68675964c9-b6f68                  1/1     Running   0          6m29s
app2             nginx-app-d7984d9f7-5mprp                   1/1     Running   0          2m50s
```

-

[Chart.yaml](/kubernetes/helm/nginx/Chart.yaml)
[values.yaml](/kubernetes/helm/nginx/values.yaml)
[values1.20.yaml](/kubernetes/helm/nginx/values1.20.yaml)
[values-ltst.yaml](/kubernetes/helm/nginx/values-ltst.yaml)
[nginx-app-0.1.1.tgz](/kubernetes/helm/nginx/nginx-app-0.1.1.tgz)



<img src="img/HW 12.10 MicroK8S helm app 1.png"/>

-

<img src="img/HW 12.10 MicroK8S helm app 2.png"/>
