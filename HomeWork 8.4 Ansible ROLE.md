# Домашнее задание к занятию "Ansible 8.4 - Работа с roles"

## Подготовка к выполнению

1. Познакомиться с lighthouse: готово.

2. Создаем два публичных репозитория:

  [Vector-role](https://github.com/AleksTurbo/vector-role)

  [Lighthouse-role](https://github.com/AleksTurbo/lighthouse-role)

3. Добавим публичную часть своего ключа к своему профилю в github: - готово.

## Основная часть

1. Создаем playbook requirements.yml с описанием применяемых ролей:

```ansible
- name: ansible-clickhouse
  src: https://github.com/AlexeySetevoi/ansible-clickhouse.git
  scm: git
  #version: 1.13
- name: vector_role
  src: https://github.com/AleksTurbo/vector-role.git
  scm: git
- name: lighthouse_role
  src: https://github.com/AleksTurbo/lighthouse-role.git
  scm: git
```

2. При помощи ansible-galaxy скачиваем себе эти роли:

```ansible
aleksturbo@AlksTrbNoute:~/ansible84$ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- ansible-clickhouse is already installed, skipping.
- vector_role is already installed, skipping.
- lighthouse_role is already installed, skipping.
```

3. Создадим новый каталог с ролью при помощи ansible-galaxy role init vector-role. - готово.
   И ansible-galaxy role init lighthouse_role. - готово.

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между vars и default. - готово.

5. Перенести нужные шаблоны конфигов в templates: - готово.

6. Описать в README.md обе роли и их параметры: - готово.

7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт: - готово.

8. Выложим все roles в репозитории. Добавим тэги, используя семантическую нумерацию Добавьте roles в requirements.yml в playbook:

[Vector-role](https://github.com/AleksTurbo/vector-role)

[Lighthouse-role](https://github.com/AleksTurbo/lighthouse-role)

requirements.yml:

```ansible
- name: ansible-clickhouse
  src: https://github.com/AlexeySetevoi/ansible-clickhouse.git
  scm: git
  #version: 1.13
- name: vector_role
  src: https://github.com/AleksTurbo/vector-role.git
  scm: git
- name: lighthouse_role
  src: https://github.com/AleksTurbo/lighthouse-role.git
  scm: git
```
9. Переработаем playbook на использование roles. С применением tasks: - готово

10. Итоговый playbook:

[Ansible 8.4 playbook](https://github.com/AleksTurbo/ansible84/blob/main/site.yml)

11. См. ссылки по тексту выше.
