locals {
  cloud_id    = "b1gk0tcpmdt9lhdnsjrl"
  folder_id   = "b1g1qalus625i26qmq56"
  k8s_version = "1.24"
  sa_name     = "sa-kube"
}

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

// создание кластера
resource "yandex_kubernetes_cluster" "netology-k8s-regional" {
  name      = "netology-k8s"
  network_id = yandex_vpc_network.lab-net.id
  master {
    version = local.k8s_version
    public_ip = true
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.subnet-public-a.zone
        subnet_id = yandex_vpc_subnet.subnet-public-a.id
      }
      location {
        zone      = yandex_vpc_subnet.subnet-public-b.zone
        subnet_id = yandex_vpc_subnet.subnet-public-b.id
      }
      location {
        zone      = yandex_vpc_subnet.subnet-public-c.zone
        subnet_id = yandex_vpc_subnet.subnet-public-c.id
      }
    }
    security_group_ids = [
      "enpqeull9mu66gh4ea1d",
      yandex_vpc_security_group.k8s-master-whitelist.id
      ]
    
  }
  service_account_id      = yandex_iam_service_account.sa-kube.id
  node_service_account_id = yandex_iam_service_account.sa-kube.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }
  
}