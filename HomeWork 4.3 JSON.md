# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

###   Ошибки:
- 1 стр. для читаемости структуры переносить строки после фигурных скобок
- 1 стр. неэкранированный спецсимвол \
- 2 стр. отсутствовал пробел перед определением массива
- 5 стр. некорректное значение IP адреса
- 6 стр. отсутствовал разделитель запятая
- 9 стр. отсутствовали закрывающие кавычки у параметра, IP-адресс это не число - заключаем в кавычки

### Правильная структура:
```
{
    "info" : "Sample JSON output from our service",    
        "elements" : [                      
            { 
                "name" : "first",
                "type" : "server",
                "ip" : "71.75.71.75" 
            },                      
            { 
                "name" : "second",
                "type" : "proxy",
                "ip" : "71.78.22.43"  
            }
        ]
    }
``` 

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import os
import json
import yaml
import time
hostslist = ['drive.google.com', 'mail.google.com', 'google.com']
host_tmp = {}
readip={}
need_write=0

def check_services(hostslist):
	print ("---Read data.json")
	
	with open('data.json', 'r') as fp:
		readip=json.load(fp)

	print(readip['hostlist'])
	print ("---")

	for host in hostslist:
		tempip = ''
		ip = socket.gethostbyname(host)
		tempip = readip['hostlist'][host]
		print(host, tempip, ip)
		if tempip == ip:
			print("GOOD - IP is not changed")
			need_write=0
		else:
			print("ATETTION - IP is changed!")
			need_write=1
		host_tmp[host]= ip

	result={"hostlist": host_tmp}

	if need_write:=1:
		print("---Write data.json")
		print(json.dumps(result['hostlist']))
		with open('data.json', 'w') as fp:
			json.dump(result, fp)
		print("---Write data.yaml")
		print(yaml.dump(result['hostlist']))
		with open("data.yaml", "w") as fp_yaml:
				yaml.dump(result, fp_yaml, explicit_start=True, explicit_end=True)
			
	return result

while True:
	site_dict = check_services(hostslist )
	print(end='\n')
	time.sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
aleksturbo@AlksTrbNoute:~/json$ ./check-srv.py
---Read data.json
{'drive.google.com': '64.233.165.194', 'mail.google.com': '74.125.205.83', 'google.com': '74.125.131.101'}
---
drive.google.com 64.233.165.194 64.233.165.194
GOOD - IP is not changed
mail.google.com 74.125.205.83 74.125.205.19
ATETTION - IP is changed!
google.com 74.125.131.101 74.125.131.139
ATETTION - IP is changed!
---Write data.json
{"drive.google.com": "64.233.165.194", "mail.google.com": "74.125.205.19", "google.com": "74.125.131.139"}
---Write data.yaml
drive.google.com: 64.233.165.194
google.com: 74.125.131.139
mail.google.com: 74.125.205.19
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"hostlist": {"drive.google.com": "64.233.165.194", "mail.google.com": "74.125.205.18", "google.com": "74.125.131.138"}}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
hostlist:
  drive.google.com: 64.233.165.194
  google.com: 74.125.131.138
  mail.google.com: 74.125.205.18
...

```
