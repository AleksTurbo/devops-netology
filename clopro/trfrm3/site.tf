// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "aleksturbo-ru" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "aleksturbo.ru"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  https {
    certificate_id = "fpq9ci308vapp3o3n3sj"
  }

  depends_on = [yandex_iam_service_account_static_access_key.sa-static-key]
}

// Загрузка объекта
resource "yandex_storage_object" "index_document" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "aleksturbo.ru"
  key        = "index.html"
  source     = "index.html"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.aleksturbo-ru]

}