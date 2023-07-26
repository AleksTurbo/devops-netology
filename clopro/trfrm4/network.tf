resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "subnet-public-a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-public-b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

resource "yandex_vpc_subnet" "subnet-public-c" {
  name           = "public-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}


resource "yandex_vpc_subnet" "subnet-private-30" {
  name           = "private-30"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_vpc_subnet" "subnet-private-40" {
  name           = "private-40"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["192.168.40.0/24"]
}

resource "yandex_vpc_subnet" "subnet-private-50" {
  name           = "private-50"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["192.168.50.0/24"]
}