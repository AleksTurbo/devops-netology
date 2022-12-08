# Домашнее задание к занятию "Ansible 8.6 - Создание собственных модулей"

## Подготовка к выполнению

1. Создадим пустой публичных репозиторий : готово.

[my_own_collection](https://github.com/AleksTurbo/my_own_collection)

2. Скачаем репозиторий ansible: git clone https://github.com/ansible/ansible.git: готово.

3-9. Развернем env окружение python: готово

```bash
[aleksturbo@oracle ansible]$ . venv/bin/activate && . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info
writing lib/ansible_core.egg-info/PKG-INFO
writing dependency_links to lib/ansible_core.egg-info/dependency_links.txt
writing entry points to lib/ansible_core.egg-info/entry_points.txt
writing requirements to lib/ansible_core.egg-info/requires.txt
writing top-level names to lib/ansible_core.egg-info/top_level.txt
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
warning: no files found matching 'SYMLINK_CACHE.json'
warning: no previously-included files found matching 'docs/docsite/rst_warnings'
warning: no previously-included files found matching 'docs/docsite/rst/conf.py'
warning: no previously-included files found matching 'docs/docsite/rst/index.rst'
warning: no previously-included files found matching 'docs/docsite/rst/dev_guide/index.rst'
warning: no previously-included files matching '*' found under directory 'docs/docsite/_build'
warning: no previously-included files matching '*.pyc' found under directory 'docs/docsite/_extensions'
warning: no previously-included files matching '*.pyo' found under directory 'docs/docsite/_extensions'
warning: no files found matching '*.ps1' under directory 'lib/ansible/modules/windows'
warning: no files found matching '*.yml' under directory 'lib/ansible/modules'
warning: no files found matching 'validate-modules' under directory 'test/lib/ansible_test/_util/controller/sanity/validate-modules'
adding license file 'COPYING'
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'

Setting up Ansible to run out of checkout...

PATH=/home/aleksturbo/netology/ansible/bin:/home/aleksturbo/netology/ansible/venv/bin:/home/aleksturbo/.vscode-server/bin/6261075646f055b99068d3688932416f2346dd3b/bin/remote-cli:/home/aleksturbo/.local/bin:/home/aleksturbo/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
PYTHONPATH=/home/aleksturbo/netology/ansible/test/lib:/home/aleksturbo/netology/ansible/lib
MANPATH=/home/aleksturbo/netology/ansible/docs/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!

(venv) [aleksturbo@oracle ansible]$ 
```

## Основная часть

### Molecule

1-3. В виртуальном окружении создадим новый my_own_module.py файл и заполним кодом на выполнение задачи создания тестового файла с требуемым содержимым: готово

*[my_own_module.py](https://github.com/AleksTurbo/devops-netology/blob/main/ansible/86/my_own_module.py)
*[input.json](https://github.com/AleksTurbo/devops-netology/blob/main/ansible/86/input.json)

4. Протестируем локально:

```bash
(venv) [aleksturbo@oracle ansible]$ python -m ansible.modules.my_own_module input.json

{"changed": false, "filepath": "!testfolder/testfile", "message": "Create file: !testfolder/testfile", "invocation": {"module_args": {"path": "!testfolder", "filename": "testfile", "content": "TestContentls\n", "new": false}}}
```

5. Напишем single task playbook и используем module в нём:

```yml
---
- name: Test module
  hosts: localhost
  tasks:
    - name: Call my_own_module
      my_own_module:
        path: testfolder
        filename: testfile
        content: "TestContentls\n"
```

6. Проверьте через playbook на идемпотентность: готово

```bash
(venv) [aleksturbo@oracle ansible]$ ansible-playbook site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under
development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] *********************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [localhost]

TASK [Call my_own_module] **************************************************************************************************************************************************************
ok: [localhost]

PLAY RECAP *****************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Выйдите из виртуального окружения: готово

8-9. Инициализируем новую collection и перенесем в данную collection свой module в соответствующую директорию: готово

10-11. Single task playbook преобразуем в single task role и перенесем в collection. У role есть default всех параметров module.
      Создадим playbook для использования этой role: готово

* site.yml:
```yml
---
- name: Test module
  hosts: localhost
  roles:
    - myrole

- name: Show log  
  hosts: localhost
  tasks:
  - name: log_out
    debug:
      msg: "{{ log_out }}" 
```

```bash
[aleksturbo@oracle 86]$ ansible-playbook site.yml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] ***********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [localhost]

TASK [myrole : run my_own_module] ********************************************************************************************************************
ok: [localhost]

PLAY [Show log] **************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [localhost]

TASK [log_out] ***************************************************************************************************************************************
ok: [localhost] => {
    "msg": {
        "changed": false,
        "failed": false,
        "filepath": "/tmp/testfolder/testfile",
        "message": "Create file: /tmp/testfolder/testfile"
    }
}

PLAY RECAP *******************************************************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

12-13. Заполним всю документацию по collection, выложим в свой репозиторий.
        Создадим .tar.gz этой collection: ansible-galaxy collection build в корневой директории collection: готово.

```bash
[aleksturbo@oracle my_collection]$ ansible-galaxy collection build
Created collection for my_netology.my_collection at /home/aleksturbo/netology/86/collections/ansible_collections/my_netology/my_collection/my_netology-my_collection-1.0.0.tar.gz
```

14-16. Развернем коллекцию из архива и протестируем:

```bash
[aleksturbo@oracle 861]$ ansible-galaxy collection install my_netology-my_collection-1.0.0.tar.gz -p collections
Starting galaxy collection install process
[WARNING]: The specified collections path '/home/aleksturbo/netology/861/collections' is not part of the configured Ansible collections paths
'/home/aleksturbo/.ansible/collections:/usr/share/ansible/collections'. The installed collection won't be picked up in an Ansible run.
Process install dependency map
Starting collection install process
Installing 'my_netology.my_collection:1.0.0' to '/home/aleksturbo/netology/861/collections/ansible_collections/my_netology/my_collection'
my_netology.my_collection:1.0.0 was installed successfully
```

```bash
[aleksturbo@oracle 861]$ ansible-playbook site.yml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] *********************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [localhost]

TASK [myrole : run my_own_module] ******************************************************************************************************************************************************
ok: [localhost]

PLAY [Show log] ************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [localhost]

TASK [log_out] *************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": {
        "changed": false,
        "failed": false,
        "filepath": "/tmp/testfolder/testfile",
        "message": "Create file: /tmp/testfolder/testfile"
    }
}

PLAY RECAP *****************************************************************************************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

17. Cсылка на репозиторий с collection:

[my_own_collection](https://github.com/AleksTurbo/my_own_collection)