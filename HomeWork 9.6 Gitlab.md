# Домашнее задание к занятию "9.6 (12) Gitlab""

## Подготовка к выполнению

1-6. Подготавливаем GitLab: готово

<img src="img/HW 9.6 GitLab.png"/>

## Основная часть

### DevOps

1-6. Автоматизируем сборку образа с выполнением python-скрипта: готово

<img src="img/HW 9.6 GitLab PipeLineEditor.png"/>

<img src="img/HW 9.6 GitLab registry.png"/>

7. :-( Еще разбираюсь с этим

### Product Owner

1-3. Issues доработка: необходимо поменять JSON ответа на вызов метода GET: готово

<img src="img/HW 9.6 GitLab Issues.png"/>

### Developer

1-3. Merge Requst: готово

<img src="img/HW 9.6 GitLab MergeReq.png"/>

### Tester

1-2. Проверим валидность изменений:

```bash
[aleksturbo@oracle 96]$ docker run -it --privileged=True registry.gitlab.com/aleksturbo/netology:latest
 * Serving Flask app 'python-api' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://172.17.0.3:5290/ (Press CTRL+C to quit)
172.17.0.1 - - [13/Jan/2023 13:42:18] "GET /get_info HTTP/1.1" 200 -
```

```bash
[aleksturbo@oracle 96]$ curl http://172.17.0.3:5290/get_info
{"version": 3, "method": "GET", "message": "Already started"}

[aleksturbo@oracle 96]$ curl http://172.17.0.3:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}

```

## Итог

### Links:

[gitlab-ci.yml](https://gitlab.com/AleksTurbo/netology/-/blob/main/.gitlab-ci.yml)

[Dockerfile](https://gitlab.com/AleksTurbo/netology/-/blob/main/Dockerfile)

[Лог успешного выполнения пайплайна](https://gitlab.com/AleksTurbo/netology/-/jobs/3600154466)

Решенный Issue:

<img src="img/HW 9.6 GitLab IssuesClose.png"/>
