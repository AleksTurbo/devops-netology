# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

## Задача 1

- Подготовка образа ОС. Есть несколько вариантов:
  - Можно воспользоваться маркеплейсом яндекса и использовать общедоступные образы ami: image_id = data.yandex_compute_image.ubuntu.id
  - Можно воспользоваться общедоступным образом, но создать свой модифицированный: yc compute image create "<"IMAGE-NAME>" [Flags...] [Global Flags...]
  - Использование инструмента Packer <https://www.packer.io/>

- Формируем фаилы инфраструктуры:
  - main.tf
  - variables.tf
  - versions.tf
  - outputs.tf
  - key.json

- Подготавливаем провайдер Яндекс для Тераформа:

```bash
aleksturbo@AlksTrbNoute:~/terraform72$ yc -v
Yandex Cloud CLI 0.97.0 linux/amd64
aleksturbo@AlksTrbNoute:~/terraform72$ yc config list
token: y0_AgAAAAA******************************************XaZDNYDY5MU
cloud-id: b1gk0tcpmdt9lhdnsjrl
folder-id: b1g1qalus625i26qmq56
compute-default-zone: ru-central1-a


aleksturbo@AlksTrbNoute:~/terraform72$ terraform init -upgrade

Initializing the backend...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching "~> 0.80.0"...
- Installing yandex-cloud/yandex v0.80.0...
- Installed yandex-cloud/yandex v0.80.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!
```

- Проверяем план:

```bash
aleksturbo@AlksTrbNoute:~/terraform72$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 9s [id=fd8kdq6d0p8sij7h5qe3]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm will be created
  + resource "yandex_compute_instance" "vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3XD7uasY21QfLnb0CJd9heihglS0kQ3z5n4aYUnH/avBmcaVFEq6m2O1r2Hbk2/KTUEP/+FJ+70UvP+UPix9lGLQvAn6BKRLBz2bRSuqF5KohpslRauD+wuAxxnXVZPeCx5fPurYijrMCNqDaWxf36hb+Q5FNpEB6xcnGfNi+XsTOdyPmTu4LmIEdbC7/bAHtTdlGN+n6ToTjP9Au********************************************************gJD2TtOVg0lDpXxM5B7xDLrz81BilLZObzs9qf9KJq7/aKMx9ipQ2LE1zMV77+******************************************************************+DV1OloJn6GY8BAO99Iy0KiD1O/cyqxJI6zEKZqWiE8Vd/0= aleksturbo@AlksTrbNoute
            EOT
        }
      + name                      = "netology"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8kdq6d0p8sij7h5qe3"
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
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet will be created
  + resource "yandex_vpc_subnet" "subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + yandex_ip_private = (known after apply)
  + yandex_vpc_subnet = (known after apply)
  + yandex_zone       = (known after apply)

───────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
