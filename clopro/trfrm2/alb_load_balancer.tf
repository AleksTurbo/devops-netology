resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "alb-load-balancer"
  network_id  = yandex_vpc_network.lab-net.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-public.id
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 9000 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }

 depends_on = [
    yandex_alb_http_router.tf-router
] 

}
