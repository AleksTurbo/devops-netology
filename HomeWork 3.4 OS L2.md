1. sudo nano /etc/systemd/system/node_exporter.service
            [Unit]
            Description=Node Exporter Service
            After=network.target

            [Service]
            User=node_exporter
            Group=node_exporter
            Type=simple
            EnvironmentFile=/etc/node_exporter
            ExecStart=/usr/local/bin/node_exporter $EXT_OPTS

            [Install]
            WantedBy=multi-user.target

    sudo nano /etc/node_exporter
        EXTRA_OPTS="--collector.disable-defaults --collector.cpu --collector.meminfo --collector.filesystem --collector.netdev"
    wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
    tar zxvf node_exporter-*.linux-amd64.tar.gz
    cd node_exporter-*.linux-amd64
    sudo cp node_exporter /usr/local/bin/

    sudo useradd --no-create-home --shell /bin/false node_exporter
    sudo chown -R node_exporter:node_exporter /usr/local/bin/node_exporter

    systemctl daemon-reload
    systemctl enable node_exporter
    systemctl start node_exporter
    systemctl stop node_exporter
    systemctl status node_exporter

2.  curl localhost:9100/metrics |grep node_cpu 
    curl localhost:9100/metrics |grep node_memory
    curl localhost:9100/metrics |grep node_disk
    curl localhost:9100/metrics |grep node_network

3.  sudo apt install -y netdata
    sudo nano /etc/netdata/netdata.conf 
    http://localhost:19999/#menu_system;theme=slate
    root@vagrant:~# sudo lsof -i :19999
        COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
        netdata 643 netdata    4u  IPv4  23928      0t0  TCP *:19999 (LISTEN)
        netdata 643 netdata   47u  IPv4  32231      0t0  TCP vagrant:19999->_gateway:64188 (ESTABLISHED)
        netdata 643 netdata   49u  IPv4  32232      0t0  TCP vagrant:19999->_gateway:64189 (ESTABLISHED)
        netdata 643 netdata   50u  IPv4  31005      0t0  TCP vagrant:19999->_gateway:58359 (ESTABLISHED)
        netdata 643 netdata   51u  IPv4  31260      0t0  TCP vagrant:19999->_gateway:64190 (ESTABLISHED)
        netdata 643 netdata   52u  IPv4  31262      0t0  TCP vagrant:19999->_gateway:64191 (ESTABLISHED)
        netdata 643 netdata   53u  IPv4  32234      0t0  TCP vagrant:19999->_gateway:64192 (ESTABLISHED)
4. root@dev:~# dmesg |grep virtual # Вывод на виртуальной машине
        [    0.032918] Booting paravirtualized kernel on Hyper-V
        [    4.156557] systemd[1]: Detected virtualization microsoft.
    root@pve:~# dmesg |grep virtual # Вывод на чистом железе
        [    0.093374] Booting paravirtualized kernel on bare hardware
5. root@vagrant:~# sysctl -n fs.nr_open
        1048576
    максимальное число открытых дескрипторов для системы, задать больше этого числа нельзя (если не изменять специально). 
    задается значение кратное 1024, в данном случае =1024*1024. 
    root@vagrant:~# cat /proc/sys/fs/file-max
        9223372036854775807
     ulimit    # Provides control over the resources available to the shell and processes it creates, on systems that allow such control.
    root@vagrant:~# ulimit -Sn  # the maximum number of open file descriptors - use the `soft' resource limit
        1024
    root@vagrant:~# ulimit -Hn  # the maximum number of open file descriptors - use the `hard' resource limit
        1048576

6. sudo unshare -f --pid --mount-proc sleep 1h & # Запускаем долгий процесс
    [2] 82
    aleksturbo@AlksTrbNout:~$ ps aux
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root         1  0.0  0.0    916   536 ?        Sl   22:31   0:00 /init
    root        11  0.0  0.0   1264   368 ?        Ss   22:31   0:00 /init
    root        12  0.0  0.0   1264   368 ?        R    22:31   0:00 /init
    alekstu+    13  0.0  0.0   8860  5440 pts/0    Ss   22:31   0:00 -bash
    root        77  0.0  0.0  11584  5952 pts/0    T    22:32   0:00 sudo unshare -f --pid --mount-proc sleep 1h
    root        78  0.0  0.0  11584   932 pts/1    Ss   22:32   0:00 sudo unshare -f --pid --mount-proc sleep 1h
    root        79  0.0  0.0   5772   920 pts/1    T+   22:32   0:00 unshare -f --pid --mount-proc sleep 1h
    root        80  0.0  0.0   5772  1016 pts/1    S+   22:32   0:00 sleep 1h
    root        82  0.0  0.0  11536  5704 pts/0    S    22:33   0:00 sudo unshare -f --pid --mount-proc sleep 1h
    root        83  0.0  0.0  11536   876 pts/2    Ss+  22:33   0:00 sudo unshare -f --pid --mount-proc sleep 1h
    root        84  0.0  0.0   5772   980 pts/2    S    22:33   0:00 unshare -f --pid --mount-proc sleep 1h
    root        85  0.0  0.0   5772  1000 pts/2    S    22:33   0:00 sleep 1h
    alekstu+    86  0.0  0.0  10104  1620 pts/0    R+   22:34   0:00 ps aux

    sudo nsenter --target 85 --pid --mount # Изолируем процесс
    root@AlksTrbNout:/# ps aux
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root         1  0.0  0.0   5772  1000 pts/2    S+   22:33   0:00 sleep 1h  # Процесс c PID 1
    root         2  0.0  0.0   8784  5476 pts/3    S    22:34   0:00 -bash
    root        49  3.9  0.0      0     0 pts/3    Z    22:34   0:00 [check-new-relea] <defunct>
    root       108  0.0  0.0  10104  1592 pts/3    R+   22:35   0:00 ps aux

7. :(){ :|:& };: -  эта команда является логической бомбой. Она оперирует определением функции с именем ‘:‘, которая вызывает сама себя дважды: один раз на переднем плане и один раз в фоне. Она продолжает своё выполнение снова и снова, пока система не зависнет.
        ulimit -u 100 - ограничит число процессов для пользователя
  vagrant@vagrant:~$ dmesg 
    [   96.402840] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope     
    [  124.713673] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-5.scope     