# Домашнее задание к занятию "15.1 Организация сети"

## Задание 1 - Yandex Cloud

### Подготавливаем инфраструктуру в УС:

- VPC subnet "public" - сеть 192.168.10.0/24
- NAT-инстанс с адресом 192.168.10.254. В качестве image_id используем fd80mrhj8fl2oe87o4e1.
- VM-инстанс публичным IP
- VPC subnet "private" - сеть 192.168.20.0/24.
- route table - направляющий весь исходящий трафик private сети в NAT-инстанс.
- VM-инстанс с приватным IP

Подготовку инфраструктуру проведем при помощи инструмента terraform:

[terraform](/clopro/trfrm)

```bash
[root@oracle clopro]# terraform apply -auto-approve
data.yandex_compute_image.vm_image: Reading...
data.yandex_compute_image.vm_image: Read complete after 1s [id=fd85f37uh98ldl1omk30]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.instance-nat will be created
  + resource "yandex_compute_instance" "instance-nat" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "instance-nat-vm.netology.ycloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDz8Dwu0FcsZYT5borOreJleN9/EjU9GowUbANoRKS2g9MeHITCU8izJk0Kn2Pt8T6oYXUOMMq/ovy/KdYRfbHiZOTvqow5bAu+2GGupcMV3e+E9mJXJICQVyrGA27aIdIWfTCgJrjpD4aE7kratC4FLqzpcZSetp/vthzc8eUcE5lPhQQUYZbiX+8S6wQCVz0bWc2JYnFeowMTDgJHjpimY+drUkTUJMqHhodZNjYZNlJ6wyFK9TaSsLGTn0TmIX6fybMzawQYSmCuBNw8wKB/FLXMsk7spv+ZImOXEjME34H0u60y3sR0k7GW+sdtSQYUP3DrQGP2bZBwHC4Jdi7QLZyfrdmFGc5bBYc+qkA8+F5iWedcWQaH+dyIH11UfuFdE+gR+ioyuH09eWttqrJnZ5zXwlzAPvJDCXWJUJ/PYx+fsR96TrnogMKYS0xRWR6tmBEztWnLZpOfFM48NPf+0hqqYL70GfpiCqu9KbVocuNcWLzuoNFXa8No4nvhMY0= root@oracle
            EOT
        }
      + name                      = "instance-nat-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80mrhj8fl2oe87o4e1"
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.10.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }
    }

  # yandex_compute_instance.private-vm will be created
  + resource "yandex_compute_instance" "private-vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "instance-private-vm.netology.ycloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "user-data" = <<-EOT
                #cloud-config
                
                datasource:
                  Ec2:
                    strict_id: false
                ssh_pwauth: yes
                users:
                  - name: "ubuntu"
                    sudo: ALL=(ALL) NOPASSWD:ALL
                    shell: /bin/bash
                    ssh-authorized-keys:
                      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDz8Dwu0FcsZYT5borOreJleN9/EjU9GowUbANoRKS2g9MeHITCU8izJk0Kn2Pt8T6oYXUOMMq/ovy/KdYRfbHiZOTvqow5bAu+2GGupcMV3e+E9mJXJICQVyrGA27aIdIWfTCgJrjpD4aE7kratC4FLqzpcZSetp/vthzc8eUcE5lPhQQUYZbiX+8S6wQCVz0bWc2JYnFeowMTDgJHjpimY+drUkTUJMqHhodZNjYZNlJ6wyFK9TaSsLGTn0TmIX6fybMzawQYSmCuBNw8wKB/FLXMsk7spv+ZImOXEjME34H0u60y3sR0k7GW+sdtSQYUP3DrQGP2bZBwHC4Jdi7QLZyfrdmFGc5bBYc+qkA8+F5iWedcWQaH+dyIH11UfuFdE+gR+ioyuH09eWttqrJnZ5zXwlzAPvJDCXWJUJ/PYx+fsR96TrnogMKYS0xRWR6tmBEztWnLZpOfFM48NPf+0hqqYL70GfpiCqu9KbVocuNcWLzuoNFXa8No4nvhMY0= root@oracle
                "
            EOT
        }
      + name                      = "instance-private-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd85f37uh98ldl1omk30"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }
    }

  # yandex_compute_instance.public-vm will be created
  + resource "yandex_compute_instance" "public-vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "instance-public-vm.netology.ycloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "user-data" = <<-EOT
                #cloud-config
                
                datasource:
                  Ec2:
                    strict_id: false
                ssh_pwauth: yes
                users:
                  - name: "ubuntu"
                    sudo: ALL=(ALL) NOPASSWD:ALL
                    shell: /bin/bash
                    ssh-authorized-keys:
                      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDz8Dwu0FcsZYT5borOreJleN9/EjU9GowUbANoRKS2g9MeHITCU8izJk0Kn2Pt8T6oYXUOMMq/ovy/KdYRfbHiZOTvqow5bAu+2GGupcMV3e+E9mJXJICQVyrGA27aIdIWfTCgJrjpD4aE7kratC4FLqzpcZSetp/vthzc8eUcE5lPhQQUYZbiX+8S6wQCVz0bWc2JYnFeowMTDgJHjpimY+drUkTUJMqHhodZNjYZNlJ6wyFK9TaSsLGTn0TmIX6fybMzawQYSmCuBNw8wKB/FLXMsk7spv+ZImOXEjME34H0u60y3sR0k7GW+sdtSQYUP3DrQGP2bZBwHC4Jdi7QLZyfrdmFGc5bBYc+qkA8+F5iWedcWQaH+dyIH11UfuFdE+gR+ioyuH09eWttqrJnZ5zXwlzAPvJDCXWJUJ/PYx+fsR96TrnogMKYS0xRWR6tmBEztWnLZpOfFM48NPf+0hqqYL70GfpiCqu9KbVocuNcWLzuoNFXa8No4nvhMY0= root@oracle
                "
            EOT
        }
      + name                      = "instance-public-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd85f37uh98ldl1omk30"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }
    }

  # yandex_vpc_network.lab-net will be created
  + resource "yandex_vpc_network" "lab-net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "lab-network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.nat-route-table will be created
  + resource "yandex_vpc_route_table" "nat-route-table" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = "192.168.10.254"
        }
    }

  # yandex_vpc_subnet.subnet-private will be created
  + resource "yandex_vpc_subnet" "subnet-private" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-public will be created
  + resource "yandex_vpc_subnet" "subnet-public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nat_vm     = (known after apply)
  + external_ip_address_private_vm = (known after apply)
  + external_ip_address_public_vm  = (known after apply)
  + internal_ip_address_nat_vm     = "192.168.10.254"
  + internal_ip_address_private_vm = (known after apply)
  + internal_ip_address_public_vm  = (known after apply)
yandex_vpc_network.lab-net: Creating...
yandex_vpc_network.lab-net: Creation complete after 1s [id=enpjsebvjv9bid4c3q3j]
yandex_vpc_subnet.subnet-public: Creating...
yandex_vpc_route_table.nat-route-table: Creating...
yandex_vpc_subnet.subnet-public: Creation complete after 1s [id=e9bhr4mvj37sktpdb8ek]
yandex_compute_instance.instance-nat: Creating...
yandex_compute_instance.public-vm: Creating...
yandex_vpc_route_table.nat-route-table: Creation complete after 2s [id=enpu74adkpu7ovq7o5bj]
yandex_vpc_subnet.subnet-private: Creating...
yandex_vpc_subnet.subnet-private: Creation complete after 1s [id=e9b9oeuil375kcef3hqn]
yandex_compute_instance.private-vm: Creating...
yandex_compute_instance.public-vm: Still creating... [10s elapsed]
yandex_compute_instance.instance-nat: Still creating... [10s elapsed]
yandex_compute_instance.private-vm: Still creating... [10s elapsed]
yandex_compute_instance.instance-nat: Still creating... [20s elapsed]
yandex_compute_instance.public-vm: Still creating... [20s elapsed]
yandex_compute_instance.private-vm: Still creating... [20s elapsed]
yandex_compute_instance.public-vm: Still creating... [30s elapsed]
yandex_compute_instance.instance-nat: Still creating... [30s elapsed]
yandex_compute_instance.private-vm: Still creating... [30s elapsed]
yandex_compute_instance.private-vm: Creation complete after 37s [id=fhmfpsb560ernkh4fpp5]
yandex_compute_instance.public-vm: Still creating... [40s elapsed]
yandex_compute_instance.instance-nat: Still creating... [40s elapsed]
yandex_compute_instance.public-vm: Creation complete after 41s [id=fhmdr8q0m4sp9fu3lnt9]
yandex_compute_instance.instance-nat: Still creating... [50s elapsed]
yandex_compute_instance.instance-nat: Still creating... [1m0s elapsed]
yandex_compute_instance.instance-nat: Creation complete after 1m0s [id=fhmk15p7iffrqc2u2rpv]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat_vm = "51.250.85.192"
external_ip_address_private_vm = ""
external_ip_address_public_vm = "158.160.50.95"
internal_ip_address_nat_vm = "192.168.10.254"
internal_ip_address_private_vm = "192.168.20.10"
internal_ip_address_public_vm = "192.168.10.12"
```

- instance

<img src="img/HW 15.1 YC compute.png"/>

- Облачные сети

<img src="img/HW 15.1 YC PVC.png"/>

- Подсети

<img src="img/HW 15.1 YC subnet.png"/>

- Таблицы маршрутизации

<img src="img/HW 15.1 YC route.png"/>

### Проверка работоспособности:

- instance-public-vm

```bash
[root@oracle ~]# ssh -i ~/.ssh/id_rsa ubuntu@158.160.50.95
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-153-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Fri Jul 14 17:41:00 2023 from 127.0.0.1

ubuntu@instance-public-vm:~$ curl 2ip.ru
158.160.50.95

ubuntu@instance-public-vm:~$ traceroute 77.88.8.8
traceroute to 77.88.8.8 (77.88.8.8), 30 hops max, 60 byte packets
 1  * * *
 2  * * *
 3  * * *
 4  * * *
 5  * vla-32z1-ae3.yndx.net (93.158.160.151)  1.120 ms *
 6  dns.yandex.ru (77.88.8.8)  0.569 ms  0.346 ms *

ubuntu@instance-public-vm:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:dd:a3:40:b1 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.12/24 brd 192.168.10.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d20d:ddff:fea3:40b1/64 scope link
       valid_lft forever preferred_lft forever

ubuntu@instance-public-vm:~$ ip r
default via 192.168.10.1 dev eth0 proto dhcp src 192.168.10.12 metric 100
192.168.10.0/24 dev eth0 proto kernel scope link src 192.168.10.12
192.168.10.1 dev eth0 proto dhcp scope link src 192.168.10.12 metric 100
```

- instance-private-vm

```bash
ubuntu@instance-public-vm:~$ ssh instance-private-vm
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-153-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Fri Jul 14 17:41:59 2023 from 192.168.10.12

ubuntu@instance-private-vm:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:fc:f1:65:30 brd ff:ff:ff:ff:ff:ff
    inet 192.168.20.10/24 brd 192.168.20.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d20d:fcff:fef1:6530/64 scope link
       valid_lft forever preferred_lft forever

ubuntu@instance-private-vm:~$ ip r
default via 192.168.20.1 dev eth0 proto dhcp src 192.168.20.10 metric 100
192.168.20.0/24 dev eth0 proto kernel scope link src 192.168.20.10
192.168.20.1 dev eth0 proto dhcp scope link src 192.168.20.10 metric 100

ubuntu@instance-private-vm:~$ curl 2ip.ru
51.250.85.192

ubuntu@instance-private-vm:~$ traceroute 77.88.8.8
traceroute to 77.88.8.8 (77.88.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.20.1)  0.855 ms  0.815 ms  0.819 ms
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  vla-32z3-ae4.yndx.net (93.158.160.117)  4.425 ms  10.462 ms  10.179 ms
 8  * * *
 9  dns.yandex.ru (77.88.8.8)  1.175 ms  1.159 ms  1.141 ms
```

### Разбираем инфраструктуру

```bash
[root@oracle clopro]# terraform destroy -auto-approve
data.yandex_compute_image.vm_image: Reading...
yandex_vpc_network.lab-net: Refreshing state... [id=enpjsebvjv9bid4c3q3j]
data.yandex_compute_image.vm_image: Read complete after 1s [id=fd85f37uh98ldl1omk30]
yandex_vpc_subnet.subnet-public: Refreshing state... [id=e9bhr4mvj37sktpdb8ek]
yandex_vpc_route_table.nat-route-table: Refreshing state... [id=enpu74adkpu7ovq7o5bj]
yandex_vpc_subnet.subnet-private: Refreshing state... [id=e9b9oeuil375kcef3hqn]
yandex_compute_instance.instance-nat: Refreshing state... [id=fhmk15p7iffrqc2u2rpv]
yandex_compute_instance.public-vm: Refreshing state... [id=fhmdr8q0m4sp9fu3lnt9]
yandex_compute_instance.private-vm: Refreshing state... [id=fhmfpsb560ernkh4fpp5]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # yandex_compute_instance.instance-nat will be destroyed
  - resource "yandex_compute_instance" "instance-nat" {
      - created_at                = "2023-07-14T17:24:39Z" -> null
      - folder_id                 = "b1g1qalus625i26qmq56" -> null
      - fqdn                      = "instance-nat-vm.netology.ycloud" -> null
      - hostname                  = "instance-nat-vm.netology.ycloud" -> null
      - id                        = "fhmk15p7iffrqc2u2rpv" -> null
      - labels                    = {} -> null
      - metadata                  = {
          - "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDz8Dwu0FcsZYT5borOreJleN9/EjU9GowUbANoRKS2g9MeHITCU8izJk0Kn2Pt8T6oYXUOMMq/ovy/KdYRfbHiZOTvqow5bAu+2GGupcMV3e+E9mJXJICQVyrGA27aIdIWfTCgJrjpD4aE7kratC4FLqzpcZSetp/vthzc8eUcE5lPhQQUYZbiX+8S6wQCVz0bWc2JYnFeowMTDgJHjpimY+drUkTUJMqHhodZNjYZNlJ6wyFK9TaSsLGTn0TmIX6fybMzawQYSmCuBNw8wKB/FLXMsk7spv+ZImOXEjME34H0u60y3sR0k7GW+sdtSQYUP3DrQGP2bZBwHC4Jdi7QLZyfrdmFGc5bBYc+qkA8+F5iWedcWQaH+dyIH11UfuFdE+gR+ioyuH09eWttqrJnZ5zXwlzAPvJDCXWJUJ/PYx+fsR96TrnogMKYS0xRWR6tmBEztWnLZpOfFM48NPf+0hqqYL70GfpiCqu9KbVocuNcWLzuoNFXa8No4nvhMY0= root@oracle
            EOT
        } -> null
      - name                      = "instance-nat-vm" -> null
      - network_acceleration_type = "standard" -> null
      - platform_id               = "standard-v1" -> null
      - status                    = "running" -> null
      - zone                      = "ru-central1-a" -> null

      - boot_disk {
          - auto_delete = true -> null
          - device_name = "fhm1moicv6as6mhuu2s4" -> null
          - disk_id     = "fhm1moicv6as6mhuu2s4" -> null
          - mode        = "READ_WRITE" -> null

          - initialize_params {
              - block_size = 4096 -> null
              - image_id   = "fd80mrhj8fl2oe87o4e1" -> null
              - size       = 40 -> null
              - type       = "network-hdd" -> null
            }
        }

      - metadata_options {
          - aws_v1_http_endpoint = 1 -> null
          - aws_v1_http_token    = 2 -> null
          - gce_http_endpoint    = 1 -> null
          - gce_http_token       = 1 -> null
        }

      - network_interface {
          - index              = 0 -> null
          - ip_address         = "192.168.10.254" -> null
          - ipv4               = true -> null
          - ipv6               = false -> null
          - mac_address        = "d0:0d:14:09:72:79" -> null
          - nat                = true -> null
          - nat_ip_address     = "51.250.85.192" -> null
          - nat_ip_version     = "IPV4" -> null
          - security_group_ids = [] -> null
          - subnet_id          = "e9bhr4mvj37sktpdb8ek" -> null
        }

      - placement_policy {
          - host_affinity_rules = [] -> null
        }

      - resources {
          - core_fraction = 100 -> null
          - cores         = 2 -> null
          - gpus          = 0 -> null
          - memory        = 4 -> null
        }

      - scheduling_policy {
          - preemptible = false -> null
        }
    }

  # yandex_compute_instance.private-vm will be destroyed
  - resource "yandex_compute_instance" "private-vm" {
      - created_at                = "2023-07-14T17:24:41Z" -> null
      - folder_id                 = "b1g1qalus625i26qmq56" -> null
      - fqdn                      = "instance-private-vm.netology.ycloud" -> null
      - hostname                  = "instance-private-vm.netology.ycloud" -> null
      - id                        = "fhmfpsb560ernkh4fpp5" -> null
      - labels                    = {} -> null
      - metadata                  = {
          - "user-data" = <<-EOT
                #cloud-config
                
                datasource:
                  Ec2:
                    strict_id: false
                ssh_pwauth: yes
                users:
                  - name: "ubuntu"
                    sudo: ALL=(ALL) NOPASSWD:ALL
                    shell: /bin/bash
                    ssh-authorized-keys:
                      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDz8Dwu0FcsZYT5borOreJleN9/EjU9GowUbANoRKS2g9MeHITCU8izJk0Kn2Pt8T6oYXUOMMq/ovy/KdYRfbHiZOTvqow5bAu+2GGupcMV3e+E9mJXJICQVyrGA27aIdIWfTCgJrjpD4aE7kratC4FLqzpcZSetp/vthzc8eUcE5lPhQQUYZbiX+8S6wQCVz0bWc2JYnFeowMTDgJHjpimY+drUkTUJMqHhodZNjYZNlJ6wyFK9TaSsLGTn0TmIX6fybMzawQYSmCuBNw8wKB/FLXMsk7spv+ZImOXEjME34H0u60y3sR0k7GW+sdtSQYUP3DrQGP2bZBwHC4Jdi7QLZyfrdmFGc5bBYc+qkA8+F5iWedcWQaH+dyIH11UfuFdE+gR+ioyuH09eWttqrJnZ5zXwlzAPvJDCXWJUJ/PYx+fsR96TrnogMKYS0xRWR6tmBEztWnLZpOfFM48NPf+0hqqYL70GfpiCqu9KbVocuNcWLzuoNFXa8No4nvhMY0= root@oracle
                "
            EOT
        } -> null
      - name                      = "instance-private-vm" -> null
      - network_acceleration_type = "standard" -> null
      - platform_id               = "standard-v1" -> null
      - status                    = "running" -> null
      - zone                      = "ru-central1-a" -> null

      - boot_disk {
          - auto_delete = true -> null
          - device_name = "fhm84jjl6c4ik97s7rqu" -> null
          - disk_id     = "fhm84jjl6c4ik97s7rqu" -> null
          - mode        = "READ_WRITE" -> null

          - initialize_params {
              - block_size = 4096 -> null
              - image_id   = "fd85f37uh98ldl1omk30" -> null
              - size       = 20 -> null
              - type       = "network-hdd" -> null
            }
        }

      - metadata_options {
          - aws_v1_http_endpoint = 1 -> null
          - aws_v1_http_token    = 2 -> null
          - gce_http_endpoint    = 1 -> null
          - gce_http_token       = 1 -> null
        }

      - network_interface {
          - index              = 0 -> null
          - ip_address         = "192.168.20.10" -> null
          - ipv4               = true -> null
          - ipv6               = false -> null
          - mac_address        = "d0:0d:fc:f1:65:30" -> null
          - nat                = false -> null
          - security_group_ids = [] -> null
          - subnet_id          = "e9b9oeuil375kcef3hqn" -> null
        }

      - placement_policy {
          - host_affinity_rules = [] -> null
        }

      - resources {
          - core_fraction = 100 -> null
          - cores         = 2 -> null
          - gpus          = 0 -> null
          - memory        = 2 -> null
        }

      - scheduling_policy {
          - preemptible = false -> null
        }
    }

  # yandex_compute_instance.public-vm will be destroyed
  - resource "yandex_compute_instance" "public-vm" {
      - created_at                = "2023-07-14T17:24:39Z" -> null
      - folder_id                 = "b1g1qalus625i26qmq56" -> null
      - fqdn                      = "instance-public-vm.netology.ycloud" -> null
      - hostname                  = "instance-public-vm.netology.ycloud" -> null
      - id                        = "fhmdr8q0m4sp9fu3lnt9" -> null
      - labels                    = {} -> null
      - metadata                  = {
          - "user-data" = <<-EOT
                #cloud-config
                
                datasource:
                  Ec2:
                    strict_id: false
                ssh_pwauth: yes
                users:
                  - name: "ubuntu"
                    sudo: ALL=(ALL) NOPASSWD:ALL
                    shell: /bin/bash
                    ssh-authorized-keys:
                      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDz8Dwu0FcsZYT5borOreJleN9/EjU9GowUbANoRKS2g9MeHITCU8izJk0Kn2Pt8T6oYXUOMMq/ovy/KdYRfbHiZOTvqow5bAu+2GGupcMV3e+E9mJXJICQVyrGA27aIdIWfTCgJrjpD4aE7kratC4FLqzpcZSetp/vthzc8eUcE5lPhQQUYZbiX+8S6wQCVz0bWc2JYnFeowMTDgJHjpimY+drUkTUJMqHhodZNjYZNlJ6wyFK9TaSsLGTn0TmIX6fybMzawQYSmCuBNw8wKB/FLXMsk7spv+ZImOXEjME34H0u60y3sR0k7GW+sdtSQYUP3DrQGP2bZBwHC4Jdi7QLZyfrdmFGc5bBYc+qkA8+F5iWedcWQaH+dyIH11UfuFdE+gR+ioyuH09eWttqrJnZ5zXwlzAPvJDCXWJUJ/PYx+fsR96TrnogMKYS0xRWR6tmBEztWnLZpOfFM48NPf+0hqqYL70GfpiCqu9KbVocuNcWLzuoNFXa8No4nvhMY0= root@oracle
                "
            EOT
        } -> null
      - name                      = "instance-public-vm" -> null
      - network_acceleration_type = "standard" -> null
      - platform_id               = "standard-v1" -> null
      - status                    = "running" -> null
      - zone                      = "ru-central1-a" -> null

      - boot_disk {
          - auto_delete = true -> null
          - device_name = "fhm702kv8pd0j73slcu1" -> null
          - disk_id     = "fhm702kv8pd0j73slcu1" -> null
          - mode        = "READ_WRITE" -> null

          - initialize_params {
              - block_size = 4096 -> null
              - image_id   = "fd85f37uh98ldl1omk30" -> null
              - size       = 20 -> null
              - type       = "network-hdd" -> null
            }
        }

      - metadata_options {
          - aws_v1_http_endpoint = 1 -> null
          - aws_v1_http_token    = 2 -> null
          - gce_http_endpoint    = 1 -> null
          - gce_http_token       = 1 -> null
        }

      - network_interface {
          - index              = 0 -> null
          - ip_address         = "192.168.10.12" -> null
          - ipv4               = true -> null
          - ipv6               = false -> null
          - mac_address        = "d0:0d:dd:a3:40:b1" -> null
          - nat                = true -> null
          - nat_ip_address     = "158.160.50.95" -> null
          - nat_ip_version     = "IPV4" -> null
          - security_group_ids = [] -> null
          - subnet_id          = "e9bhr4mvj37sktpdb8ek" -> null
        }

      - placement_policy {
          - host_affinity_rules = [] -> null
        }

      - resources {
          - core_fraction = 100 -> null
          - cores         = 2 -> null
          - gpus          = 0 -> null
          - memory        = 2 -> null
        }

      - scheduling_policy {
          - preemptible = false -> null
        }
    }

  # yandex_vpc_network.lab-net will be destroyed
  - resource "yandex_vpc_network" "lab-net" {
      - created_at = "2023-07-14T17:24:37Z" -> null
      - folder_id  = "b1g1qalus625i26qmq56" -> null
      - id         = "enpjsebvjv9bid4c3q3j" -> null
      - labels     = {} -> null
      - name       = "lab-network" -> null
      - subnet_ids = [
          - "e9b9oeuil375kcef3hqn",
          - "e9bhr4mvj37sktpdb8ek",
        ] -> null
    }

  # yandex_vpc_route_table.nat-route-table will be destroyed
  - resource "yandex_vpc_route_table" "nat-route-table" {
      - created_at = "2023-07-14T17:24:38Z" -> null
      - folder_id  = "b1g1qalus625i26qmq56" -> null
      - id         = "enpu74adkpu7ovq7o5bj" -> null
      - labels     = {} -> null
      - network_id = "enpjsebvjv9bid4c3q3j" -> null

      - static_route {
          - destination_prefix = "0.0.0.0/0" -> null
          - next_hop_address   = "192.168.10.254" -> null
        }
    }

  # yandex_vpc_subnet.subnet-private will be destroyed
  - resource "yandex_vpc_subnet" "subnet-private" {
      - created_at     = "2023-07-14T17:24:40Z" -> null
      - folder_id      = "b1g1qalus625i26qmq56" -> null
      - id             = "e9b9oeuil375kcef3hqn" -> null
      - labels         = {} -> null
      - name           = "private" -> null
      - network_id     = "enpjsebvjv9bid4c3q3j" -> null
      - route_table_id = "enpu74adkpu7ovq7o5bj" -> null
      - v4_cidr_blocks = [
          - "192.168.20.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
    }

  # yandex_vpc_subnet.subnet-public will be destroyed
  - resource "yandex_vpc_subnet" "subnet-public" {
      - created_at     = "2023-07-14T17:24:38Z" -> null
      - folder_id      = "b1g1qalus625i26qmq56" -> null
      - id             = "e9bhr4mvj37sktpdb8ek" -> null
      - labels         = {} -> null
      - name           = "public" -> null
      - network_id     = "enpjsebvjv9bid4c3q3j" -> null
      - v4_cidr_blocks = [
          - "192.168.10.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
    }

Plan: 0 to add, 0 to change, 7 to destroy.

Changes to Outputs:
  - external_ip_address_nat_vm     = "51.250.85.192" -> null
  - external_ip_address_private_vm = "" -> null
  - external_ip_address_public_vm  = "158.160.50.95" -> null
  - internal_ip_address_nat_vm     = "192.168.10.254" -> null
  - internal_ip_address_private_vm = "192.168.20.10" -> null
  - internal_ip_address_public_vm  = "192.168.10.12" -> null
yandex_compute_instance.private-vm: Destroying... [id=fhmfpsb560ernkh4fpp5]
yandex_compute_instance.instance-nat: Destroying... [id=fhmk15p7iffrqc2u2rpv]
yandex_compute_instance.public-vm: Destroying... [id=fhmdr8q0m4sp9fu3lnt9]
yandex_compute_instance.instance-nat: Still destroying... [id=fhmk15p7iffrqc2u2rpv, 10s elapsed]
yandex_compute_instance.private-vm: Still destroying... [id=fhmfpsb560ernkh4fpp5, 10s elapsed]
yandex_compute_instance.public-vm: Still destroying... [id=fhmdr8q0m4sp9fu3lnt9, 10s elapsed]
yandex_compute_instance.instance-nat: Destruction complete after 20s
yandex_compute_instance.private-vm: Still destroying... [id=fhmfpsb560ernkh4fpp5, 20s elapsed]
yandex_compute_instance.public-vm: Still destroying... [id=fhmdr8q0m4sp9fu3lnt9, 20s elapsed]
yandex_compute_instance.private-vm: Destruction complete after 22s
yandex_vpc_subnet.subnet-private: Destroying... [id=e9b9oeuil375kcef3hqn]
yandex_vpc_subnet.subnet-private: Destruction complete after 2s
yandex_vpc_route_table.nat-route-table: Destroying... [id=enpu74adkpu7ovq7o5bj]
yandex_vpc_route_table.nat-route-table: Destruction complete after 1s
yandex_compute_instance.public-vm: Destruction complete after 26s
yandex_vpc_subnet.subnet-public: Destroying... [id=e9bhr4mvj37sktpdb8ek]
yandex_vpc_subnet.subnet-public: Destruction complete after 3s
yandex_vpc_network.lab-net: Destroying... [id=enpjsebvjv9bid4c3q3j]
yandex_vpc_network.lab-net: Destruction complete after 1s

Destroy complete! Resources: 7 destroyed.

```