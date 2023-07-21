# Домашнее задание к занятию "15.3 Безопасность в облачных провайдерах"

## Задание 1 - Yandex Cloud

### 1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

- Модифицируем манифесты:

- Генерируем ключ:

```tf
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "netology-symetric-key"
  description       = "netology-symetric-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}
```

```bash
[root@oracle clopro3]# yc kms symmetric-key list
+----------------------+-----------------------+----------------------+-------------------+---------------------+--------+
|          ID          |         NAME          |  PRIMARY VERSION ID  | DEFAULT ALGORITHM |     CREATED AT      | STATUS |
+----------------------+-----------------------+----------------------+-------------------+---------------------+--------+
| abjd2q3r3o25dout1409 | netology-symetric-key | abjt4gn0g15ncm8760o7 | AES_128           | 2023-07-21 11:25:48 | ACTIVE |
+----------------------+-----------------------+----------------------+-------------------+---------------------+--------+

```

- Подключаем шифрование бакета на стороне сервера:

```tf
server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
```

- проверяем результат

```bash
[root@oracle clopro3]# aws --endpoint-url=https://storage.yandexcloud.net/ s3api get-bucket-encryption --bucket pustovit-netology-bucket
{
    "ServerSideEncryptionConfiguration": {
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "aws:kms",
                    "KMSMasterKeyID": "abjd2q3r3o25dout1409"
                }
            }
        ]
    }
}
```

[bucket.tf](/clopro/trfrm3/main.tf)

<img src="img/HW 15.3 YC kms key.png"/>

<img src="img/HW 15.3 YC kms key2.png"/>

### 2. Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

- Cоздадим сертификат для домена:

<img src="img/HW 15.3 YC sertificat.png"/>

-

<img src="img/HW 15.3 YC sertificat2.png"/>

- создать статическую страницу в Object Storage и применить сертификат HTTPS:

[index.html](/clopro/trfrm3/index.html)

-

[site.tf](/clopro/trfrm3/site.tf)

```tf
 website {
    index_document = "index.html"
    error_document = "error.html"
  }

  https {
    certificate_id = "fpq9ci308vapp3o3n3sj"
  }
```

<img src="img/HW 15.3 YC bucket site.png"/>

-

<img src="img/HW 15.3 YC site https.png"/>

- настраиваем DNS записи:

<img src="img/HW 15.3 YC dns.png"/>

### Демонстрация результата:

- [terraform manifest's](/clopro/trfrm3)

<img src="img/HW 15.3 YC site result.png"/>