1. aleksturbo@AlksTrbNout:/tmp$ strace /bin/bash -c 'cd /tmp' # запрос. Искомый вызов: chdir("/tmp")  
  #      newfstatat(AT_FDCWD, "/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}, 0) = 0
  # ==>  chdir("/tmp")                           = 0  - переход в директорию
  #      rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
2.    strace file /dev/tty # запрос. Искомая база данных: /usr/share/misc/magic.mgc
  #     newfstatat(AT_FDCWD, "/home/aleksturbo/.magic.mgc", 0x7ffe3e5cb410, 0) = -1 ENOENT (Нет такого файла или каталога)
  #     newfstatat(AT_FDCWD, "/home/aleksturbo/.magic", 0x7ffe3e5cb410, 0) = -1 ENOENT (Нет такого файла или каталога)
  #     openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (Нет такого файла или каталога)
  #     newfstatat(AT_FDCWD, "/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}, 0) = 0
  #     openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
  # ==> openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
  #     newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=7248904, ...}, AT_EMPTY_PATH) = 0
3.  for ((;;)); do echo "+"; sleep 1; done >> testfile+  # генерируем постоянный приток данных в файл testfile+ 
    tail -f testfile+ #мониторим генерацию
    ls -la # убеждаемся в наличии файла testfile+ и увеличение его размера
    rm testfile+ # удаляем файл
    lsof |grep testfile+ # смотрим процессы использующие файл
    lsof |grep testfile+
       # bash      1349                        vagrant    1w      REG              253,0       42    1048611 /home/vagrant/testfile+ (deleted)
       # tail      1550                        vagrant    3r      REG              253,0       42    1048611 /home/vagrant/testfile+ (deleted)
       # sleep     2031                        vagrant    1w      REG              253,0       42    1048611 /home/vagrant/testfile+ (deleted)
    cat /dev/null > /proc/1349/fd/1 # обрезаем файл
4. Зомби процессы Linux не выполняются и убить их нельзя. Выделенная ему память и ресурсы были освобождены при завершении работы. Просто родитель не получил об этом информации и удерживает запись. При этом зомби не освобождают запись в таблице процессов. Запись освободиться при вызове wait() родительским процессом. 
    ps aux | grep defunct
5. root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
   root@vagrant:~# /usr/sbin/opensnoop-bpfcc
    PID    COMM               FD ERR PATH
    377    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
    377    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
    845    vminfo              5   0 /var/run/utmp
    633    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    633    dbus-daemon        21   0 /usr/share/dbus-1/system-services
    633    dbus-daemon        -1   2 /lib/dbus-1/system-services
    633    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
    639    irqbalance          6   0 /proc/interrupts
    639    irqbalance          6   0 /proc/stat
6. strace uname -a
    # ==> uname({sysname="Linux", nodename="vagrant", ...}) = 0 # Вызов uname()
    man uname # uname - print certain system information.
7.  && - оператор условный, команда после символов выполнится при успешном выполении предыдущей команды:
      root@vagrant:~# test -d ~/.ssh
      root@vagrant:~# echo $?
      0
      root@vagrant:~# test -d ~/.sss
      root@vagrant:~# echo $?
      1
      root@vagrant:~# test -d ~/.ssh && echo Hi
      Hi
      root@vagrant:~# test -d /tmp/some_dir && echo Hi
    ; - просто разделитель команд для формирования в одну строку.
    set -e - немедленный выход при выполнении команды с ненулевым результатом,
    Смысл от применения && есть, т.к. если будет нулевой результат выполнения команды до &&, то выполнение продолжится. В некоторых случаях пригодится.
8.  set -euxo pipefail соединенные флаги выполнения bash скрипта:
      set -e            # скрипт немедленно завершит работу, если любая команда выйдет с ошибкой.
      set -u            # проверяет инициализацию переменных в скрипте. Если переменной не будет, скрипт немедленно завершиться. 
      set -o pipefail   # возвращает код возврата команды, ненулевой при последней команды или 0 для успешного выполнения команд
      set -x            # печатать в стандартный вывод все команды перед их исполнением.

      Полезно для детального вывода ошибок(логирования) и завершит скрипт при наличии ошибок на любом этапе выполнения, кроме последней завершающей команды.
9.  root@vagrant:~# ps -o stat
          STAT
          S
          S
          R+
          root@vagrant:~# ps
              PID TTY          TIME CMD
            1313 pts/0    00:00:00 sudo
            1315 pts/0    00:00:00 bash
            1486 pts/0    00:00:00 ps
          root@vagrant:~# ps aux
          USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
          root           1  0.2  0.5 167440 11396 ?        Ss   17:32   0:04 /sbin/init
          root           2  0.0  0.0      0     0 ?        S    17:32   0:00 [kthreadd]
          root           3  0.0  0.0      0     0 ?        I<   17:32   0:00 [rcu_gp]
          root           4  0.0  0.0      0     0 ?        I<   17:32   0:00 [rcu_par_gp]
          root           6  0.0  0.0      0     0 ?        I<   17:32   0:00 [kworker/0:0H-kblockd]
          root           8  0.0  0.0      0     0 ?        I<   17:32   0:00 [mm_percpu_wq]
          root           9  0.0  0.0      0     0 ?        S    17:32   0:00 [ksoftirqd/0]
          root          10  0.0  0.0      0     0 ?        I    17:32   0:00 [rcu_sched]
          root          11  0.0  0.0      0     0 ?        S    17:32   0:00 [migration/0]
          root          12  0.0  0.0      0     0 ?        S    17:32   0:00 [idle_inject/0]
          root          14  0.0  0.0      0     0 ?        S    17:32   0:00 [cpuhp/0]
          root          15  0.0  0.0      0     0 ?        S    17:32   0:00 [cpuhp/1]
          root          16  0.0  0.0      0     0 ?        S    17:32   0:00 [idle_inject/1]
          root          17  0.0  0.0      0     0 ?        S    17:32   0:00 [migration/1]
          root          18  0.0  0.0      0     0 ?        S    17:32   0:00 [ksoftirqd/1]

          Наиболее часто встречающийся  STAT (статус процесса) - S    interruptible sleep (waiting for an event to complete)
          Дополнительные признаки означают:
               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
