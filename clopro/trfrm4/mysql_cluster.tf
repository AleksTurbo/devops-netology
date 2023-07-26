resource "yandex_mdb_mysql_cluster" "netology-mysql-cluster" {
  name                = "netology-mysql-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.lab-net.id
  version             = "8.0"
  security_group_ids  = [ "enpqeull9mu66gh4ea1d" ] 
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = "20"
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-private-30.id
    assign_public_ip = true
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "MON"
    hour = 03
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  access {
    web_sql   = true
    data_lens = true
  }

}

resource "yandex_mdb_mysql_database" "netology-db" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql-cluster.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "dbuser" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql-cluster.id
  name       = "dbuser"
  password   = "dbP@ss19"
  permission {
    database_name = "netology_db"
    roles         = ["ALL"]
  }
  depends_on = [yandex_mdb_mysql_database.netology-db]
}
