# Домашнее задание к занятию "7.1 IaC"

## Задача 1

- Определяемся с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?

```bash
Неизменяемый.
```

2. Будет ли центральный сервер для управления инфраструктурой?

```bash
Выделенный сервер не планируется. Управление будет выполняться посредством Terraform/Ansible и Git.
```

3. Будут ли агенты на серверах?

```bash
Агенты применяться не будут. Используем agentless Ansible.
```

4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?

```bash
Да. Terraform/Ansible.
```

- Для проекта планирую использовать следующие инструменты:

```bash
Terraform, Ansible, Packer, Docker, Kubernetes
```

- Из новых инструментов предлагаю добавить:

```bash
GitLab CI/CD
```

## Задача 2

- Устанавливаем Terraform:

- Устанавливаем по официальной инструкции:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

```bash
aleksturbo@AlksTrbNoute:~$ sudo apt update && sudo apt install terraform
Get:1 https://download.docker.com/linux/ubuntu bionic InRelease [64.4 kB]
Get:2 https://apt.releases.hashicorp.com jammy InRelease [11.1 kB]
Hit:3 http://archive.ubuntu.com/ubuntu jammy InRelease
...
The following packages will be upgraded:
  terraform
1 upgraded, 0 newly installed, 0 to remove and 107 not upgraded.
2 not fully installed or removed.
Need to get 19.5 MB of archives.
After this operation, 1729 kB disk space will be freed.
Get:1 https://apt.releases.hashicorp.com jammy/main amd64 terraform amd64 1.3.2 [19.5 MB]
Fetched 19.5 MB in 15s (1323 kB/s)
(Reading database ... 80309 files and directories currently installed.)
Preparing to unpack .../terraform_1.3.2_amd64.deb ...
Unpacking terraform (1.3.2) over (1.2.8) ...

aleksturbo@AlksTrbNoute:~$ terraform --version
Terraform v1.3.2
on linux_amd64

```

## Задача 3

- Добавляем поддержку легаси версии terraform 0.12:

```bash
root@AlksTrbNoute:~# mkdir -p /usr/local/tf
root@AlksTrbNoute:~# mkdir -p /usr/local/tf/12
root@AlksTrbNoute:~# cd /usr/local/tf/12

root@AlksTrbNoute:/usr/local/tf/12# wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
--2022-10-09 20:03:17--  https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
Resolving releases.hashicorp.com (releases.hashicorp.com)... 65.9.181.88, 65.9.181.53, 65.9.181.109, ...
Connecting to releases.hashicorp.com (releases.hashicorp.com)|65.9.181.88|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16207833 (15M) [application/zip]
Saving to: ‘terraform_0.12.20_linux_amd64.zip’
terraform_0.12.20_linux_amd64.zip            100%[==============================================================>]  15.46M  1.99MB/s    in 13s
2022-10-09 20:03:32 (1.16 MB/s) - ‘terraform_0.12.20_linux_amd64.zip’ saved [16207833/16207833]

root@AlksTrbNoute:/usr/local/tf/12# unzip terraform_0.12.20_linux_amd64.zip
Archive:  terraform_0.12.20_linux_amd64.zip
  inflating: terraform
root@AlksTrbNoute:/usr/local/tf/12# rm terraform_0.12.20_linux_amd64.zip
root@AlksTrbNoute:/usr/local/tf/12# ln -s /usr/local/tf/12/terraform /usr/bin/terraform12
root@AlksTrbNoute:/usr/local/tf/12# chmod ugo+x /usr/bin/terraform*
root@AlksTrbNoute:~# terraform12 -v
Terraform v0.12.20
Your version of Terraform is out of date! The latest version
is 1.3.2. You can update by downloading from https://www.terraform.io/downloads.html
root@AlksTrbNoute:~# terraform -v
Terraform v1.3.2
on linux_amd64
```
