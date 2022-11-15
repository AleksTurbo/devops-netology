# Домашнее задание к занятию "8.1 Введение в Ansible"

## Подготовка к выполнению

1. Установим ansible:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/aleksturbo/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.6 (main, Aug 10 2022, 11:40:04) [GCC 11.3.0]
```

2. Создаем репозиторий на github для Ansible:
[Ansible 8.1](https://github.com/AleksTurbo/ansible81)


3. Копируем playbook из репозитория с домашним заданием в свой репозиторий: - готово

## Основная часть

1. Запускаем playbook на окружении из test.yml:

```
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/test.yml site.yml
PLAY [Print os facts] **********************************************************
TASK [Gathering Facts] ***************************************************************
ok: [localhost]
TASK [Print OS] ***************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
TASK [Print version] ********************************************************************
ok: [localhost] => {
    "msg": "2.10.8"
}
TASK [Print fact] **********************************************************************
ok: [localhost] => {
    "msg": 12
}
PLAY RECAP ******************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

some_fact  = 12

2. Изменяем значение переменных:

```
aleksturbo@AlksTrbNoute:~/ansible81$ cat group_vars/all/examp.yml
---
  some_fact: all default fact
```

3. Создаем окружение для проведения дальнейших испытаний:

```yuml
docker-compose.yml

version: '3.8'
services:
  centos7:
    image: pycontribs/centos:7
    container_name: centos7
    restart: always
    tty: true

  ubuntu:
    image: pycontribs/ubuntu
    container_name: ubuntu
    restart: always
    tty: true
```

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ docker ps
CONTAINER ID   IMAGE                           COMMAND        CREATED          STATUS          PORTS                                                      NAMES
dfb908a82862   pycontribs/centos:7             "/bin/bash"    25 minutes ago   Up 25 minutes                                                              centos7
d25eb54c17bb   pycontribs/ubuntu               "/bin/bash"    25 minutes ago   Up 25 minutes                                                              ubuntu
```

4. Запустим playbook на окружении из prod.yml:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *******************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************

ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print version] *********************************************************************************************************
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}

TASK [Print fact] ***********************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *****************************************************************************************************************
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

5. Изменяем значения переменных group_vars:

```Bash
aleksturbo@AlksTrbNoute:~/ansible81$ cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
  aleksturbo@AlksTrbNoute:~/ansible81$ cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
```

6. Повторяем запуск playbook на окружении prod.yml с измененными переменными: 

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************

ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print version] ***************************************************************************************************
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}

TASK [Print fact] *******************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ****************************************************************************************************************
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Шифруем факты в group_vars/deb и group_vars/el

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

8. Запустите playbook на окружении prod.yml с шифрованным окружением:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml
PLAY [Print os facts] ********************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found


aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 
PLAY [Print os facts] ********************************************************************************************
TASK [Gathering Facts] *******************************************************************************************
ok: [ubuntu]
ok: [centos7]
TASK [Print OS] **************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
TASK [Print version] **********************************************************************************************
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}
TASK [Print fact] **************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
PLAY RECAP **********************************************************************************************************
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

9. Список плагинов для подключения:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-doc -t connection -l
ansible.netcommon.httpapi      Use httpapi to run command on network appliances
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection
ansible.netcommon.napalm       Provides persistent connection using NAPALM
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
ansible.netcommon.network_cli  Use network_cli to run command on network appliances
ansible.netcommon.persistent   Use a persistent unix socket for connection
community.aws.aws_ssm          execute via AWS Systems Manager
community.docker.docker        Run tasks in docker containers
community.docker.docker_api    Run tasks in docker containers
community.general.chroot       Interact with local chroot
community.general.docker       Run tasks in docker containers
community.general.funcd        Use funcd to connect to target
community.general.iocage       Run tasks in iocage jails
community.general.jail         Run tasks in jails
community.general.lxc          Run tasks in lxc containers via lxc python library
community.general.lxd          Run tasks in lxc containers via lxc CLI
community.general.oc           Execute tasks in pods running on OpenShift
community.general.qubes        Interact with an existing QubesOS AppVM
community.general.saltstack    Allow ansible to piggyback on salt minions
community.general.zone         Run tasks in a zone instance
community.kubernetes.kubectl   Execute tasks in pods running on Kubernetes
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
community.okd.oc               Execute tasks in pods running on OpenShift
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
containers.podman.buildah      Interact with an existing buildah container
containers.podman.podman       Interact with an existing podman container
local                          execute on controller
paramiko_ssh                   Run tasks via python ssh (paramiko)
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
ssh                            connect via ssh client binary
winrm                          Run tasks over Microsoft's WinRM 
```

требуются модули:
* community.docker.docker
* local

10. В prod.yml добавляем новую группу хостов с именем local:

```yuml
aleksturbo@AlksTrbNoute:~/ansible81$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11. Запускаем playbook на окружении prod.yml:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] 

TASK [Gathering Facts] 
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] 
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print version] 
ok: [localhost] => {
    "msg": "2.10.8"
}
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}

TASK [Print fact] 
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP 
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## Дополнительная часть

1. Расшифруем все зашифрованные файлы:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-vault decrypt --ask-vault-password group_vars/deb/* group_vars/el/*
Vault password: 
Decryption successful

aleksturbo@AlksTrbNoute:~/ansible81$ cat group_vars/deb/examp.yml 
---
  some_fact: "deb default fact"
```

2. Зашифруем отдельное значение PaSSw0rd для переменной some_fact:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-vault encrypt_string "PaSSw0rd"d"
New Vault password: 
Confirm New Vault password: 
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          31613632666362636131626265386332663937633138663365316166386435383033326465323262
          3663346333306532326362366434366664613961666133370a383238643331343866353338306632
          37366636376639396637613363343233306131323739326637343766643334643062343362346136
          3036613439616361340a396634623631636365313162313036326264376235623564366430613131
          3062
Encryption successful

aleksturbo@AlksTrbNoute:~/ansible81$ cat group_vars/all/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          31613632666362636131626265386332663937633138663365316166386435383033326465323262
          3663346333306532326362366434366664613961666133370a383238643331343866353338306632
          37366636376639396637613363343233306131323739326637343766643334643062343362346136
          3036613439616361340a396634623631636365313162313036326264376235623564366430613131
          3062
```

3. Запустим playbook с новым fact:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] 

TASK [Gathering Facts] 
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] 
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print version] 
ok: [localhost] => {
    "msg": "2.10.8"
}
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}

TASK [Print fact] 
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP 
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

4. Добавим группу хостов fedora и fact для нее

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] 

TASK [Gathering Facts] 
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] 
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print version] 
ok: [localhost] => {
    "msg": "2.10.8"
}
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}
ok: [fedora] => {
    "msg": "2.10.8"
}

TASK [Print fact] 
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fed default fact"
}

PLAY RECAP 
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

5. Напишем скрипт на bash: автоматизируем поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров:

```bash
aleksturbo@AlksTrbNoute:~/ansible81$ ./script.sh
+ echo '****STARTING***'
****STARTING***
+ docker-compose up -d
[+] Running 4/4
 ⠿ Network ansible81_default  Created          0.8s
 ⠿ Container fedora           Started          3.5s
 ⠿ Container centos7          Started           4.2s
 ⠿ Container ubuntu           Started           4.2s
+ echo '****DOCKER STARTING***'
****DOCKER STARTING***
+ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] 

TASK [Gathering Facts] 
ok: [fedora]
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] 
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print version] 
ok: [localhost] => {
    "msg": "2.10.8"
}
ok: [centos7] => {
    "msg": "2.10.8"
}
ok: [ubuntu] => {
    "msg": "2.10.8"
}
ok: [fedora] => {
    "msg": "2.10.8"
}

TASK [Print fact] 
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fed default fact"
}

PLAY RECAP 
centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

+ echo '****ANSIBLE WORKING***'
****ANSIBLE WORKING***
+ docker-compose down -t 1
[+] Running 4/4
 ⠿ Container fedora           Removed                                                                                                                                                                                      0.5s
 ⠿ Container centos7          Removed                                                                                                                                                                                      1.6s
 ⠿ Container ubuntu           Removed                                                                                                                                                                                      0.7s
 ⠿ Network ansible81_default  Removed                                                                                                                                                                                      0.7s
+ echo '****DOCKER STOPING***'
****DOCKER STOPING***
```