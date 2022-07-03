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
        Linux: 
          ifconfig:
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
          
          aleksturbo@AlksTrbNout:~$ ip link show
            1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
                link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            2: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
                link/ether ba:b8:ee:10:9e:5c brd ff:ff:ff:ff:ff:ff
            3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
                link/ether a6:12:69:16:cd:53 brd ff:ff:ff:ff:ff:ff
            4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
                link/ipip 0.0.0.0 brd 0.0.0.0
            5: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
                link/sit 0.0.0.0 brd 0.0.0.0
            6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
                link/ether 00:15:5d:33:1f:28 brd ff:ff:ff:ff:ff:ff

## 2. Протокол - LLDP.
    Пакет lldpd.
    Команда lldpctl:
    root@pve:~# lldpctl
        -------------------------------------------------------------------------------
        LLDP neighbors:
        -------------------------------------------------------------------------------
        Interface:    enp5s0, via: LLDP, RID: 2, Time: 0 day, 00:00:07
        Chassis:     
            ChassisID:    mac 74:4d:28:0d:18:cd
            SysName:      AlksTrbMkrtk
            SysDescr:     MikroTik RouterOS 7.3.1 (stable) Jun/09/2022 08:58:15 RBD52G-5HacD2HnD
            MgmtIP:       192.168.153.1
            MgmtIface:    7
            Capability:   Bridge, on
            Capability:   Router, on
            Capability:   Wlan, on
        Port:        
            PortID:       ifname bridge1/ether5
            TTL:          120
        -------------------------------------------------------------------------------
        Interface:    fwpr100p0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac 3a:fa:ad:02:6e:9c
            PortDescr:    fwln100i0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwln100i0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac 6a:53:0b:60:3d:62
            PortDescr:    fwpr100p0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwpr101p0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac fa:0b:bd:40:29:e5
            PortDescr:    fwln101i0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwln101i0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac 92:f1:ce:a3:62:0d
            PortDescr:    fwpr101p0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwpr102p0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac 26:98:b4:76:01:65
            PortDescr:    fwln102i0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwln102i0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac 22:07:a7:82:f6:fb
            PortDescr:    fwpr102p0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwpr103p0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac a2:00:d9:79:77:ac
            PortDescr:    fwln103i0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
        -------------------------------------------------------------------------------
        Interface:    fwln103i0, via: LLDP, RID: 1, Time: 0 day, 00:00:08
        Chassis:     
            ChassisID:    mac 38:d5:47:0f:54:44
            SysName:      pve.home.loc
            SysDescr:     Debian GNU/Linux 11 (bullseye) Linux 5.13.19-2-pve #1 SMP PVE 5.13.19-4 (Mon, 29 Nov 2021 12:10:09 +0100) x86_64
            MgmtIP:       192.168.153.50
            MgmtIface:    3
            MgmtIP:       fe80::3ad5:47ff:fe0f:5444
            MgmtIface:    3
            Capability:   Bridge, on
            Capability:   Router, off
            Capability:   Wlan, off
            Capability:   Station, off
        Port:        
            PortID:       mac ba:d6:cd:58:d9:ae
            PortDescr:    fwpr103p0
            TTL:          120
            PMD autoneg:  supported: no, enabled: no
            MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
## 3. Технология VLAN - Virtual LAN.
        Пакет в Ubuntu Linux - vlan
        ##vlan с ID-100 для интерфейса eth0 with ID - 100 в Debian/Ubuntu Linux##
        auto eth0.100
        iface eth0.100 inet static
        address 192.168.1.200
        netmask 255.255.255.0
        vlan-raw-device eth0

## 4. Технологии агрегации (LAG): bonding и teaming:
      bonding:
        root@pve:~# modinfo bonding | grep mode:
            parm:           mode:Mode of operation; 0 for balance-rr, 1 for active-backup, 2 for balance-xor, 3 for broadcast, 4 for 802.3ad, 5 for balance-tlb, 6 for balance-alb (charp)
        
        0 - balance-rr - Политика round-robin. Пакеты отправляются последовательно, начиная с первого доступного интерфейса и заканчивая последним. Эта политика применяется для балансировки нагрузки и отказоустойчивости.
        1 - active-backup - Политика активный-резервный. Только один сетевой интерфейс из объединённых будет активным. Другой интерфейс может стать активным, только в том случае, когда упадёт текущий активный интерфейс. Эта политика применяется для отказоустойчивости.
        3 - balance-xor - Политика XOR. Передача распределяется между сетевыми картами по модулю «число интерфейсов». Получается одна и та же сетевая карта передаёт пакеты одним и тем же получателям. Политика XOR применяется для балансировки нагрузки и отказоустойчивости.
        4 - broadcast - Широковещательная политика. Передает всё на все сетевые интерфейсы. Эта политика применяется для отказоустойчивости.
        5 - 802.3ad - Политика агрегирования каналов по стандарту IEEE 802.3ad. Создаются агрегированные группы сетевых карт с одинаковой скоростью и дуплексом. При таком объединении передача задействует все каналы в активной агрегации, согласно стандарту IEEE 802.3ad. Выбор через какой интерфейс отправлять пакет определяется политикой по умолчанию XOR политика.
        6 - balance-tlb - Политика адаптивной балансировки нагрузки передачи. Исходящий трафик распределяется в зависимости от загруженности каждой сетевой карты (определяется скоростью загрузки). Не требует дополнительной настройки на коммутаторе. Входящий трафик приходит на текущую сетевую карту. Если она выходит из строя, то другая сетевая карта берёт себе MAC адрес вышедшей из строя карты.
        7 - balance-alb - Политика адаптивной балансировки нагрузки. Включает в себя политику balance-tlb плюс осуществляет балансировку входящего трафика. Не требует дополнительной настройки на коммутаторе. Балансировка входящего трафика достигается путём ARP переговоров.

        Prim config bonds::

            bond0: 
            dhcp4: yes 
            interfaces:
                - ens1
                - ens2
            parameters:
                mode: balance-alb
                mii-monitor-interval: 2

## 5.  aleksturbo@AlksTrbNout:~$ ipcalc -b 192.168.153.0/29
            Address:   192.168.153.0
            Netmask:   255.255.255.248 = 29
            Wildcard:  0.0.0.7
            =>
            Network:   192.168.153.0/29
            HostMin:   192.168.153.1
            HostMax:   192.168.153.6
            Broadcast: 192.168.153.7
            Hosts/Net: 6                     Class C, Private Internet

         С маской 29 существует 8 IP адресов, доступно к использованию на хостах - 6

         В сети /24 помещаются 256/8 = 32 подсети /29

## 6.  Предлагаю использовать из диапазона 100.64.0.0/10
        В соответствии с RFC6598 , используется как транслируемый блок адресов для межпровайдерских взаимодействий и Carrier Grade NAT. Особенно полезен как общее свободное адресное IPv4-пространство

        aleksturbo@AlksTrbNout:~$ ipcalc -b 100.64.0.0/10 -s 45
            Address:   100.64.0.0
            Netmask:   255.192.0.0 = 10
            Wildcard:  0.63.255.255
            =>
            Network:   100.64.0.0/10
            HostMin:   100.64.0.1
            HostMax:   100.127.255.254
            Broadcast: 100.127.255.255
            Hosts/Net: 4194302               Class A

            1. Requested size: 45 hosts
            Netmask:   255.255.255.224 = 27
            Network:   100.64.0.0/27
            HostMin:   100.64.0.1
            HostMax:   100.64.0.30
            Broadcast: 100.64.0.31
            Hosts/Net: 30                    Class A

            Needed size:  64 addresses.
            Used network: 100.64.0.0/26
            Unused:
            100.64.0.64/26
            100.64.0.128/25
            100.64.1.0/24
            100.64.2.0/23
            100.64.4.0/22
            100.64.8.0/21
            100.64.16.0/20
            100.64.32.0/19
            100.64.64.0/18
            100.64.128.0/17
            100.65.0.0/16
            100.66.0.0/15
            100.68.0.0/14
            100.72.0.0/13
            100.80.0.0/12
            100.96.0.0/11

    Используем подсеть 100.64.0.0/26
        aleksturbo@AlksTrbNout:~$ ipcalc -b 100.64.0.0/26
            Address:   100.64.0.0
            Netmask:   255.255.255.192 = 26
            Wildcard:  0.0.0.63
            =>
            Network:   100.64.0.0/26
            HostMin:   100.64.0.1
            HostMax:   100.64.0.62
            Broadcast: 100.64.0.63
            Hosts/Net: 62                    Class A

## 7.  Linux: arp -n
        aleksturbo@AlksTrbNout:~$ arp -n
            Адрес HW-тип HW-адрес Флаги Маска Интерфейс
            172.21.112.1             ether   00:15:5d:46:b8:78   C                     eth0

        Windows: 
            PS C:\Users\User> arp -a

                Интерфейс: 10.78.136.228 --- 0xa
                адрес в Интернете      Физический адрес      Тип
                10.78.128.1           6c-9c-ed-75-a0-1b     динамический
                10.78.136.239         04-ed-33-ab-13-c3     динамический
                10.78.136.251         a4-83-e7-20-f3-c6     динамический
                10.78.159.255         ff-ff-ff-ff-ff-ff     статический
                224.0.0.2             01-00-5e-00-00-02     статический
                224.0.0.22            01-00-5e-00-00-16     статический
                224.0.0.251           01-00-5e-00-00-fb     статический
                224.0.0.252           01-00-5e-00-00-fc     статический
                239.255.255.250       01-00-5e-7f-ff-fa     статический
                255.255.255.255       ff-ff-ff-ff-ff-ff     статический

                Интерфейс: 192.168.56.1 --- 0xf
                адрес в Интернете      Физический адрес      Тип
                192.168.56.255        ff-ff-ff-ff-ff-ff     статический
                224.0.0.2             01-00-5e-00-00-02     статический
                224.0.0.22            01-00-5e-00-00-16     статический
                224.0.0.251           01-00-5e-00-00-fb     статический
                224.0.0.252           01-00-5e-00-00-fc     статический
                239.255.255.250       01-00-5e-7f-ff-fa     статический

                Интерфейс: 172.21.112.1 --- 0x3c
                адрес в Интернете      Физический адрес      Тип
                172.21.118.61         00-15-5d-33-1f-28     динамический
                172.21.127.255        ff-ff-ff-ff-ff-ff     статический
                224.0.0.2             01-00-5e-00-00-02     статический
                224.0.0.22            01-00-5e-00-00-16     статический
                224.0.0.251           01-00-5e-00-00-fb     статический
                239.255.255.250       01-00-5e-7f-ff-fa     статический
                255.255.255.255       ff-ff-ff-ff-ff-ff     статический

            Очистить кеш :
                Linux: arp -d <ip-address> ( - для отдельного адреса)
                        ip -s -s neigh flush all (flush - для всех записей)
                Windows: arp -d (* - для всех записей, <IP> - для отдельного адреса)

            aleksturbo@AlksTrbNout:~$ sudo ip -s -s neigh flush all
                [sudo] пароль для aleksturbo:
                172.21.112.1 dev eth0 lladdr 00:15:5d:46:b8:78 used 292/287/253 probes 1 STALE

                *** Round 1, deleting 1 entries ***
                *** Flush is complete after 1 round ***