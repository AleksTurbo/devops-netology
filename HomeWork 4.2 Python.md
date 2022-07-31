# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Вывод ошибки интерпритатора: TypeError: unsupported operand type(s) for +: 'int' and 'str' - операция не поддерживается над переменными разного типа  |

Как получить для переменной `c` значение 12? :

```python  
#!/usr/bin/env python3
a = 1
b = '2'
c = str(a) + b
print(c) 
```

Как получить для переменной `c` значение 3? 
```python  
#!/usr/bin/env python3
a = 1
b = '2'
c = a + int(b)
print(c)

```

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
gitrep="~/netology/sysadm-homeworks"
bash_command = [f"cd {gitrep}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#print(result_os)
print("--Изменены следующие файлы :")
for resultstr in result_os.split('\n'):
	if resultstr.find('изменено') != -1:
		resultfile = resultstr.replace('изменено:',gitrep)
		print(resultfile)
```

### Вывод скрипта при запуске при тестировании:
```
aleksturbo@AlksTrbNoute:~/python$ ./script2.py
--Изменены следующие файлы :
        ~/netology/sysadm-homeworks      04-script-01-bash/README.md
        ~/netology/sysadm-homeworks      04-script-02-py/README.md
        ~/netology/sysadm-homeworks      README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
import sys

#gitrep="~/netology/sysadm-homeworks"
gitrep=""

try:
    gitrep = sys.argv[1]
except:
    print("Incorrect path to repository")

if gitrep != "":
	bash_command = [f"cd {gitrep}", "git status"]
	
	#print(result_os)
	check_git = os.listdir(gitrep);
	if check_git.__contains__(".git"):
		result_os = os.popen(' && '.join(bash_command)).read()
		print("--Изменены следующие файлы :")
		for resultstr in result_os.split('\n'):
			if resultstr.find('изменено') != -1:
				resultfile = resultstr.replace('изменено:',gitrep)
				print(resultfile)
	else:
		print(gitrep ," - is no git repository")
```

### Вывод скрипта при запуске при тестировании:
```
aleksturbo@AlksTrbNoute:~/python$ ./script3.py ~/netology
/home/aleksturbo/netology  - is no git repository

aleksturbo@AlksTrbNoute:~/python$ ./script3.py ~/netology/sysadm-homeworks
--Изменены следующие файлы :
        /home/aleksturbo/netology/sysadm-homeworks      04-script-01-bash/README.md
        /home/aleksturbo/netology/sysadm-homeworks      04-script-02-py/README.md
        /home/aleksturbo/netology/sysadm-homeworks      README.md
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import os
from string import whitespace

hosts = ["drive.google.com", "mail.google.com", "google.com"]
safehost = []

with open('hostlist') as file:
    for f in file:
        safehost.append(f)

with open('hostlist', 'w+') as file:
    for i in hosts:
        result = socket.gethostbyname(i)
        needadded = 0
        for j in safehost:
            inList = j.find(" {}".format(i))
            if (inList != -1):
                ipadr=j.replace('\n', '').split("  ")[1].translate({None: whitespace})
                if (ipadr == result):
                    print(" {}  {}\n".format(i, result))
                    file.write(" {}  {}\n".format(i, result))
                    needadded = 1
                    break
                else:
                    print("Attention! {} IP address is change: {}  {}\n".format(i, ipadr, result))
                    file.write("Attention! {} IP address is change: {}  {}\n".format(i, ipadr, result))
                    needadded = 1
                    break
        if (needadded == 0):
            print(" {}  {}\n".format(i, result))
            file.write(" {}  {}\n".format(i, result))
```

### Вывод скрипта при запуске при тестировании:
```
aleksturbo@AlksTrbNoute:~/python$ ./script4.py
Attention! drive.google.com IP address is change: 108.177.14.194  173.194.222.194
Attention! mail.google.com IP address is change: 173.194.221.83  173.194.221.17
Attention! google.com IP address is change: 74.125.205.100  74.125.205.113
```
