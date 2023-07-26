# Домашнее задание к занятию "15.4 Кластеры. Ресурсы под управлением облачных провайдеров"

## Задание 1 - Yandex Cloud - MySQL

### 1. Настроить с помощью Terraform кластер баз данных MySQL:

- Подготавливаем манифесты:

[mysql_cluster.tf](/clopro/trfrm4/mysql_cluster.tf)

#### предусмотрим следующие особенности:

- резмещение в приватной подсети

```tf
host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-private-30.id
    assign_public_ip = true
  }
```

- репликацию с произвольным временем технического обслуживания:

```tf
maintenance_window {
    type = "WEEKLY"
    day  = "MON"
    hour = 03
  }
```

- Время начала резервного копирования:

```tf
backup_window_start {
    hours   = 23
    minutes = 59
  }
```

- Защита от случайного удаления:

```tf
deletion_protection = true
```

- Создадим БД с именем netology_db, логином и паролем:

```tf
resource "yandex_mdb_mysql_database" "netology-db" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql-cluster.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "dbuser" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql-cluster.id
  name       = "dbuser"
  password   = "********"
  permission {
    database_name = "netology_db"
    roles         = ["ALL"]
  }
```

<img src="img/HW 15.4 YC mysql consol.png"/>

-

<img src="img/HW 15.4 YC mysql menedg srvs.png"/>

-

<img src="img/HW 15.4 YC mysql db table.png"/>

-

<img src="img/HW 15.4 YC mysql db topology.png"/>

### 2. Настроить с помощью Terraform кластер Kubernetes

- добавим дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость

[network.tf](/clopro/trfrm4/network.tf)

- Создадим отдельный сервис-аккаунт с необходимыми правами

```tf
// создание сервисного аккаунта для kubernetes
resource "yandex_iam_service_account" "sa-kube" {
  name = "sa-kube"
  description = "sa-kube"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${var.yandex_folder_id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kube.id}"
  depends_on = [yandex_iam_service_account.sa-kube]
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = "${var.yandex_folder_id}"
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kube.id}"
  depends_on = [yandex_iam_service_account.sa-kube]
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = "${var.yandex_folder_id}"
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kube.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = "${var.yandex_folder_id}"
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kube.id}"
}
```

- Создадим региональный мастер Kubernetes с размещением нод в трёх разных подсетях.

[yandex_kubernetes_cluster.tf](/clopro/trfrm4/yandex_kubernetes_cluster.tf)

- Добавить возможность шифрования ключом из KMS

```tf
kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }
```

- Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести

[kubernetes_node_group.tf](/clopro/trfrm4/kubernetes_node_group.tf)

```tf
  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 1
    }
  }
```

- Подключимся к кластеру с помощью kubectl:

```bash
aleksturbo@AlksTrbNoute:~/yc$ yc managed-kubernetes cluster list
+----------------------+--------------+---------------------+---------+---------+------------------------+----------------------+
|          ID          |     NAME     |     CREATED AT      | HEALTH  | STATUS  |   EXTERNAL ENDPOINT    |  INTERNAL ENDPOINT   |
+----------------------+--------------+---------------------+---------+---------+------------------------+----------------------+
| cat1pi6t6auva3taifuk | netology-k8s | 2023-07-24 17:34:08 | HEALTHY | RUNNING | https://158.160.40.103 | https://192.168.10.3 |
+----------------------+--------------+---------------------+---------+---------+------------------------+----------------------+
```

```bash
aleksturbo@AlksTrbNoute:~/yc$ kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
phpmyadmin-deployment-5c4b89b694-4xwfd   1/1     Running   0          23h
aleksturbo@AlksTrbNoute:~/yc$
aleksturbo@AlksTrbNoute:~/yc$ kubectl config view --minify
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://158.160.40.103
  name: yc-managed-k8s-cat1pi6t6auva3taifuk
contexts:
- context:
    cluster: yc-managed-k8s-cat1pi6t6auva3taifuk
    user: yc-managed-k8s-cat1pi6t6auva3taifuk
  name: yc-netology-k8s
current-context: yc-netology-k8s
kind: Config
preferences: {}
users:
- name: yc-managed-k8s-cat1pi6t6auva3taifuk
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - k8s
      - create-token
      - --profile=kubernetes
      command: /home/aleksturbo/yandex-cloud/bin/yc
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false
aleksturbo@AlksTrbNoute:~/yc$ kubectl get all --all-namespaces=true
NAMESPACE     NAME                                         READY   STATUS    RESTARTS   AGE
default       pod/phpmyadmin-deployment-5c4b89b694-4xwfd   1/1     Running   0          23h
kube-system   pod/coredns-67d9cb9656-wg7lq                 1/1     Running   0          2d
kube-system   pod/ip-masq-agent-89cl2                      1/1     Running   0          47h
kube-system   pod/kube-dns-autoscaler-689576d9f4-pt64d     1/1     Running   0          2d
kube-system   pod/kube-proxy-s4586                         1/1     Running   0          47h
kube-system   pod/metrics-server-75d8b888d8-g85d4          2/2     Running   0          47h
kube-system   pod/npd-v0.8.0-zg7rk                         1/1     Running   0          47h
kube-system   pod/yc-disk-csi-node-v2-z4g9h                6/6     Running   0          47h
portainer     pod/portainer-agent-6595fdd67c-nsnzg         1/1     Running   0          46h

NAMESPACE     NAME                               TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                  AGE
default       service/kubernetes                 ClusterIP      10.96.128.1     <none>           443/TCP                  2d
default       service/phpmyadmin-deployment      ClusterIP      10.96.166.8     <none>           80/TCP                   25h
default       service/phpmyadmin-service         LoadBalancer   10.96.190.225   158.160.111.62   80:31253/TCP             36h
kube-system   service/kube-dns                   ClusterIP      10.96.128.2     <none>           53/UDP,53/TCP,9153/TCP   2d
kube-system   service/metrics-server             ClusterIP      10.96.217.151   <none>           443/TCP                  2d
portainer     service/portainer-agent            NodePort       10.96.212.46    <none>           9001:30778/TCP           46h
portainer     service/portainer-agent-headless   ClusterIP      None            <none>           <none>                   46h

NAMESPACE     NAME                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                                                                        AGE
kube-system   daemonset.apps/ip-masq-agent                    1         1         1       1            1           beta.kubernetes.io/os=linux,node.kubernetes.io/masq-agent-ds-ready=true              2d
kube-system   daemonset.apps/kube-proxy                       1         1         1       1            1           kubernetes.io/os=linux,node.kubernetes.io/kube-proxy-ds-ready=true                   2d
kube-system   daemonset.apps/npd-v0.8.0                       1         1         1       1            1           beta.kubernetes.io/os=linux,node.kubernetes.io/node-problem-detector-ds-ready=true   2d
kube-system   daemonset.apps/nvidia-device-plugin-daemonset   0         0         0       0            0           beta.kubernetes.io/os=linux,node.kubernetes.io/nvidia-device-plugin-ds-ready=true    2d
kube-system   daemonset.apps/yc-disk-csi-node                 0         0         0       0            0           <none>                                                                               2d
kube-system   daemonset.apps/yc-disk-csi-node-v2              1         1         1       1            1           yandex.cloud/pci-topology=k8s                                                        2d

NAMESPACE     NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
default       deployment.apps/phpmyadmin-deployment   1/1     1            1           23h
kube-system   deployment.apps/coredns                 1/1     1            1           2d
kube-system   deployment.apps/kube-dns-autoscaler     1/1     1            1           2d
kube-system   deployment.apps/metrics-server          1/1     1            1           2d
portainer     deployment.apps/portainer-agent         1/1     1            1           46h

NAMESPACE     NAME                                               DESIRED   CURRENT   READY   AGE
default       replicaset.apps/phpmyadmin-deployment-5c4b89b694   1         1         1       23h
default       replicaset.apps/phpmyadmin-deployment-7d6ffdbf57   0         0         0       23h
kube-system   replicaset.apps/coredns-67d9cb9656                 1         1         1       2d
kube-system   replicaset.apps/kube-dns-autoscaler-689576d9f4     1         1         1       2d
kube-system   replicaset.apps/metrics-server-64d75c78c6          0         0         0       2d
kube-system   replicaset.apps/metrics-server-75d8b888d8          1         1         1       47h
portainer     replicaset.apps/portainer-agent-6595fdd67c         1         1         1       46h
```

<img src="img/HW 15.4 YC k8s mngmnt.png"/>

- Запустим микросервис phpmyadmin и подключиться к ранее созданной БД:

[sa.yaml](/clopro/trfrm4/sa.yaml)
[phpmyadmin-deployment.yaml](/clopro/trfrm4/phpmyadmin-deployment.yaml)
[secret-mysql.yaml](/clopro/trfrm4/secret-mysql.yaml)

```bash
aleksturbo@AlksTrbNoute:~/yc$ kubectl apply -f phpmyadmin-deployment.yaml
deployment.apps/phpmyadmin-deployment created

aleksturbo@AlksTrbNoute:~/yc$ kubectl get deploy -o wide
NAME                    READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                  SELECTOR
phpmyadmin-deployment   1/1     1            1           23h   phpmyadmin   phpmyadmin/phpmyadmin   app=phpmyadmin
```

- Создать сервис-типы Load Balancer и подключиться к phpmyadmin

[service.yml](/clopro/trfrm4/service.yml)
[ingress.yml](/clopro/trfrm4/ingress.yml)


```bash
aleksturbo@AlksTrbNoute:~/yc$ kubectl get svc
NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
kubernetes              ClusterIP      10.96.128.1     <none>           443/TCP        2d
phpmyadmin-deployment   ClusterIP      10.96.166.8     <none>           80/TCP         25h
phpmyadmin-service      LoadBalancer   10.96.190.225   158.160.111.62   80:31253/TCP   36h
```

<img src="img/HW 15.4 YC nlb.png"/>

- Демонстрация работоспособности:

<img src="img/HW 15.4 YC phpmyadmin web.png"/>
