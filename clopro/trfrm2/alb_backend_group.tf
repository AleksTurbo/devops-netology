resource "yandex_alb_backend_group" "netology-backend-group" {
  name                     = "grp-backend"
  session_affinity {
    connection {
      source_ip = true
    }
  }

  http_backend {
    name                   = "http-backend"
    weight                 = 1
    port                   = 80
    target_group_ids        = [yandex_alb_target_group.netology-tg.id]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }

depends_on = [
    yandex_alb_target_group.netology-tg
]

}
