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
6. config.vm.provider "virtualbox" do |v|
  	v.memory = 2048
 	 v.cpus = 4
	end
7. vagrant ssh - успешно подключился
8. HISTFILESIZE - 603 строка, export HISTCONTROL=ignoreboth -  не сохранять строки начинающиеся с символа <пробел> и 
	не сохранять строки, совпадающие с последней выполненной командой.
9. 135 RESERVED WORDS {} - список,массив - используется в различных условных циклах, условных операторах, или ограничивает тело функции
10.  touch file-{000001..87283}.txt - получилось создать только 87283 фаила

