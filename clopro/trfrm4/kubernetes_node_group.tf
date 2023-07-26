resource "yandex_kubernetes_node_group" "k8s-group-node" {
  cluster_id = yandex_kubernetes_cluster.netology-k8s-regional.id
  name       = "k8s-group-node"
  description = "description"
  version     = local.k8s_version
  labels = {
    "key" = "value"
  }
  instance_template {
    platform_id = "standard-v1"
    name        = "worker-a-{instance.short_id}"
    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.subnet-public-a.id]
      security_group_ids = [yandex_vpc_security_group.sec-grp.id]
    }
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 32
    }
    scheduling_policy {
      preemptible = false
    }
  }
  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }
}

