// Загрузка объекта
resource "yandex_storage_object" "test-image-1" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pustovit-netology-bucket"
  key        = "AlksTrbLogo0.png"
  source     = "img/AlksTrbLogo0.png"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.netology-test-bucket]

}

resource "yandex_storage_object" "test-image-2" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pustovit-netology-bucket"
  key        = "AlksTrbLogo0.jpg"
  source     = "img/AlksTrbLogo0.jpg"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.netology-test-bucket]
}

resource "yandex_storage_object" "test-image-3" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pustovit-netology-bucket-site"
  key        = "AlksTrbLogo0.png"
  source     = "img/AlksTrbLogo0.png"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.netology-bucket-site]

}

resource "yandex_storage_object" "test-image-4" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pustovit-netology-bucket-site"
  key        = "AlksTrbLogo0.jpg"
  source     = "img/AlksTrbLogo0.jpg"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.netology-bucket-site]
}
