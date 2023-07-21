# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = "/root/.yd/key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone      = "ru-central1-a"
}

// создание сервисного аккаунта для backetов
resource "yandex_iam_service_account" "sa" {
  name = "sa-yc-bucket"
  description = "sa-yc-bucket"
  folder_id   = "b1g1qalus625i26qmq56"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [yandex_iam_service_account.sa]
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// kms_symmetric_key
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "netology-symetric-key"
  description       = "netology-symetric-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "netology-test-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pustovit-netology-bucket"
  acl    = "public-read"
  
  anonymous_access_flags {
    read = true
    list = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
} 

resource "yandex_storage_bucket" "netology-bucket-site" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pustovit-netology-bucket-site"
  acl    = "public-read"
  
  anonymous_access_flags {
    read = true
    list = false
  }

} 

