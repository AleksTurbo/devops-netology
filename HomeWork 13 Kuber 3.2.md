# Домашнее задание к занятию "3.2 Установка Kubernetes"

## Задание 1 - Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды:

- подготовим 5 ВМ на гипервизоре ProxMox

```bash
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
qm create 9000 --memory 2048 --cores 4 --net0 virtio,bridge=vmbr0 --name Ubuntu-20.04-CloudInit-template
qm importdisk 9000 focal-server-cloudimg-amd64.img nvme512
qm set 9000 --scsihw virtio-scsi-pci --scsi0 nvme512:vm-9000-disk-0
qm set 9000 --scsihw virtio-scsi-pci --scsi0 nvme512:9000/vm-9000-disk-0.raw
qm set 9000 --ide2 nvme512:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm template 9000
qm clone 9000 9001 --name kube-template --full --storage nvme512
qm set 9001 --memory 4096 --agent enabled=1
qm resize 9001 scsi0 3G
sudo apt-get install qemu-guest-agent
qm template 9001
...
qm clone 9001 200 --name kube-master --full --storage nvme512
qm resize 200 scsi0 15G
```

```bash
root@pve:~# qm list
      VMID NAME                 STATUS     MEM(MB)    BOOTDISK(GB) PID
       200 kube-master          running    4096              15.00 54840
       201 kube-worker1         running    4096              40.00 79046
       202 kube-worker2         running    4096              40.00 80930
       203 kube-worker3         running    4096              40.00 81605
       204 kube-worker4         running    4096              40.00 82165
```

- настраиваем видимость машин

```bash
root@kube-master:~# cat /etc/hosts
#
127.0.1.1 kube-master kube-master
127.0.0.1 localhost
192.168.84.79 kube-master
192.168.84.78 kube-worker1
192.168.84.77 kube-worker2
192.168.84.76 kube-worker3
192.168.84.75 kube-worker4
```

<img src="img/HW 13 K8S 5 VM.png"/>

2. Устанавливаем компоненты кластера:

- Буду использовать способ установки инструментом "kubeadm"

```bash
root@kube-master:~# apt install apt-transport-https ca-certificates curl
Reading package lists... Done
Building dependency tree
Reading state information... Done
ca-certificates is already the newest version (20230311ubuntu0.20.04.1).
ca-certificates set to manually installed.
curl is already the newest version (7.68.0-1ubuntu2.18).
curl set to manually installed.
The following NEW packages will be installed:
  apt-transport-https
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 1704 B of archives.
After this operation, 162 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 apt-transport-https all 2.0.9 [1704 B]
Fetched 1704 B in 0s (3955 B/s)
Selecting previously unselected package apt-transport-https.
(Reading database ... 95098 files and directories currently installed.)
Preparing to unpack .../apt-transport-https_2.0.9_all.deb ...
Unpacking apt-transport-https (2.0.9) ...
Setting up apt-transport-https (2.0.9) ...
root@kube-master:~# curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
root@kube-master:~# curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
gpg: can't create '/etc/apt/keyrings/kubernetes-archive-keyring.gpg': No such file or directory
gpg: no valid OpenPGP data found.
gpg: dearmoring failed: No such file or directory
(23) Failed writing body
root@kube-master:~# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -^C
root@kube-master:~# curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
root@kube-master:~# curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
root@kube-master:~# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2659  100  2659    0     0  18337      0 --:--:-- --:--:-- --:--:-- 18337
OK
root@kube-master:~# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/a                       pt/sources.list.d/kubernetes.list
deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main
root@kube-master:~# echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt                       /sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main
root@kube-master:~#
root@kube-master:~# sudo apt-get update
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:3 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu focal-backports InRelease
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [8993 B]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [67.3 kB]
Fetched 76.2 kB in 1s (57.2 kB/s)
Reading package lists... Done
root@kube-master:~# apt install kubelet kubeadm kubectl containerd
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  conntrack cri-tools ebtables kubernetes-cni runc socat
Suggested packages:
  nftables
The following NEW packages will be installed:
  conntrack containerd cri-tools ebtables kubeadm kubectl kubelet kubernetes-cni runc socat
0 upgraded, 10 newly installed, 0 to remove and 0 not upgraded.
Need to get 121 MB of archives.
After this operation, 480 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 conntrack amd64 1:1.4.5-2 [30.3 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 runc amd64 1.1.4-0ubuntu1~20.04.3 [3819 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 cri-tools amd64 1.26.0-00 [18.9 MB]
Get:8 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 containerd amd64 1.6.12-0ubuntu1~20.04.1 [31.4 MB]
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 1.2.0-00 [27.6 MB]
Get:9 http://archive.ubuntu.com/ubuntu focal/main amd64 ebtables amd64 2.0.11-3build1 [80.3 kB]
Get:10 http://archive.ubuntu.com/ubuntu focal/main amd64 socat amd64 1.7.3.3-2 [323 kB]
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.27.3-00 [18.7 MB]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.27.3-00 [10.2 MB]
Get:7 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.27.3-00 [9918 kB]
Fetched 121 MB in 13s (9346 kB/s)
Selecting previously unselected package conntrack.
(Reading database ... 95102 files and directories currently installed.)
Preparing to unpack .../0-conntrack_1%3a1.4.5-2_amd64.deb ...
Unpacking conntrack (1:1.4.5-2) ...
Selecting previously unselected package runc.
Preparing to unpack .../1-runc_1.1.4-0ubuntu1~20.04.3_amd64.deb ...
Unpacking runc (1.1.4-0ubuntu1~20.04.3) ...
Selecting previously unselected package containerd.
Preparing to unpack .../2-containerd_1.6.12-0ubuntu1~20.04.1_amd64.deb ...
Unpacking containerd (1.6.12-0ubuntu1~20.04.1) ...
Selecting previously unselected package cri-tools.
Preparing to unpack .../3-cri-tools_1.26.0-00_amd64.deb ...
Unpacking cri-tools (1.26.0-00) ...
Selecting previously unselected package ebtables.
Preparing to unpack .../4-ebtables_2.0.11-3build1_amd64.deb ...
Unpacking ebtables (2.0.11-3build1) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../5-kubernetes-cni_1.2.0-00_amd64.deb ...
Unpacking kubernetes-cni (1.2.0-00) ...
Selecting previously unselected package socat.
Preparing to unpack .../6-socat_1.7.3.3-2_amd64.deb ...
Unpacking socat (1.7.3.3-2) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../7-kubelet_1.27.3-00_amd64.deb ...
Unpacking kubelet (1.27.3-00) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../8-kubectl_1.27.3-00_amd64.deb ...
Unpacking kubectl (1.27.3-00) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../9-kubeadm_1.27.3-00_amd64.deb ...
Unpacking kubeadm (1.27.3-00) ...
Setting up conntrack (1:1.4.5-2) ...
Setting up runc (1.1.4-0ubuntu1~20.04.3) ...
Setting up kubectl (1.27.3-00) ...
Setting up ebtables (2.0.11-3build1) ...
Setting up socat (1.7.3.3-2) ...
Setting up cri-tools (1.26.0-00) ...
Setting up containerd (1.6.12-0ubuntu1~20.04.1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up kubernetes-cni (1.2.0-00) ...
Setting up kubelet (1.27.3-00) ...
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
Setting up kubeadm (1.27.3-00) ...
Processing triggers for man-db (2.9.1-1) ...

root@kube-master:~# modprobe br_netfilter
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.confroot@kube-master:~# echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
root@kube-master:~# echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
root@kube-master:~# echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
root@kube-master:~# echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
root@kube-master:~# sysctl -p /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
```

3. Инициализируем кластер:

```bash
root@kube-master:~# kubeadm init \
>  --apiserver-advertise-address=192.168.84.79 \
>  --pod-network-cidr 10.244.0.0/16 \
>  --apiserver-cert-extra-sans=45.157.213.141
[init] Using Kubernetes version: v1.27.3
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W0622 15:05:10.475105    4347 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used                        by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kube-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] an                       d IPs [10.96.0.1 192.168.84.79 45.157.213.141]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [kube-master localhost] and IPs [192.168.84.79 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [kube-master localhost] and IPs [192.168.84.79 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 7.002369 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node kube-master as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-e                       xternal-load-balancers]
[mark-control-plane] Marking the node kube-master as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: 0kmi2z.u87ug4tsvqhf9i68
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.84.79:6443 --token 0kmi2z.u87ug4tsvqhf9i68 \
        --discovery-token-ca-cert-hash sha256:dcff59c2026e9fbf289411fa75b89861d0a894b36eed7d657c3d2a4caaf83e6f
```

- Подключаем ноды:

```bash
root@kube-worker1:~# kubeadm join 192.168.84.79:6443 --token blqttr.ypapjiamjveddb85 --discovery-token-ca-cert-hash sha256:dcff59c2026e9fbf289411fa75b89861d0a894b36eed7d657c3d2a4caaf83e6f
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

- повторяем на остальных рабочих нодах

- проверяем результат:

```bash
root@kube-master:~# kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
kube-master    Ready    control-plane   3h46m   v1.27.3
kube-worker1   Ready    <none>          86m     v1.27.3
kube-worker2   Ready    <none>          68m     v1.27.3
kube-worker3   Ready    <none>          61m     v1.27.3
kube-worker4   Ready    <none>          58m     v1.27.3
```

```bash
root@kube-master:~# kubectl get all --all-namespaces
NAMESPACE      NAME                                      READY   STATUS    RESTARTS   AGE
default        pod/nginx-7bf8c77b5b-85x7x                1/1     Running   0          46m
default        pod/nginx-7bf8c77b5b-c86wb                1/1     Running   0          46m
default        pod/nginx-7bf8c77b5b-nhgkh                1/1     Running   0          46m
default        pod/nginx-7bf8c77b5b-wzh9d                1/1     Running   0          46m
default        pod/prometheus-alertmanager-0             1/1     Running   0          39m
default        pod/prometheus-server-85dd8b66db-tvtkh    1/1     Running   0          39m
kube-flannel   pod/kube-flannel-ds-fk9qj                 1/1     Running   0          64m
kube-flannel   pod/kube-flannel-ds-lpr9q                 1/1     Running   0          106m
kube-flannel   pod/kube-flannel-ds-nvzqd                 1/1     Running   0          56m
kube-flannel   pod/kube-flannel-ds-p9bbt                 1/1     Running   0          53m
kube-flannel   pod/kube-flannel-ds-vqf7t                 1/1     Running   0          81m
kube-system    pod/coredns-5d78c9869d-5vhjr              1/1     Running   0          3h41m
kube-system    pod/coredns-5d78c9869d-jkbd7              1/1     Running   0          3h41m
kube-system    pod/etcd-kube-master                      1/1     Running   0          3h41m
kube-system    pod/kube-apiserver-kube-master            1/1     Running   0          3h41m
kube-system    pod/kube-controller-manager-kube-master   1/1     Running   0          3h41m
kube-system    pod/kube-proxy-5ngxc                      1/1     Running   0          64m
kube-system    pod/kube-proxy-6kxpd                      1/1     Running   0          3h41m
kube-system    pod/kube-proxy-fbjb9                      1/1     Running   0          56m
kube-system    pod/kube-proxy-fmj2d                      1/1     Running   0          81m
kube-system    pod/kube-proxy-kc8cp                      1/1     Running   0          53m
kube-system    pod/kube-scheduler-kube-master            1/1     Running   0          3h41m
portainer      pod/portainer-agent-7f8c6dd885-w4jgg      1/1     Running   0          52m

NAMESPACE     NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes                 ClusterIP      10.96.0.1        <none>        443/TCP                  3h41m
default       service/nginx                      ClusterIP      10.105.30.13     <none>        20080/TCP                43m
default       service/nginx-2                    NodePort       10.109.182.203   <none>        80:30080/TCP             42m
default       service/prometheus-alertmanager    LoadBalancer   10.104.69.196    <pending>     80:32230/TCP             39m
default       service/prometheus-server          LoadBalancer   10.101.154.56    <pending>     80:32077/TCP             39m
kube-system   service/kube-dns                   ClusterIP      10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   3h41m
portainer     service/portainer-agent            NodePort       10.102.141.107   <none>        9001:30778/TCP           73m
portainer     service/portainer-agent-headless   ClusterIP      None             <none>        <none>                   73m

NAMESPACE      NAME                             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-flannel   daemonset.apps/kube-flannel-ds   5         5         5       5            5           <none>                   106m
kube-system    daemonset.apps/kube-proxy        5         5         5       5            5           kubernetes.io/os=linux   3h41m

NAMESPACE     NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
default       deployment.apps/nginx               4/4     4            4           46m
default       deployment.apps/prometheus-server   1/1     1            1           39m
kube-system   deployment.apps/coredns             2/2     2            2           3h41m
portainer     deployment.apps/portainer-agent     1/1     1            1           73m

NAMESPACE     NAME                                           DESIRED   CURRENT   READY   AGE
default       replicaset.apps/nginx-7bf8c77b5b               4         4         4       46m
default       replicaset.apps/prometheus-server-85dd8b66db   1         1         1       39m
kube-system   replicaset.apps/coredns-5d78c9869d             2         2         2       3h41m
portainer     replicaset.apps/portainer-agent-7759b947bd     0         0         0       73m
portainer     replicaset.apps/portainer-agent-7f8c6dd885     1         1         1       52m

NAMESPACE   NAME                                       READY   AGE
default     statefulset.apps/prometheus-alertmanager   1/1     39m

```

4. Пробуем развернуть приложение:

```bash
root@kube-master:~# kubectl create deploy nginx --image=nginx:latest --replicas=4
deployment.apps/nginx created

root@kube-master:~# kubectl get pod -o wide
NAME                                 READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
nginx-7bf8c77b5b-85x7x               1/1     Running   0          55m   10.244.2.3   kube-worker2   <none>           <none>
nginx-7bf8c77b5b-c86wb               1/1     Running   0          55m   10.244.1.3   kube-worker1   <none>           <none>
nginx-7bf8c77b5b-nhgkh               1/1     Running   0          55m   10.244.4.2   kube-worker4   <none>           <none>
nginx-7bf8c77b5b-wzh9d               1/1     Running   0          55m   10.244.3.2   kube-worker3   <none>           <none>
```

<img src="img/HW 13 K8S nodes.png"/>

-

<img src="img/HW 13 K8S pods.png"/>

-

<img src="img/HW 13 K8S nginx.png"/>