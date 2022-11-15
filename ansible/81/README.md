# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?

```bash
group_vars/all/examp.yml
```

2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

```bash
ansible-playbook -i inventory/test.yml site.yml
```

3. Какой командой можно зашифровать файл?

```bash
ansible-vault encrypt group_vars/deb/filename
```

4. Какой командой можно расшифровать файл?

```bash
ansible-vault decrypt --ask-vault-password group_vars/deb/filename
```

5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

```bash
ansible-vault view group_vars/deb/filename
```

6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

```bash
ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
```

7. Как называется модуль подключения к host на windows?

```bash
winrm
```

8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

```bash
ansible-doc -t connection ssh
```

9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?

```bash
- remote_user
        User name with which to login to the remote server, normally set by the remote_user keyword.
        If no user is supplied, Ansible will let the ssh client binary choose the user as it normally
        [Default: (null)]
        set_via:
          env:
          - name: ANSIBLE_REMOTE_USER
          ini:
          - key: remote_user
            section: defaults
          vars:
          - name: ansible_user
          - name: ansible_ssh_user
```
