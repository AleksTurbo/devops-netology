output "test-image-1-url" {
  value = "https://${yandex_storage_bucket.netology-test-bucket.bucket_domain_name}/AlksTrbLogo0.png"
}

output "test-image-2-url" {
  value = "https://${yandex_storage_bucket.netology-test-bucket.bucket_domain_name}/AlksTrbLogo0.jpg"
}

output "instance-0-ip" {
  value = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
}

output "instance-1-ip" {
  value = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
}

output "instance-2-ip" {
  value = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
}

output "alb_target_group" {
  value = yandex_alb_target_group.netology-tg.id
}