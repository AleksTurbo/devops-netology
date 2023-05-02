# Домашнее задание к занятию "12.7  2.2 "Хранение в K8s. Часть 2"

## Задание 1 - Deployment приложения, состоящего из двух контейнеров и обменивающихся данными через PV ресурс

1. Создадим Deployment приложения, состоящего из контейнеров busybox и multitool:

[netology-depl22-pv.yaml](/kubernetes/netology-depl22-pv.yaml)

```bash
root@microk8s:~# kubectl apply -f "/root/netology-depl22-pv.yaml"
deployment.apps/netology-depl-22-pv-volume created

root@microk8s:~# kubectl get deployment
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
netology-depl-22-pv-volume   1/1     1            1           9m29s

root@microk8s:~# kubectl get pod
NAME                                          READY   STATUS    RESTARTS   AGE
netology-depl-22-pv-volume-7897789b77-g2w4q   2/2     Running   0          9m55s

```

2. Создадим PV и PVC для подключения папки на локальной ноде, которая будет использована в поде:

[netology-pv.yaml](/kubernetes/netology-pv.yaml)
[netology-pvc.yaml](/kubernetes/netology-pvc.yaml)

```bash
root@microk8s:~# kubectl apply -f "/root/netology-pvc.yaml"
persistentvolumeclaim/pvc-volume created
root@microk8s:~# kubectl apply -f "/root/netology-pv.yaml"
persistentvolume/pv-volume created

root@microk8s:~# kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
pv-volume   1Gi        RWO            Retain           Bound    default/pvc-volume                           9m58s

root@microk8s:~# kubectl get pvc
NAME         STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-volume   Bound    pv-volume   1Gi        RWO                           10m

```

3. Демонстрация возможности multitool читать файл, в который busybox пишет каждые пять секунд в общей директории:

```bash
root@microk8s:~# kubectl exec netology-depl-22-pv-volume-7897789b77-g2w4q -c network-multitool -it -- sh

/ # ls -la /pvc-vlm/
total 252
drwxr-xr-x    2 root     root          4096 Apr 26 18:47 .
drwxr-xr-x    1 root     root          4096 Apr 27 17:55 ..
-rw-r--r--    1 root     root        246420 Apr 27 18:07 test.txt

/ # tail -f /pvc-vlm/test.txt
7f72f36b2479e9e42608dd193a4a742f  -
dad37307c3f4b159831a8cb70923dfd4  -
32f38b5e593075f974d75c52da0d3745  -
3124007484607be69495bb8869e36c20  -
43320906a780dbe8f895c1c404a2a439  -
976d2ff13d16c8f5b084b868a732565b  -
289afe24351d65b456e8b4a5044277f6  -
e53597091037108f6d609ebf5f1447a2  -
25ef8c46b275794c618f8ed8d06de6b5  -
3f8ae1bba9d1818e80e83c96c32a6d2e  -
969049573085c71a5d6dc034e34b56bf  -

```

- содержимое storage на ноде:

```bash
root@microk8s:~# ls -la /storage/pv/
total 252
drwxr-xr-x 2 root root   4096 Apr 26 18:47 .
drwxr-xr-x 3 root root   4096 Apr 26 18:42 ..
-rw-r--r-- 1 root root 247572 Apr 27 18:10 test.txt

root@microk8s:~# tail -f "/storage/pv/test.txt"
b97769bb1e59af1a3850ca4ecafed0b8  -
211cd6d95065edadceb1ad13f6471881  -
02055b7b379d95a2a442277015d8f1aa  -
e902dd662d7d8d8800244478f438adc4  -
263d8cfba8d0a7584bc8160e69cf28dd  -
6e838231d9e88cf67b1772653775ba49  -
72b0a90c4ca91aad3ffdaa289a868e77  -
b5eb3a659d0d4775f7a952a534c74185  -
124cef78b728688f82b66b9adf40e3af  -
c9c3b5ec79a3ef2134954e31d5c4970e  -
8bf16e282a6a74437e47e260dda7adb4  -
7228db18c04f07c5b5d2968850bbad55  -

```

4. Демонстрация наличия файла на локальном диске ноды и поведение файла после удаления пода и deployment:

- Удаляем deployment и pod:

```bash
root@microk8s:~# kubectl delete deployment netology-depl-22-pv-volume
deployment.apps "netology-depl-22-pv-volume" deleted

root@microk8s:~# kubectl get deployment
No resources found in default namespace.

root@microk8s:~# kubectl get pod
No resources found in default namespace.

```

- Проверяем присутствие storage:

```bash
root@microk8s:~# ls -la /storage/pv/
total 256
drwxr-xr-x 2 root root   4096 Apr 26 18:47 .
drwxr-xr-x 3 root root   4096 Apr 26 18:42 ..
-rw-r--r-- 1 root root 251172 Apr 27 18:18 test.txt

root@microk8s:~# tail -f "/storage/pv/test.txt"
2f861be0db6b810a202b3f65db3ddf61  -
2755dc0a528a664d3a92ec65dc1b1fa3  -
06c1d00771fe860c5a6be6916456ee6d  -
0dce0fedb10b1abca660bb014f7f754a  -
9b27f7edef33bda64b13daa787a1c5bf  -
eec2a846238fb8c56a478efa343a5f57  -
527f1fed5ae1a90ee0bf20aa3ab1646a  -
0dafcf06513364a4e9cc2fa8b4f6c75b  -
8752b9a6a0c711dac363328c011b2ff0  -
38bf1671151882dfa30f46ca8178eebb  -
```

- Файлы остались на исходном месте на НОДе т.к. pv и pvc остались существовать без deployment. Кроме того использовался параметр ReclaimPolicy — определяет как будут использованы ресурсы после удаления PV. Retain — после удаления PV ресурсы из внешних провайдеров автоматически не удаляются.


5. Манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.:

[netology-depl22-pv.yaml](/kubernetes/netology-depl22-pv.yaml)
[netology-pv.yaml](/kubernetes/netology-pv.yaml)
[netology-pvc.yaml](/kubernetes/netology-pvc.yaml)

<img src="img/HW 12.7 MicroK8S pv 2.png"/>

<img src="img/HW 12.7 MicroK8S pv 3.png"/>

## Задание 2 - Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV

1. Подключаемся к NFS-серверу:

```bash
root@microk8s:~# sudo mount 192.168.84.81:/volume2/nfs /nfs/vlm2

root@microk8s:~# df -h
Filesystem                  Size  Used Avail Use% Mounted on
udev                        3.9G     0  3.9G   0% /dev
tmpfs                       796M  2.1M  794M   1% /run
/dev/sda1                    39G   12G   28G  29% /
tmpfs                       3.9G     0  3.9G   0% /dev/shm
tmpfs                       5.0M     0  5.0M   0% /run/lock
tmpfs                       3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sda15                  105M  6.1M   99M   6% /boot/efi
192.168.84.81:/volume2/nfs   11T  2.6G   11T   1% /nfs/vlm2

root@microk8s:~# ls -la /nfs/vlm2
total 8
drwxrwxrwx 1 root root   22 Apr 26 17:38 '#recycle'
drwxrwxrwx 1 root root   50 Apr 26 18:04  .
drwxr-xr-x 3 root root 4096 Apr 26 18:04  ..
-rwxrwxrwx 1 root root   10 Apr 26 18:07  testnfs.txt
root@microk8s:~# cat /nfs/vlm2/testnfs.txt
testtest
```

2. Создадим Deployment приложения состоящего из multitool, и подключим к нему PV, созданный автоматически на сервере NFS:

[netology-depl22-nfs.yaml](/kubernetes/netology-depl22-nfs.yaml)

```bash
root@microk8s:~# kubectl apply -f "/root/netology-depl22-nfs.yaml"
deployment.apps/netology-depl-22-nfs-volume created

root@microk8s:~# kubectl apply -f "/root/netology-storageclass.yaml"
storageclass.storage.k8s.io/netology-nfs created

root@microk8s:~# kubectl apply -f "/root/netology-pvc-nfs.yaml"
persistentvolumeclaim/pvc-nfs-volume created


root@microk8s:~# microk8s kubectl wait pod --selector app.kubernetes.io/name=csi-driver-nfs --for condition=ready --namespace kube-system
pod/csi-nfs-controller-f9bd9cfc-7tthm condition met
pod/csi-nfs-node-l9srl condition met
root@microk8s:~# kubectl describe pvc
Name:          pvc-nfs-volume
Namespace:     default
StorageClass:  netology-nfs
Status:        Bound
Volume:        pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: nfs.csi.k8s.io
               volume.kubernetes.io/storage-provisioner: nfs.csi.k8s.io
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      1Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       netology-depl-22-nfs-volume-747bb85c55-trtf5
Events:
  Type    Reason                 Age                   From                                                          Message
  ----    ------                 ----                  ----                                                          -------
  Normal  ExternalProvisioning   4m1s (x8 over 5m24s)  persistentvolume-controller  waiting for a volume to be created, either by external provisioner "nfs.csi.k8s.io" or manually created by system administrator
  Normal  ExternalProvisioning   37s (x8 over 2m22s)   persistentvolume-controller waiting for a volume to be created, either by external provisioner "nfs.csi.k8s.io" or manually created by system administrator
  Normal  Provisioning           35s  nfs.csi.k8s.io_microk8s_91fe2b9c-b4c5-4fa2-813f-d5ded0953fbf  External provisioner is provisioning volume for claim "default/pvc-nfs-volume"
  Normal  ProvisioningSucceeded  31s  nfs.csi.k8s.io_microk8s_91fe2b9c-b4c5-4fa2-813f-d5ded0953fbf  Successfully provisioned volume pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e


root@microk8s:~# kubectl get pvc
NAME             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nfs-volume   Bound    pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e   1Gi        RWO            netology-nfs   6m38s

root@microk8s:~# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE
pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e   1Gi        RWO            Delete           Bound    default/pvc-nfs-volume   netology-nfs            114s

root@microk8s:~# kubectl get pod
NAME                                           READY   STATUS    RESTARTS   AGE
netology-depl-22-nfs-volume-747bb85c55-trtf5   1/1     Running   0          14m

```

```bash
root@microk8s:~# kubectl describe  pod netology-depl-22-nfs-volume-747bb85c55-trtf5
Name:             netology-depl-22-nfs-volume-747bb85c55-trtf5
Namespace:        default
Priority:         0
Service Account:  default
Node:             microk8s/192.168.153.124
Start Time:       Thu, 27 Apr 2023 19:03:21 +0000
Labels:           app=pvcvlm
                  pod-template-hash=747bb85c55
Annotations:      cni.projectcalico.org/containerID: b2c620c1e33151af02e0d481c8a939f29b91f527365af5716f89d3be6b75e477
                  cni.projectcalico.org/podIP: 10.1.128.235/32
                  cni.projectcalico.org/podIPs: 10.1.128.235/32
Status:           Running
IP:               10.1.128.235
IPs:
  IP:           10.1.128.235
Controlled By:  ReplicaSet/netology-depl-22-nfs-volume-747bb85c55
Containers:
  network-multitool:
    Container ID:   containerd://abe61ceb1295bff73ae0a6634a087090568c2c70456f67cb5c580911a0ee2f43
    Image:          wbitt/network-multitool
    Image ID:       docker.io/wbitt/network-multitool@sha256:82a5ea955024390d6b438ce22ccc75c98b481bf00e57c13e9a9cc1458eb92652
    Ports:          80/TCP, 443/TCP
    Host Ports:     0/TCP, 0/TCP
    State:          Running
      Started:      Thu, 27 Apr 2023 19:03:30 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     10m
      memory:  20Mi
    Requests:
      cpu:     1m
      memory:  20Mi
    Environment:
      HTTP_PORT:   80
      HTTPS_PORT:  443
    Mounts:
      /pvc-nfs-vlm from pvc-nfs-vlm (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-d8pnd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  pvc-nfs-vlm:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  pvc-nfs-volume
    ReadOnly:   false
  kube-api-access-d8pnd:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m32s  default-scheduler  Successfully assigned default/netology-depl-22-nfs-volume-747bb85c55-trtf5 to microk8s
  Normal  Pulling    4m27s  kubelet            Pulling image "wbitt/network-multitool"
  Normal  Pulled     4m26s  kubelet            Successfully pulled image "wbitt/network-multitool" in 1.135589559s (1.135594285s including waiting)
  Normal  Created    4m26s  kubelet            Created container network-multitool
  Normal  Started    4m24s  kubelet            Started container network-multitool

```

3. Демонстрируем возможность чтения и записи файла изнутри пода:

- Подключаемся к поду и проверяем наличие подключенного NFS ресурса

```bash
root@microk8s:~# kubectl get pod
NAME                                           READY   STATUS    RESTARTS   AGE
netology-depl-22-nfs-volume-747bb85c55-trtf5   1/1     Running   0          20m

root@microk8s:~# kubectl exec netology-depl-22-nfs-volume-747bb85c55-trtf5 -c network-multitool -it -- sh

/ # ls -la /pvc-nfs-vlm/
total 4
drwxrwxrwx    1 root     root            34 Apr 27 19:11 .
drwxr-xr-x    1 root     root          4096 Apr 27 19:03 ..
-rwxrwxrwx    1 root     root             0 Apr 27 19:11 netology-test.txt
```

- Произведем запись тестовой информации в фаил но ноде:

```bash
root@microk8s:~# cd /nfs/vlm2/pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e/

root@microk8s:/nfs/vlm2/pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e# cat << EOF > netology-test.txt > netology course DevOps 19 test > EOF

root@microk8s:/nfs/vlm2/pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e# cat "/nfs/vlm2/pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e/netology-test.txt"
netology course DevOps 19 test
```

- Читаем тестовый фаил:

```bash
root@microk8s:/nfs/vlm2/pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e# kubectl exec netology-depl-22-nfs-volume-747bb85c55-trtf5 -c network-multitool -it -- sh
/ # ls -la /pvc-nfs-vlm/
total 8
drwxrwxrwx    1 root     root            34 Apr 27 19:11 .
drwxr-xr-x    1 root     root          4096 Apr 27 19:03 ..
-rwxrwxrwx    1 root     root            31 Apr 27 19:17 netology-test.txt

/ # cat /pvc-nfs-vlm/netology-test.txt
netology course DevOps 19 test
```

- Пишем в файл в PODе

```bash
/ # cd /pvc-nfs-vlm/

/pvc-nfs-vlm # ls -la
total 8
drwxrwxrwx    1 root     root            34 Apr 27 19:11 .
drwxr-xr-x    1 root     root          4096 Apr 29 16:29 ..
-rwxrwxrwx    1 root     root            31 Apr 27 19:17 netology-test.txt

/pvc-nfs-vlm # cat << EOF >> netology-test.txt
> Test write string from POD
> EOF

/pvc-nfs-vlm # cat netology-test.txt
netology course DevOps 19 test
Test write string from POD
```

- Читаем изменения на НОДе

```bash
root@microk8s:~# cat /nfs/vlm2/pvc-ee7e68dd-0d0e-4a9c-aa40-97edf9329e3e/netology-test.txt
netology course DevOps 19 test
Test write string from POD
```

4. Манифесты Deployment, а также скриншоты или вывод команды из п. 2.:

[netology-depl22-nfs.yaml](/kubernetes/netology-depl22-nfs.yaml)
[netology-storageclass.yaml](/kubernetes/netology-storageclass.yaml)
[netology-pvc-nfs.yaml](/kubernetes/netology-pvc-nfs.yaml)

<img src="img/HW 12.7 MicroK8S nfs.png"/>
