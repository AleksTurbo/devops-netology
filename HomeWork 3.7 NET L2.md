# Домашняя работа  к занятию "3.7. Компьютерные сети, лекция 2"

## 1. Команды для просмотра сетевых интерфейсов:
    Windows - ipconfig:
        PS C:\Users\User> ipconfig

            Настройка протокола IP для Windows
            Неизвестный адаптер VPN - VPN Client:
            Состояние среды. . . . . . . . : Среда передачи недоступна.
            DNS-суффикс подключения . . . . . :
            Адаптер Ethernet Ethernet:
            Состояние среды. . . . . . . . : Среда передачи недоступна.
            DNS-суффикс подключения . . . . . :
            Адаптер Ethernet vEthernet (WSL):
            DNS-суффикс подключения . . . . . :
            Локальный IPv6-адрес канала . . . : fe80::f062:cbf4:8e07:853a%60
            IPv4-адрес. . . . . . . . . . . . : 172.21.112.1
            Маска подсети . . . . . . . . . . : 255.255.240.0
            Основной шлюз. . . . . . . . . :
            Адаптер Ethernet VirtualBox Host-Only Network:
            DNS-суффикс подключения . . . . . :
            Локальный IPv6-адрес канала . . . : fe80::b0db:af03:690e:47a5%15
            IPv4-адрес. . . . . . . . . . . . : 192.168.56.1
            Маска подсети . . . . . . . . . . : 255.255.255.0
            Основной шлюз. . . . . . . . . :
            Адаптер беспроводной локальной сети Подключение по локальной сети* 1:
            Состояние среды. . . . . . . . : Среда передачи недоступна.
            DNS-суффикс подключения . . . . . :
            Адаптер беспроводной локальной сети Подключение по локальной сети* 2:
            Состояние среды. . . . . . . . : Среда передачи недоступна.
            DNS-суффикс подключения . . . . . :
            Адаптер беспроводной локальной сети Беспроводная сеть:
            DNS-суффикс подключения . . . . . :
            Локальный IPv6-адрес канала . . . : fe80::81a2:8a79:5c0f:c18b%10
            IPv4-адрес. . . . . . . . . . . . : 10.78.136.228
            Маска подсети . . . . . . . . . . : 255.255.224.0
            Основной шлюз. . . . . . . . . : 10.78.128.1
        Linux: ifconfig:
            aleksturbo@AlksTrbNout:~$ ifconfig
                eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                        inet 172.21.118.61  netmask 255.255.240.0  broadcast 172.21.127.255
                        inet6 fe80::215:5dff:fe33:1f28  prefixlen 64  scopeid 0x20<link>
                        ether 00:15:5d:33:1f:28  txqueuelen 1000  (Ethernet)
                        RX packets 29443  bytes 7212089 (7.2 MB)
                        RX errors 0  dropped 0  overruns 0  frame 0
                        TX packets 904  bytes 61286 (61.2 KB)
                        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

                lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
                        inet 127.0.0.1  netmask 255.0.0.0
                        inet6 ::1  prefixlen 128  scopeid 0x10<host>
                        loop  txqueuelen 1000  (Локальная петля (Loopback))
                        RX packets 0  bytes 0 (0.0 B)
                        RX errors 0  dropped 0  overruns 0  frame 0
                        TX packets 0  bytes 0 (0.0 B)
                        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

## 2.