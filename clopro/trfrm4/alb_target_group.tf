resource "yandex_alb_target_group" "netology-tg" {
  name           = "alb-target-group"

  target {
    subnet_id    = yandex_vpc_subnet.subnet-public-a.id
    ip_address   = "192.168.10.11"
  }

  target {
    subnet_id    = yandex_vpc_subnet.subnet-public-b.id
    ip_address   = "192.168.11.1"
  } 

  target {
    subnet_id    = yandex_vpc_subnet.subnet-public-c.id
    ip_address   = "192.168.12.1"
  }

}
