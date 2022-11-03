# Домашнее задание к занятию "7.6 Основы golang"

## Задача 1 - исходный код AWS провайдера

1. Перечисление доступных resource и data_source:

  * ResourcesMap: map[string]*schema.Resource{
  https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L930

  * DataSourcesMap: map[string]*schema.Resource{
  https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L419

2. Очередь сообщений SQS используется ресурс aws_sqs_queue:

* С каким другим параметром конфликтует name? - ConflictsWith: []string{"name_prefix"}
  https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L88

```go
  "name": {
    Type:          schema.TypeString,
    Optional:      true,
    Computed:      true,
      ForceNew:      true,
      ConflictsWith: []string{"name_prefix"},
   }

```

* Какая максимальная длина имени? - 75 или 80 символов
https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L433

```go
var re *regexp.Regexp

if fifoQueue {
    re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
    } else {
    re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
}
```

* Какому регулярному выражению должно подчиняться имя?  - regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L433

```go
var re *regexp.Regexp

if fifoQueue {
    re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
    } else {
    re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
}
```

## Задача 2 - Создаем свой провайдер на примере кофемашины

1. Клонируем заготовку:

```ps
aleksturbo@AlksTrbNoute:~$ git clone https://github.com/hashicorp/terraform-provider-hashicups.git
Cloning into 'terraform-provider-hashicups'...
remote: Enumerating objects: 3554, done.
remote: Counting objects: 100% (477/477), done.
remote: Compressing objects: 100% (293/293), done.
remote: Total 3554 (delta 221), reused 207 (delta 181), pack-reused 3077
Receiving objects: 100% (3554/3554), 71.54 MiB | 5.00 MiB/s, done.
Resolving deltas: 100% (892/892), done.
```

Получаем следующую структуру:

```
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups$ tree
.
├── Makefile
├── README.md
├── docker_compose
│   ├── conf.json
│   └── docker-compose.yml
├── examples
│   ├── coffee
│   │   └── main.tf
│   ├── import
│   │   └── main.tf
│   └── main.tf
├── go.mod
├── go.sum
├── hashicups
│   ├── data_source_coffee.go
│   ├── data_source_ingredient.go
│   ├── data_source_order.go
│   ├── provider.go
│   ├── provider_test.go
│   ├── resource_order.go
│   └── resource_order_test.go
├── main.go
└── terraform-registry-manifest.json

5 directories, 18 files
```

2. Правим провайдер и собираем:

```bash
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups$ make
go build -o terraform-provider-hashicups
mkdir -p ~/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.5.8/linux_amd64
mv terraform-provider-hashicups ~/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.5.8/linux_amd64
```

3. Запускаем "localcloud":

```bash
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/docker_compose$ docker-compose up -d
[+] Running 3/3
 ⠿ Network docker_compose_default Created           0.8s
 ⠿ Container docker_compose-db-1   Started          1.6s
 ⠿ Container docker_compose-api-1  Started          2.9s

 aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups$ docker ps
CONTAINER ID   IMAGE                                      COMMAND                  CREATED         STATUS         PORTS                            NAMES
dc3cb934a198   hashicorpdemoapp/product-api:v4280cf7      "/app/product-api"       9 minutes ago   Up 9 minutes   0.0.0.0:19090->9090/tcp    docker_compose-api-1
121a9a8fa8f7   hashicorpdemoapp/product-api-db:v4280cf7   "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes   0.0.0.0:15432->5432/tcp    docker_compose-db-1

aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups$ curl localhost:19090/health
ok
```

4. Инициализируем terraform

```bash
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ terraform init
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp.com/edu/hashicups versions matching "0.5.8"...
- Installing hashicorp.com/edu/hashicups v0.5.8...
- Installed hashicorp.com/edu/hashicups v0.5.8 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.
...
Terraform has been successfully initialized!
```

5. Создаем пользователя и авторизуемся:

```
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ curl -X POST localhost:19090/signup -d '{"username":"education", "password":"test123"}'
{"UserID":1,"Username":"education","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Njc1ODAwMzIsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoiZWR1Y2F0aW9uIn0.1q3fMzAVQ1dH507eIm0n2jvEIWbkal0zxehysRJKWUU"}

aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ export HASHICUPS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Njc1ODAwMzIsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoiZWR1Y2F0aW9uIn0.1q3fMzAVQ1dH507eIm0n2jvEIWbkal0zxehysRJKWUU

aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ echo $HASHICUPS_TOKEN
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Njc1ODAwMzIsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoiZWR1Y2F0aW9uIn0.1q3fMzAVQ1dH507eIm0n2jvEIWbkal0zxehysRJKWUU

aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ curl -X POST localhost:19090/signin -d '{"username":"education", "password":"test123"}'
{"UserID":1,"Username":"education","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Njc1ODAyNjEsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoiZWR1Y2F0aW9uIn0.5XDltd7u13fJbzeudLonzO3nW7BgTRHSHHrXxRMAQII"}
```

6. Запускаем

```bash
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ terraform apply
module.psl.data.hashicups_coffees.all: Reading...
data.hashicups_order.order: Reading...
data.hashicups_order.first: Reading...
module.psl.data.hashicups_coffees.all: Read complete after 0s [id=1667493908]
data.hashicups_order.first: Read complete after 0s
data.hashicups_order.order: Read complete after 0s

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # hashicups_order.edu will be created
  + resource "hashicups_order" "edu" {
      + id           = (known after apply)
      + last_updated = (known after apply)

      + items {
          + quantity = 2

          + coffee {
              + description = (known after apply)
              + id          = 3
              + image       = (known after apply)
              + name        = (known after apply)
              + price       = (known after apply)
              + teaser      = (known after apply)
            }
        }
      + items {
          + quantity = 3

          + coffee {
              + description = (known after apply)
              + id          = 2
              + image       = (known after apply)
              + name        = (known after apply)
              + price       = (known after apply)
              + teaser      = (known after apply)
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + edu_order   = {
      + id           = (known after apply)
      + items        = [
          + {
              + coffee   = [
                  + {
                      + description = (known after apply)
                      + id          = 3
                      + image       = (known after apply)
                      + name        = (known after apply)
                      + price       = (known after apply)
                      + teaser      = (known after apply)
                    },
                ]
              + quantity = 2
            },
          + {
              + coffee   = [
                  + {
                      + description = (known after apply)
                      + id          = 2
                      + image       = (known after apply)
                      + name        = (known after apply)
                      + price       = (known after apply)
                      + teaser      = (known after apply)
                    },
                ]
              + quantity = 3
            },
        ]
      + last_updated = (known after apply)
    }
  + first_order = {
      + id    = 1
      + items = []
    }
  + order       = {
      + id    = 1
      + items = []
    }
  + psl         = {
      + "1" = {
          + description = ""
          + id          = 1
          + image       = "/packer.png"
          + ingredients = [
              + {
                  + ingredient_id = 1
                },
              + {
                  + ingredient_id = 2
                },
              + {
                  + ingredient_id = 4
                },
            ]
          + name        = "Packer Spiced Latte"
          + price       = 350
          + teaser      = "Packed with goodness to spice up your images"
        }
    }

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

hashicups_order.edu: Creating...
hashicups_order.edu: Creation complete after 0s [id=1]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

edu_order = {
  "id" = "1"
  "items" = tolist([
    {
      "coffee" = tolist([
        {
          "description" = ""
          "id" = 3
          "image" = "/nomad.png"
          "name" = "Nomadicano"
          "price" = 150
          "teaser" = "Drink one today and you will want to schedule another"
        },
      ])
      "quantity" = 2
    },
    {
      "coffee" = tolist([
        {
          "description" = ""
          "id" = 2
          "image" = "/vault.png"
          "name" = "Vaulatte"
          "price" = 200
          "teaser" = "Nothing gives you a safe and secure feeling like a Vaulatte"
        },
      ])
      "quantity" = 3
    },
  ])
  "last_updated" = tostring(null)
}
first_order = {
  "id" = 1
  "items" = tolist([])
}
order = {
  "id" = 1
  "items" = tolist([])
}
psl = {
  "1" = {
    "description" = ""
    "id" = 1
    "image" = "/packer.png"
    "ingredients" = tolist([
      {
        "ingredient_id" = 1
      },
      {
        "ingredient_id" = 2
      },
      {
        "ingredient_id" = 4
      },
    ])
    "name" = "Packer Spiced Latte"
    "price" = 350
    "teaser" = "Packed with goodness to spice up your images"
  }
}

```

7. Проверяем созданные ресурсы:

```bash
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ terraform state show hashicups_order.edu
# hashicups_order.edu:
resource "hashicups_order" "edu" {
    id = "1"

    items {
        quantity = 2

        coffee {
            id     = 3
            image  = "/nomad.png"
            name   = "Nomadicano"
            price  = 150
            teaser = "Drink one today and you will want to schedule another"
        }
    }
    items {
        quantity = 3

        coffee {
            id     = 2
            image  = "/vault.png"
            name   = "Vaulatte"
            price  = 200
            teaser = "Nothing gives you a safe and secure feeling like a Vaulatte"
        }
    }
}
```

и в другом виде:

```bash
aleksturbo@AlksTrbNoute:~/terraform-provider-hashicups/examples$ curl -X GET  -H "Authorization: ${HASHICUPS_TOKEN}" localhost:19090/orders/1 |jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   396  100   396    0     0  76625      0 --:--:-- --:--:-- --:--:-- 79200
{
  "id": 1,
  "items": [
    {
      "coffee": {
        "id": 3,
        "name": "Nomadicano",
        "teaser": "Drink one today and you will want to schedule another",
        "description": "",
        "price": 150,
        "image": "/nomad.png",
        "ingredients": null
      },
      "quantity": 2
    },
    {
      "coffee": {
        "id": 2,
        "name": "Vaulatte",
        "teaser": "Nothing gives you a safe and secure feeling like a Vaulatte",
        "description": "",
        "price": 200,
        "image": "/vault.png",
        "ingredients": null
      },
      "quantity": 3
    }
  ]
}
```


8. [Исходный код](https://github.com/AleksTurbo/devops-netology/tree/main/terraform/hw76)