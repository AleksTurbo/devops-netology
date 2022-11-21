# Домашнее задание к занятию "8.2 Работа с Playbook"

## Подготовка к выполнению

1. Изучите, что такое clickhouse и vector: готово.
2. Создаем репозиторий на github: <https://github.com/AleksTurbo/ansible82>
3. Скачайте playbook из репозитория с домашним заданием: - готово.
4. Подготовим хосты в соответствии с группами из предподготовленного playbook:

```yuml
version: '3.8'
services:
  clickhouse:
    image: pycontribs/ubuntu
    container_name: clickhouse
    restart: always
    tty: true

  vector:
    image: pycontribs/ubuntu
    container_name: vector
    restart: always
    tty: true
```

```bash
aleksturbo@AlksTrbNoute:~/ansible82$ docker ps
CONTAINER ID   IMAGE                           COMMAND        CREATED         STATUS         PORTS                                                      NAMES
1c1349b28815   pycontribs/ubuntu               "/bin/bash"    2 minutes ago   Up 2 minutes                                                              vector
6e1608512e16   pycontribs/ubuntu               "/bin/bash"    2 minutes ago   Up 2 minutes                                                              clickhouse
```

## Основная часть

1. Приготовим свой собственный inventory файл prod.yml:

```yuml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 192.168.153.118
vector:
  hosts:
    vector-01:
      ansible_host: 192.168.153.148
```

2. Допишем playbook: ещё один play, который устанавливает и настраивает vector:

```yuml
---
- name: Assert clickhouse role
  hosts: clickhouse
  roles:
    - ansible-clickhouse
- name: Assert VECTOR role
  hosts: vector
  roles:
    - vector_role
```

3. При создании tasks рекомендую использовать модули: get_url, template, unarchive, file. - применяем

4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector - готово

5. Запустим ansible-lint site.yml: остались незначительные

```yuml
aleksturbo@AlksTrbNoute:~/ansible82$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 16 violation(s) that are fatal
yaml: line too long (177 > 160 characters) (line-length)
roles/ansible-clickhouse/defaults/main.yml:76

yaml: too many spaces inside braces (braces)
roles/ansible-clickhouse/defaults/main.yml:76

yaml: line too long (173 > 160 characters) (line-length)
roles/ansible-clickhouse/defaults/main.yml:77

yaml: too many spaces inside braces (braces)
roles/ansible-clickhouse/defaults/main.yml:77

yaml: too many spaces inside braces (braces)
roles/ansible-clickhouse/defaults/main.yml:88

yaml: too many spaces inside braces (braces)
roles/ansible-clickhouse/defaults/main.yml:91

yaml: wrong indentation: expected 2 but found 1 (indentation)
roles/ansible-clickhouse/defaults/main.yml:91

yaml: line too long (209 > 160 characters) (line-length)
roles/ansible-clickhouse/tasks/configure/db.yml:3

yaml: trailing spaces (trailing-spaces)
roles/ansible-clickhouse/tasks/configure/dict.yml:10

yaml: trailing spaces (trailing-spaces)
roles/ansible-clickhouse/tasks/configure/sys.yml:74

risky-file-permissions: File permissions unset or incorrect
roles/ansible-clickhouse/tasks/install/apt.yml:45 Task/Handler: Hold specified version during APT upgrade | Package installation

yaml: trailing spaces (trailing-spaces)
roles/ansible-clickhouse/tasks/main.yml:32

meta-incorrect: Should change default metadata: author
roles/vector_role/meta/main.yml:1

meta-incorrect: Should change default metadata: company
roles/vector_role/meta/main.yml:1

meta-incorrect: Should change default metadata: license
roles/vector_role/meta/main.yml:1

meta-no-info: Role info should contain platforms
roles/vector_role/meta/main.yml:1

You can skip specific rules or tags by adding them to your configuration file:
# .ansible-lint
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental
  - meta-incorrect  # meta/main.yml default values should be changed
  - meta-no-info  # meta/main.yml should contain relevant info
  - yaml  # Violations reported by yamllint

Finished with 15 failure(s), 1 warning(s) on 32 files.
```

6. Попробуем запустить playbook на этом окружении с флагом --check

```bash
aleksturbo@AlksTrbNoute:~/ansible82$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Assert clickhouse role] ***********************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
[WARNING]: Platform linux on host clickhouse-01 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [clickhouse-01]

TASK [ansible-clickhouse : Include OS Family Specific Variables] ************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/precheck.yml for clickhouse-01

TASK [ansible-clickhouse : Requirements check | Checking sse4_2 support] ****************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Requirements check | Not supported distribution && release] **************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/params.yml for clickhouse-01

TASK [ansible-clickhouse : Set clickhouse_service_enable] *******************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Set clickhouse_service_ensure] *******************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/install/dnf.yml for clickhouse-01

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ****************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo installed] ***********************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***********************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (version 22.3.3.44)] ************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [ansible-clickhouse : Check clickhouse config, data and logs] **********************************************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
ok: [clickhouse-01] => (item=/etc/clickhouse-server)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [ansible-clickhouse : Config | Create config.d folder] *****************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Config | Create users.d folder] ******************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate system config] *****************************************************************************************************************
changed: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate users config] ******************************************************************************************************************
changed: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate remote_servers config] *********************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate macros config] *****************************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate zookeeper servers config] ******************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Notify Handlers Now] *****************************************************************************************************************************

RUNNING HANDLER [ansible-clickhouse : Restart Clickhouse Service] ***********************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/service.yml for clickhouse-01

TASK [ansible-clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] **************************************************************************
changed: [clickhouse-01]

TASK [ansible-clickhouse : Wait for Clickhouse Server to Become Ready] ******************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [ansible-clickhouse : Set ClickHose Connection String] *****************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Gather list of existing databases] ***************************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Delete database config] *****************************************************************************************************************

TASK [ansible-clickhouse : Config | Create database config] *****************************************************************************************************************

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [ansible-clickhouse : Config | Generate dictionary config] *************************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Assert VECTOR role] ***************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [vector-01]

TASK [vector_role : Vector| Install package] ********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/vector_role/tasks/install_yum.yml for vector-01

TASK [vector_role : Install Vector | YUM install] ***************************************************************************************************************************
ok: [vector-01]

TASK [vector_role : Vector | Configure vector] ******************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/vector_role/tasks/configure_vector.yml for vector-01

TASK [vector_role : Configure Vector | ensure what directory exists] ********************************************************************************************************
ok: [vector-01]

TASK [vector_role : Configure Vector | Template config] *********************************************************************************************************************
ok: [vector-01]

TASK [vector_role : Vector | Configure service] *****************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/vector_role/tasks/configure_service.yml for vector-01

TASK [vector_role : Configure Service | Template systemd unit] **************************************************************************************************************
ok: [vector-01]

PLAY RECAP ******************************************************************************************************************************************************************
clickhouse-01              : ok=22   changed=3    unreachable=0    failed=0    skipped=13   rescued=0    ignored=0   
vector-01                  : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

6. Запустим playbook на prod.yml окружении с флагом --diff

```bash
aleksturbo@AlksTrbNoute:~/ansible82$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Assert clickhouse role] ***********************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
[WARNING]: Platform linux on host clickhouse-01 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [clickhouse-01]

TASK [ansible-clickhouse : Include OS Family Specific Variables] ************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/precheck.yml for clickhouse-01

TASK [ansible-clickhouse : Requirements check | Checking sse4_2 support] ****************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Requirements check | Not supported distribution && release] **************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/params.yml for clickhouse-01

TASK [ansible-clickhouse : Set clickhouse_service_enable] *******************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Set clickhouse_service_ensure] *******************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/install/dnf.yml for clickhouse-01

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ****************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo installed] ***********************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***********************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (version 22.3.3.44)] ************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [ansible-clickhouse : Check clickhouse config, data and logs] **********************************************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
ok: [clickhouse-01] => (item=/etc/clickhouse-server)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [ansible-clickhouse : Config | Create config.d folder] *****************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Config | Create users.d folder] ******************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate system config] *****************************************************************************************************************
--- before: /etc/clickhouse-server/config.d/config.xml
+++ after: /home/aleksturbo/.ansible/tmp/ansible-local-1604b4saaikv/tmpjiba9xtj/config.j2
@@ -67,9 +67,9 @@
     <!-- Listen specified host. use :: (wildcard IPv6 address), if you want to accept connections both with IPv4 and IPv6 from everywhere. -->
     <!-- <listen_host>::</listen_host> -->
     <!-- Same for hosts with disabled ipv6: -->
-    <listen_host>0.0.0.0</listen_host>
-    <!-- <listen_host>::1</listen_host>
-    <listen_host>127.0.0.1</listen_host>-->
+    <!-- <listen_host>0.0.0.0</listen_host> -->
+    <listen_host>::1</listen_host>
+    <listen_host>127.0.0.1</listen_host>
 
     <max_connections>2048</max_connections>
     <keep_alive_timeout>3</keep_alive_timeout>

changed: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate users config] ******************************************************************************************************************
--- before: /etc/clickhouse-server/users.d/users.xml
+++ after: /home/aleksturbo/.ansible/tmp/ansible-local-1604b4saaikv/tmpun1ko361/users.j2
@@ -15,7 +15,7 @@
             <max_partitions_per_insert_block>100</max_partitions_per_insert_block>
         </default>
         <readonly>
-            <readonly>0</readonly>
+            <readonly>1</readonly>
         </readonly>
         <!-- Default profiles end. -->
     <!-- Custom profiles. -->
@@ -31,7 +31,6 @@
                 <networks incl="networks" replace="replace">
                 <ip>::1</ip>
                 <ip>127.0.0.1</ip>
-                               <ip>192.168.153.148</ip>
                 </networks>
         <profile>default</profile>
         <quota>default</quota>
@@ -42,41 +41,12 @@
                 <networks incl="networks" replace="replace">
                 <ip>::1</ip>
                 <ip>127.0.0.1</ip>
-                               <ip>192.168.153.148</ip>
                 </networks>
         <profile>readonly</profile>
         <quota>default</quota>
             </readonly>
         <!-- Custom users. -->
         </users>
-          
-          <logger>
-    <!-- Default users. -->
-            <!-- Default user for login if user not defined -->
-        <default>
-                <password>logger</password>
-                <networks incl="networks" replace="replace">
-                <ip>::1</ip>
-                <ip>127.0.0.1</ip>
-                               <ip>192.168.153.148</ip>
-                </networks>
-        <profile>default</profile>
-        <quota>default</quota>
-            </default>
-            <!-- Example of user with readonly access -->
-        <readonly>
-                <password></password>
-                <networks incl="networks" replace="replace">
-                <ip>::1</ip>
-                <ip>127.0.0.1</ip>
-                               <ip>192.168.153.148</ip>
-                </networks>
-        <profile>readonly</profile>
-        <quota>default</quota>
-            </readonly>
-        <!-- Custom users. -->
-        </logger>
-
 
     <!-- Quotas. -->
     <quotas>

changed: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate remote_servers config] *********************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate macros config] *****************************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Generate zookeeper servers config] ******************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : Notify Handlers Now] *****************************************************************************************************************************

RUNNING HANDLER [ansible-clickhouse : Restart Clickhouse Service] ***********************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/service.yml for clickhouse-01

TASK [ansible-clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] **************************************************************************
changed: [clickhouse-01]

TASK [ansible-clickhouse : Wait for Clickhouse Server to Become Ready] ******************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [ansible-clickhouse : Set ClickHose Connection String] *****************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Gather list of existing databases] ***************************************************************************************************************
ok: [clickhouse-01]

TASK [ansible-clickhouse : Config | Delete database config] *****************************************************************************************************************

TASK [ansible-clickhouse : Config | Create database config] *****************************************************************************************************************

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/ansible-clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [ansible-clickhouse : Config | Generate dictionary config] *************************************************************************************************************
skipping: [clickhouse-01]

TASK [ansible-clickhouse : include_tasks] ***********************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Assert VECTOR role] ***************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [vector-01]

TASK [vector_role : Vector| Install package] ********************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/vector_role/tasks/install_yum.yml for vector-01

TASK [vector_role : Install Vector | YUM install] ***************************************************************************************************************************
ok: [vector-01]

TASK [vector_role : Vector | Configure vector] ******************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/vector_role/tasks/configure_vector.yml for vector-01

TASK [vector_role : Configure Vector | ensure what directory exists] ********************************************************************************************************
ok: [vector-01]

TASK [vector_role : Configure Vector | Template config] *********************************************************************************************************************
ok: [vector-01]

TASK [vector_role : Vector | Configure service] *****************************************************************************************************************************
included: /home/aleksturbo/ansible82/roles/vector_role/tasks/configure_service.yml for vector-01

TASK [vector_role : Configure Service | Template systemd unit] **************************************************************************************************************
ok: [vector-01]

PLAY RECAP ******************************************************************************************************************************************************************
clickhouse-01              : ok=25   changed=3    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
vector-01                  : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Повторно запустим playbook с флагом --diff и убедимся, что playbook идемпотентен:

```bash
aleksturbo@AlksTrbNoute:~/ansible82$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Assert clickhouse role] ***********************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
[WARNING]: Platform linux on host clickhouse-01 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [clickhouse-01]
...
...
...

PLAY RECAP ******************************************************************************************************************************************************************
clickhouse-01              : ok=24   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
vector-01                  : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

9. Не успеваю

10. Ссылка на репозиторий: 
<https://github.com/AleksTurbo/ansible82>
