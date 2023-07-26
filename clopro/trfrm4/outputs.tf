output "mdb_mysql_database" {
  value = yandex_mdb_mysql_database.netology-db.name
}

data "yandex_kubernetes_cluster" "netology-k8s-regional" {
  cluster_id = yandex_kubernetes_cluster.netology-k8s-regional.id
}
output "cluster_external_v4_endpoint" {
  value = "${data.yandex_kubernetes_cluster.netology-k8s-regional.master.0.external_v4_endpoint}"
}

