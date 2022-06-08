# devops-netology
devops-netology
aleksturbo
aleksturbo@yandex.ru

HomeWork 04.06.2022: bash

1. Установлено на windows 10.
2. Установлено.
3. Работаю через VSCode и встроенный терминал.
4. bento/ubuntu-20.04 - скачал при помощи ВПН. vagrant up - виртуалка запущена.
5. RAM 1024, CPU 2, HDD 64Gb
6. Vagrant.configure("2") do |config|
    servers=[
        {
          :box => "bento/ubuntu-20.04",
          :hostname => "terminal"
        }
      ]
    servers.each do |machine|
      config.vm.define machine[:hostname] do |node|
        node.vm.box = machine[:box]
        node.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", 2048]
            vb.customize ["modifyvm", :id, "--cpus", 2]
        end
      end
    end
  end
7. vagrant ssh - успешно подключился
8. HISTFILESIZE - 603 строка, export HISTCONTROL=ignoreboth -  не сохранять строки начинающиеся с символа <пробел> и 
	не сохранять строки, совпадающие с последней выполненной командой.
9. 135 RESERVED WORDS {} - список,массив - используется в различных условных циклах, условных операторах, или ограничивает тело функции
10.  touch file-{000001..87283}.txt - получилось создать только 87283 фаила
     В WSL получилось создать touch file-{00001..91054}.txt  файлов
     при большем числе: -bash: /usr/bin/touch: Слишком длинный список аргументов 
12.  конструкция [[ -d /tmp ]] проверяет наличие каталога tmp
     Пример использования в скриптах: if [[ -d /tmp ]]; then echo "dir 'tmp' is exist"; else echo "dir 'tmp' not exist"; fi
14.     cd /tmp
	mkdir new_path_directory 
	cp -p /bin/bash /tmp/new_path_directory/bash
	PATH=/tmp/new_path_directory:$PATH
	cd new_path_directory
	type -a bash
	Вывод:
	bash является /tmp/new_path_directory/bash
	bash является /usr/bin/bash
	bash является /bin/bash 
13. at - команда запускается в указанное время без учета загрузки системы
    batch - запускается при низкой загрузке системы
14. exit
    vagrant suspend
	
	
	

