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
