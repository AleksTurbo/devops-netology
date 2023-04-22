# Домашнее задание к занятию "12.6  2.1 "Хранение в K8s. Часть 1"

## Задание 1 - Deployment приложения, состоящего из двух контейнеров и обменивающихся данными

1. Создадим Deployment приложения, состоящего из контейнеров busybox и multitool:

[netology-depl21.yaml](/kubernetes/netology-depl21.yaml)

```bash
root@microk8s:~# kubectl apply -f netology-depl21.yaml
deployment.apps/netology-depl-21volume unchanged
```

2. Сделаем так, чтобы busybox писал каждые пять секунд в некий файл в общей директории:

```bash
command: ['sh', '-c', 'while true; do echo $RANDOM\n | md5sum >> /tmp/shrvlm/test.txt; sleep 5; done']
```

3. Обеспечить возможность чтения файла контейнером multitool.

```yuml
    volumeMounts:
        - name: shr-vlm
          mountPath: /shr-vlm
```

4. Демонстрация возможности multitool читать файл, который периодоически обновляется:

```bash
root@microk8s:~# kubectl get pods -n default -o wide
NAME                                      READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
netology-depl-21volume-66469dc5c8-s248b   2/2     Running   0          16m   10.1.128.255   microk8s   <none>           <none>

root@microk8s:~# kubectl exec netology-depl-21volume-66469dc5c8-s248b -c network-multitool -it -- sh

tail -f /shr-vlm/test.txt
63e7965c9268717be316efeceee208c8  -
a9d276f1dd3a3c3fb13622e5172740c9  -
5a25fe5cdc6360dc233a9cced33b9222  -
319377b9ef08c90315f648e843baf123  -
e5f720437edb641cdf2ffd4a4e5cc812  -
49db27de12bc0d34bfcde3f835a3183f  -
275731c8b39a31cb3d5fda4f2c762b90  -
```

5. Манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.:

[netology-depl21.yaml](/kubernetes/netology-depl21.yaml)

<img src="img/HW 12.6 MicroK8S volume 1.png"/>

## Задание 2 - DaemonSet приложения, которое может прочитать логи ноды

1. DaemonSet приложения, состоящего из multitool:

[netology-dmnst.yaml](/kubernetes/netology-dmnst.yaml)

2. Обеспечим возможность чтения файла /var/log/syslog кластера MicroK8S.

```yaml
volumes:
      - name: volume-host
        hostPath:
          path: /var/log

volumeMounts:
      - name: volume-host
        mountPath: /shr-vlm
```

3. Демонстрация возможности чтения файла изнутри пода:

```bash
root@microk8s:~# kubectl apply -f netology-dmnst.yaml
daemonset.apps/netology-dmnst-21volume created


root@microk8s:~# kubectl get pods -n default -o wide
NAME                                      READY   STATUS    RESTARTS   AGE    IP             NODE       NOMINATED NODE   READINESS GATES
netology-depl-21volume-66469dc5c8-s248b   2/2     Running   0          11h    10.1.128.255   microk8s   <none>           <none>
netology-dmnst-21volume-ggkzz             1/1     Running   0          3m9s   10.1.128.226   microk8s   <none>           <none>


root@microk8s:~# kubectl exec netology-dmnst-21volume-ggkzz -c network-multitool -it -- sh

/ # ls -la /shr-vlm/
total 5424
drwxrwxr-x   11 root     110           4096 Apr 22 00:00 .
drwxr-xr-x    1 root     root          4096 Apr 22 06:25 ..
-rw-r--r--    1 root     root         21888 Apr 20 06:48 alternatives.log
drwxr-xr-x    2 root     root          4096 Apr 20 06:48 apt
-rw-r-----    1 104      adm          38565 Apr 22 06:25 auth.log
-rw-r-----    1 104      adm          72428 Apr 15 23:17 auth.log.1
-rw-r-----    1 104      adm          10074 Apr  8 23:17 auth.log.2.gz
-rw-rw----    1 root     43               0 Feb 15 21:41 btmp
drwxr-xr-x    3 root     root          4096 Apr  4 15:57 calico
-rw-r-----    1 root     adm          73568 Apr 12 19:03 cloud-init-output.log
-rw-r--r--    1 104      adm        1093111 Apr 12 19:03 cloud-init.log
drwxr-xr-x    2 root     root         20480 Apr 22 06:25 containers
drwxr-xr-x    2 root     root          4096 Nov 20 22:31 dist-upgrade
-rw-r--r--    1 root     adm          53746 Apr 12 19:03 dmesg
-rw-r--r--    1 root     adm          54231 Apr 12 10:56 dmesg.0
-rw-r--r--    1 root     adm          14674 Apr  9 17:26 dmesg.1.gz
-rw-r--r--    1 root     adm          14669 Apr  6 16:35 dmesg.2.gz
-rw-r--r--    1 root     adm          14797 Apr  6 16:33 dmesg.3.gz
-rw-r--r--    1 root     adm          14704 Apr  4 17:28 dmesg.4.gz
-rw-r--r--    1 root     root        116478 Apr 20 06:48 dpkg.log
drwxr-sr-x    4 root     nginx         4096 Apr  4 15:53 journal
-rw-r-----    1 104      adm           4160 Apr 22 06:25 kern.log
-rw-r-----    1 104      adm         213096 Apr 15 16:35 kern.log.1
-rw-r-----    1 104      adm         140880 Apr  8 18:25 kern.log.2.gz
drwxr-xr-x    2 110      115           4096 Apr  2 17:16 landscape
-rw-rw-r--    1 root     43          291708 Apr 22 06:20 lastlog
drwxr-xr-x   22 root     root          4096 Apr 22 06:25 pods
drwx------    2 root     root          4096 Apr  2 17:14 private
-rw-r-----    1 104      adm         514024 Apr 22 06:26 syslog
-rw-r-----    1 104      adm        2152818 Apr 22 00:00 syslog.1
-rw-r-----    1 104      adm          85056 Apr 21 00:00 syslog.2.gz
-rw-r-----    1 104      adm         101821 Apr 20 00:00 syslog.3.gz
-rw-r-----    1 104      adm         116221 Apr 19 00:00 syslog.4.gz
....

/ # tail -f /shr-vlm/syslog
Apr 22 06:25:58 microk8s systemd[764891]: run-containerd-runc-k8s.io-73721b51e5b5f3488dccedc59b5477356bc1ed359f33d94e0aa44b9d09861541-runc.6g9qrz.mount: Succeeded.
Apr 22 06:25:59 microk8s systemd[764891]: run-containerd-runc-k8s.io-73721b51e5b5f3488dccedc59b5477356bc1ed359f33d94e0aa44b9d09861541-runc.hblqBI.mount: Succeeded.
Apr 22 06:25:59 microk8s systemd[1]: run-containerd-runc-k8s.io-73721b51e5b5f3488dccedc59b5477356bc1ed359f33d94e0aa44b9d09861541-runc.hblqBI.mount: Succeeded.
Apr 22 06:26:08 microk8s microk8s.daemon-containerd[796]: time="2023-04-22T06:26:08.965185419Z" level=info msg="Container exec \"9998a4b2abf985404a4f040004a4e799708f0e66207d1b5b674f6d7f777d5c09\" stdin closed"
Apr 22 06:26:11 microk8s systemd[1]: run-containerd-runc-k8s.io-3d6b46ce344c3954d9e899f4a739a14d5ac7316bcd67cc3aaef0db4118fd1ea1-runc.H1sHCH.mount: Succeeded.
Apr 22 06:26:11 microk8s systemd[764891]: run-containerd-runc-k8s.io-3d6b46ce344c3954d9e899f4a739a14d5ac7316bcd67cc3aaef0db4118fd1ea1-runc.H1sHCH.mount: Succeeded.
Apr 22 06:26:38 microk8s systemd[1]: run-containerd-runc-k8s.io-73721b51e5b5f3488dccedc59b5477356bc1ed359f33d94e0aa44b9d09861541-runc.mg3f06.mount: Succeeded.
Apr 22 06:26:38 microk8s systemd[764891]: run-containerd-runc-k8s.io-73721b51e5b5f3488dccedc59b5477356bc1ed359f33d94e0aa44b9d09861541-runc.mg3f06.mount: Succeeded.
Apr 22 06:26:46 microk8s systemd[764891]: run-containerd-runc-k8s.io-ddbcb6f1b6d1d66fbaa86f0c05482c5c0a866eca9ab500d36b7f6bb7d3f61a59-runc.i1XyYb.mount: Succeeded.
Apr 22 06:26:46 microk8s systemd[1]: run-containerd-runc-k8s.io-ddbcb6f1b6d1d66fbaa86f0c05482c5c0a866eca9ab500d36b7f6bb7d3f61a59-runc.i1XyYb.mount: Succeeded.

```

4. Манифесты Deployment, а также скриншоты или вывод команды из п. 2.:

[netology-dmnst.yaml](/kubernetes/netology-dmnst.yaml)

<img src="img/HW 12.6 MicroK8S volume 2 syslog.png"/>
