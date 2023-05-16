# Домашнее задание к занятию "2.4 "Управление доступом"

## Задание 1 - Создайте конфигурацию для подключения пользователя

1. Создадим и подпишим SSL-сертификат для подключения к кластеру:

```bash
root@microk8s:~# mkdir ~/certs && cd ~/certs
root@microk8s:~/certs# openssl genrsa -out a.pustovit.key 2048
root@microk8s:~/certs# openssl req -key a.pustovit.key -new -out a.pustovit.csr -subj "/CN=a.pustovit/O=Netology/OU=StudentsDevOps19"
root@microk8s:~/certs# openssl x509 -req -in a.pustovit.csr -CA /var/snap/microk8s/5219/certs/ca.crt -CAkey /var/snap/microk8s/5219/certs/ca.key -CAcreateserial -out a.pustovit.crt -days 365
Certificate request self-signature ok
subject=CN = a.pustovit, O = Netology, OU = StudentsDevOps19

root@microk8s:~# ls -la /root/certs/
total 20
drwxr-xr-x  2 root root 4096 May 16 17:49 .
drwx------ 12 root root 4096 May 16 17:34 ..
-rw-r--r--  1 root root 1058 May 15 17:02 a.pustovit.crt
-rw-r--r--  1 root root  956 May 15 16:58 a.pustovit.csr
-rw-------  1 root root 1704 May 15 16:52 a.pustovit.key

```

2. Настроим конфигурационный файл kubeconfig для подключения:

- Экспортируем шаблон конфигурации:

```bash
root@microk8s:~# microk8s config > /root/certs/kubeconfig
```

Переносим конфигурацию с сертификаты на другое рабочее место. Вносим изменения для пользователя a.pustovit:

```bash
aleksturbo@AlksTrbNoute:~$ ls -la ~/certs/
total 24
drwxr-xr-x  2 aleksturbo aleksturbo 4096 May 16 20:55 .
drwxr-x--- 33 aleksturbo aleksturbo 4096 May 15 20:09 ..
-rw-r--r--  1 aleksturbo aleksturbo 1058 May 15 20:03 a.pustovit.crt
-rw-r--r--  1 aleksturbo aleksturbo  956 May 15 20:03 a.pustovit.csr
-rw-r--r--  1 aleksturbo aleksturbo 1704 May 15 20:03 a.pustovit.key
-rw-r--r--  1 aleksturbo aleksturbo 1904 May 15 21:51 kubeconfig

aleksturbo@AlksTrbNoute:~$ export KUBECONFIG=$PWD/certs/kubeconfig

aleksturbo@AlksTrbNoute:~$ kubectl config set-credentials a.pustovit --client-certificate=certs/a.pustovit.crt --client-key=certs/a.pustovit.key
User "a.pustovit" set.

aleksturbo@AlksTrbNoute:~$ kubectl config set-context a.pustovit-context --cluster=microk8s-cluster --user=a.pustovit
Context "a.pustovit-context" modified.

aleksturbo@AlksTrbNoute:~$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.153.120:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: a.pustovit
  name: a.pustovit-context
current-context: a.pustovit-context
kind: Config
preferences: {}
users:
- name: a.pustovit
  user:
    client-certificate: a.pustovit.crt
    client-key: a.pustovit.key

aleksturbo@AlksTrbNoute:~$ kubectl config use-context a.pustovit-context
Switched to context "a.pustovit-context".

aleksturbo@AlksTrbNoute:~$ kubectl config current-context
a.pustovit-context

aleksturbo@AlksTrbNoute:~$ kubectl get pods
Error from server (Forbidden): pods is forbidden: User "a.pustovit" cannot list resource "pods" in API group "" in the namespace "default"
```

"По умолчанию" какие либо действия новому пользователю запрещены.

3. Создадим роли и все необходимые настройки для пользователя:

[role.yaml](/kubernetes/role.yaml)

[role-binding.yaml](/kubernetes/role-binding.yaml)

4. Предусмотрим права пользователя. Пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>):

```yaml
rules:
- apiGroups: [""] # “” indicates the core API group
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]
```

- Применяем роли:

```bash
root@microk8s:~# kubectl apply -f role.yaml
role.rbac.authorization.k8s.io/pod-reader created

root@microk8s:~# kubectl apply -f role-binding.yaml
rolebinding.rbac.authorization.k8s.io/read-pods created

root@microk8s:~# kubectl describe role pod-reader
Name:         pod-reader
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods/log   []                 []              [get watch list]
  pods       []                 []              [get watch list]

root@microk8s:~# kubectl describe RoleBinding read-pods
Name:         read-pods
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  pod-reader
Subjects:
  Kind  Name        Namespace
  ----  ----        ---------
  User  a.pustovit

```

- Проверяем результат на машине пользователя:

```bash
aleksturbo@AlksTrbNoute:~$ kubectl get pods
NAME                                READY   STATUS        RESTARTS   AGE
nginx-deployment-86d7bb94cf-g7f9h   1/1     Terminating   0          14d

aleksturbo@AlksTrbNoute:~$ kubectl describe pod nginx-deployment-86d7bb94cf-g7f9h
Name:                      nginx-deployment-86d7bb94cf-g7f9h
Namespace:                 default
Priority:                  0
Service Account:           default
Node:                      mikrok8s/192.168.153.121
Start Time:                Tue, 02 May 2023 20:39:48 +0300
Labels:                    app=nginx
                           pod-template-hash=86d7bb94cf
Annotations:               cni.projectcalico.org/containerID: 89db5dac3f0dd91f44db238d8990847ede98af33858372ba848362185923f3d6
                           cni.projectcalico.org/podIP: 10.1.196.12/32
                           cni.projectcalico.org/podIPs: 10.1.196.12/32
Status:                    Terminating (lasts 26h)
Termination Grace Period:  30s
IP:                        10.1.196.12
IPs:
  IP:           10.1.196.12
Controlled By:  ReplicaSet/nginx-deployment-86d7bb94cf
Containers:
  nginx:
    Container ID:   containerd://0cd61440c35c4bb5f07c625a00adf1733ef984909c4093283f2efa45ea76e6fe
    Image:          nginx:1.22.1
    Image ID:       docker.io/library/nginx@sha256:fc5f5fb7574755c306aaf88456ebfbe0b006420a184d52b923d2f0197108f6b7
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 02 May 2023 20:39:49 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /usr/share/nginx/html/ from nginx-index-file (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dqh45 (ro)
Conditions:
  Type               Status
  Initialized        True
  Ready              False
  ContainersReady    True
  PodScheduled       True
  DisruptionTarget   True
Volumes:
  nginx-index-file:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      nginx-configmap
    Optional:  false
  kube-api-access-dqh45:
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

aleksturbo@AlksTrbNoute:~$ kubectl logs nginx-deployment-86d7bb94cf-g7f9h
Error from server: Get "https://mikrok8s:10250/containerLogs/default/nginx-deployment-86d7bb94cf-g7f9h/nginx": dial tcp: lookup mikrok8s on 127.0.0.53:53: server misbehaving
```

5. Манифесты и скриншоты и/или вывод необходимых команд:

[role.yaml](/kubernetes/role.yaml)
[role-binding.yaml](/kubernetes/role-binding.yaml)
[kubeconfig](/kubernetes/kubeconfig)

<img src="img/HW 12.9 MicroK8S Role ssl.png"/>
-
<img src="img/HW 12.9 MicroK8S Role RBAC.png"/>
-
<img src="img/HW 12.9 MicroK8S Role 1.png"/>
-
