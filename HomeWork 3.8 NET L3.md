# Домашняя работа  к занятию "3.8. Компьютерные сети, лекция 3"

## 1. сервис routeviews.org:
    route-views>show ip route 178.155.12.9
        Routing entry for 178.155.12.0/23
        Known via "bgp 6447", distance 20, metric 0
        Tag 2497, type external
        Last update from 202.232.0.2 7w0d ago
        Routing Descriptor Blocks:
        * 202.232.0.2, from 202.232.0.2, 7w0d ago
            Route metric is 0, traffic share count is 1
            AS Hops 3
            Route tag 2497
            MPLS label: none
    
    route-views>show bgp 178.155.12.9
            Paths: (24 available, best #23, table default)
        Not advertised to any peer
        Refresh Epoch 1
        6939 8359 29497
            64.71.137.241 from 64.71.137.241 (216.218.252.164)
            Origin IGP, localpref 100, valid, external
            path 7FE0DE81CFF0 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1
        4901 6079 8359 29497
            162.250.137.254 from 162.250.137.254 (162.250.137.254)
            Origin IGP, localpref 100, valid, external
            Community: 65000:10100 65000:10300 65000:10400
            path 7FE0183A9CC8 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1
        7018 3356 8359 29497
            12.0.1.63 from 12.0.1.63 (12.0.1.63)
            Origin IGP, localpref 100, valid, external
            Community: 7018:5000 7018:37232
            path 7FE0B61B3330 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1
        3267 3356 8359 29497
            194.85.40.15 from 194.85.40.15 (185.141.126.1)
            Origin IGP, metric 0, localpref 100, valid, external
            path 7FE0B7CCC9C0 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1
        20912 3257 3356 8359 29497
            212.66.96.126 from 212.66.96.126 (212.66.96.126)
            Origin IGP, localpref 100, valid, external
            Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
            path 7FE178547228 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1
        1351 8359 8359 29497
            132.198.255.253 from 132.198.255.253 (132.198.255.253)
            Origin IGP, localpref 100, valid, external
            path 7FE0F845E688 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1
        3333 8359 29497
            193.0.0.56 from 193.0.0.56 (193.0.0.56)
            Origin IGP, localpref 100, valid, external
            Community: 8359:5500 8359:55361
            path 7FE0FEB8A5D0 RPKI State not found
            rx pathid: 0, tx pathid: 0
        Refresh Epoch 1

## 2. Dummy:
    root@AlksTrbNout:~# ip route
        default via 172.21.112.1 dev eth0
        172.21.112.0/20 dev eth0 proto kernel scope link src 172.21.117.19

    echo "dummy" > /etc/modules-load.d/dummy.conf
    echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf

    nano /etc/systemd/network/dummy0.netdev
        [NetDev]
        Name=dummy0
         Kind=dummy
    nano /etc/systemd/network/dummy2.network
        [Match]
        Name=dummy0

        [Network]
        Address=10.0.8.1/24
   systemctl restart systemd-networkd

   root@vagrant:~# ip link show
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
            link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
        3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
            link/ether 08:00:27:c8:da:73 brd ff:ff:ff:ff:ff:ff
        4: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    
    root@vagrant:~# ip r
        default via 192.168.153.1 dev eth0 proto dhcp src 192.168.153.141 metric 100
        192.168.89.0/24 dev dummy0 proto kernel scope link src 192.168.89.1
        192.168.153.0/24 dev eth0 proto kernel scope link src 192.168.153.141
        192.168.153.1 dev eth0 proto dhcp scope link src 192.168.153.141 metric 100

    nano /etc/netplan/10-networkd.yaml
        network:
        version: 2
        ethernets:
            eth1:
            optional: true
            addresses:
                - 192.168.154.10/24
            routes:
                - to: 192.168.155.0/24
                via: 192.168.154.1
    
## 3. TCP ports
    root@pve:~# ss -tlpin
    State Recv-Q Send-Q Local Address:Port Peer Address:Port Process
    LISTEN 0 4096 0.0.0.0:111 0.0.0.0:* users:(("rpcbind",pid=1005,fd=4),("systemd",pid=1,fd=115))       cubic cwnd:10
    LISTEN 0 511 0.0.0.0:80 0.0.0.0:* users:(("nginx",pid=726177,fd=6),("nginx",pid=726176,fd=6),("nginx",pid=726175,fd=6),("nginx",pid=726174,fd=6),("nginx",pid=726173,fd=6),("nginx",pid=726172,fd=6),("nginx",pid=726171,fd=6),("nginx",pid=726170,fd=6),("nginx",pid=725713,fd=6))
            cubic cwnd:10
    LISTEN 0 4096 127.0.0.1:85 0.0.0.0:* users:(("pvedaemon worke",pid=1404,fd=6),("pvedaemon worke",pid=1403,fd=6),("pvedaemon worke",pid=1402,fd=6),("pvedaemon",pid=1401,fd=6))         cubic cwnd:10
    LISTEN 0 128 0.0.0.0:22 0.0.0.0:* users:(("sshd",pid=714389,fd=3))          cubic cwnd:10
    LISTEN 0 100 127.0.0.1:25 0.0.0.0:* users:(("master",pid=714137,fd=13))          cubic cwnd:10
    LISTEN 0 4096 *:8006 *:* users:(("pveproxy worker",pid=978473,fd=6),("pveproxy worker",pid=978472,fd=6),("pveproxy worker",pid=978471,fd=6),("pveproxy",pid=1410,fd=6))          cubic cwnd:10
    LISTEN 0 4096 [::]:111 [::]:* users:(("rpcbind",pid=1005,fd=6),("systemd",pid=1,fd=117))          cubic cwnd:10
    LISTEN 0 511 [::]:80 [::]:* users:(("nginx",pid=726177,fd=7),("nginx",pid=726176,fd=7),("nginx",pid=726175,fd=7),("nginx",pid=726174,fd=7),("nginx",pid=726173,fd=7),("nginx",pid=726172,fd=7),("nginx",pid=726171,fd=7),("nginx",pid=726170,fd=7),("nginx",pid=725713,fd=7))
            cubic cwnd:10
    LISTEN 0 128 [::]:22 [::]:* users:(("sshd",pid=714389,fd=4))         cubic cwnd:10
    LISTEN 0 4096 *:3128 *:* users:(("spiceproxy work",pid=978465,fd=6),("spiceproxy",pid=1416,fd=6))    cubic cwnd:10
    LISTEN 0 100 [::1]:25 [::]:* users:(("master",pid=714137,fd=14))     cubic cwnd:10

    80 порт - WEB сервер NGINX
    22 порт - SSH сервер

## 4.  UDP ports
    root@pve:~# ss -ulpin
    State          Recv-Q         Send-Q                  Local Address:Port                   Peer Address:Port         Process
    UNCONN         0              0                             0.0.0.0:111                         0.0.0.0:*             users:(("rpcbind",pid=1005,fd=5),("systemd",pid=1,fd=116))
    UNCONN         0              0                           127.0.0.1:323                         0.0.0.0:*             users:(("chronyd",pid=714657,fd=5))
    UNCONN         0              0                                [::]:111                            [::]:*             users:(("rpcbind",pid=1005,fd=7),("systemd",pid=1,fd=118))
    UNCONN         0              0                               [::1]:323                            [::]:*             users:(("chronyd",pid=714657,fd=6))

    323 - приложение chrony

## 5.  DrawIO - (см.)