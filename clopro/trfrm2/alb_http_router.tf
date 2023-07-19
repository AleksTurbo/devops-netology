resource "yandex_alb_http_router" "tf-router" {
  name          = "router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name                    = "host-netology-yc"
  http_router_id          = yandex_alb_http_router.tf-router.id
  route {
    name                  = "route-http"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.netology-backend-group.id
        timeout           = "60s"
      }
    }
  }

depends_on = [
    yandex_alb_backend_group.netology-backend-group
]

}    
