resource "yandex_alb_target_group" "netology-tg" {
  name           = "alb-target-group"

  target {
    subnet_id    = yandex_vpc_subnet.subnet-public.id
    ip_address   = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.subnet-public.id
    ip_address   = yandex_compute_instance_group.ig.instances.1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.subnet-public.id
    ip_address   = yandex_compute_instance_group.ig.instances.2.network_interface.0.ip_address
  }

depends_on = [
    yandex_compute_instance_group.ig
]

}
