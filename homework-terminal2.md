1. type cd  - (cd — это встроенная команда bash). #Логично, что команда CD встроенная для оболочки bash - перемещение по папкам является одной из базовых инструментов для любой оболочки в любой операционной системе.
2. grep aaaa testfile | wc -l (#Подсчет подстрочек аааа в файле testfile) - можно заменить командой grep aaaa testfile -c
3. pstree -p  - #(systemd родитель всех дочерних процессов в ОС Ubuntu)
    vagrant@vagrant:~$ pstree -p
    systemd(1)─┬─VBoxService(815)─┬─{VBoxService}(817)
               │                  ├─{VBoxService}(818)
               │                  ├─{VBoxService}(819)

4. ls -l /temp 2>/dev/pts/1 (#получим ошибку при попытке просмотра несуществующего каталога)
5. cat < testfile > testfile.out
6. who - определяем текущее устройство, 
    команда перенаправления cat /dev/pts/0 > /dev/tty2
7. bash 5>&1 перенаправляет stdout в файловый дискриптор 5
    aleksturbo@AlksTrbNout:~$ bash 5>&1
    aleksturbo@AlksTrbNout:~$ cat /proc/$$/fd/5
    test                    (отправили строку)
    test                    (получили строку)
    test mesage             (отправили строку)
    test mesage             (получили строку)
8. bash 5>&1 
    vagrant@vagrant:~$ ls -l /temp 5>&2 2>&1 1>&5 |grep No (#перенаправляем выводы через временный файловый дискриптор)
    ls: cannot access '/temp': No such file or directory (#результат команды)
9. cat /proc/$$/environ #Вывод переменных окружения
    env #короткая команда
10. man proc #справка про команде - виртуальная папка в файловой системе - содержит информацию по запущенным процессам:
    cat /proc/201/cmdline  #получение полной строки запуска процесса - 203 строка
        /init
    ls -la /proc/201/exe  #ссылка на запускаемый файл - 258 строка
        lrwxrwxrwx 1 root root 0 июн  9 21:14 /proc/201/exe -> /init 
11. grep sse /proc/cpuinfo
    sse4_2 #максимальная поддерживаемая версия SSE
12. ssh -t localhost 'tty' # -t команда исполняется c принудительным созданием псевдотерминала   
13. дополнительная утилита reptyr # перенесет процесс из консоли без screen в screen для последующего закрытия консоли
    reptyr -l|-L [COMMAND [ARGS]]
    reptyr <PID of running process to attach>
14. tee #команда tee linux принимает данные из одного источника и может сохранять их на выходе в нескольких местах.
    vagrant@vagrant:~$ sudo echo string > /root/new_file
    -bash: /root/new_file: Permission denied  (#получаем ошибку, т.к. echo встроенная команда оболочки и не срабатывает применение к ней повышения прав sudo)
    vagrant@vagrant:~$ echo string | sudo tee /root/new_file
    string (#строка выводится, т.к. tee запускается при помощи sudo)
