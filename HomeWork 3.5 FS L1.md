1. Ознакомился с механизмом "Разрежённый файл". Пригодится для файлов большого размера, содержимое которого заполняется со временем. Например образ диска виртуальной машины.   Получается механизм компрессии на уровне фаиловой системы.
2. Файлы, являющиеся жесткой ссылкой на один объект, не могут иметь разные права доступа и владельца. Для системы нет отличия - какой хардлинк первичный, какой вторичный. Все хардлинки равнозначны для одной inode. Значит и права должны быть идентичными.  
aleksturbo@AlksTrbNout:~$ touch testfile1
aleksturbo@AlksTrbNout:~$ ln testfile1 testfile2
aleksturbo@AlksTrbNout:~$ ls -la
    -rw-r--r--  2 aleksturbo aleksturbo       0 июн 22 12:59 testfile1
    -rw-r--r--  2 aleksturbo aleksturbo       0 июн 22 12:59 testfile2
aleksturbo@AlksTrbNout:~$ chmod 0777 testfile1
aleksturbo@AlksTrbNout:~$ ls -ilh
    43414 -rwxrwxrwx 2 aleksturbo aleksturbo    0 июн 22 12:59 testfile1
    43414 -rwxrwxrwx 2 aleksturbo aleksturbo    0 июн 22 12:59 testfile2
3. Пересобрал vagrant машину
    vagrant@vagrant:~$ lsblk
        NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        sda                         8:0    0   64G  0 disk
        ├─sda1                      8:1    0    1M  0 part
        ├─sda2                      8:2    0    1G  0 part /boot
        └─sda3                      8:3    0   63G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
        sdb                         8:16   0  2.5G  0 disk
        sdc                         8:32   0  2.5G  0 disk
4.  vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
        Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK   
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: dos
        Disk identifier: 0xd9c5e51f

        Device     Boot   Start     End Sectors  Size Id Type
        /dev/sdb1          2048 4196351 4194304    2G 83 Linux
        /dev/sdb2       4196352 5242879 1046528  511M 83 Linux

5. vagrant@vagrant:~$ sudo -i
        root@vagrant:~# sfdisk -d /dev/sdb|sfdisk --force /dev/sdc
        Checking that no-one is using this disk right now ... OK

        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK   
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes

        >>> Script header accepted.
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Created a new DOS disklabel with disk identifier 0xd9c5e51f.
        /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
        /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
        /dev/sdc3: Done.

        New situation:
        Disklabel type: dos
        Disk identifier: 0xd9c5e51f

        Device     Boot   Start     End Sectors  Size Id Type
        /dev/sdc1          2048 4196351 4194304    2G 83 Linux
        /dev/sdc2       4196352 5242879 1046528  511M 83 Linux

        The partition table has been altered.
        Calling ioctl() to re-read partition table.
        Syncing disks.
root@vagrant:~# lsblk
        NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        loop0                       7:0    0 55.5M  1 loop /snap/core18/2409
        loop1                       7:1    0 55.4M  1 loop /snap/core18/2128
        loop2                       7:2    0 61.9M  1 loop /snap/core20/1494
        loop3                       7:3    0 67.8M  1 loop /snap/lxd/22753
        loop4                       7:4    0 70.3M  1 loop /snap/lxd/21029
        loop5                       7:5    0 44.7M  1 loop /snap/snapd/15904
        loop6                       7:6    0   47M  1 loop /snap/snapd/16010
        loop7                       7:7    0 61.9M  1 loop /snap/core20/1518
        sda                         8:0    0   64G  0 disk
        ├─sda1                      8:1    0    1M  0 part
        ├─sda2                      8:2    0    1G  0 part /boot
        └─sda3                      8:3    0   63G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
        sdb                         8:16   0  2.5G  0 disk
        ├─sdb1                      8:17   0    2G  0 part
        └─sdb2                      8:18   0  511M  0 part
        sdc                         8:32   0  2.5G  0 disk
        ├─sdc1                      8:33   0    2G  0 part
        └─sdc2                      8:34   0  511M  0 part
6. vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}
        mdadm: Note: this array has metadata at the start and
            may not be suitable as a boot device.  If you plan to
            store '/boot' on this device please ensure that
            your boot-loader understands md/v1.x metadata, or use
            --metadata=0.90
        mdadm: size set to 2094080K
        Continue creating array? y
        mdadm: Defaulting to version 1.2 metadata
        mdadm: array /dev/md1 started.
    vagrant@vagrant:~$ sudo cat /proc/mdstat
        Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
        md1 : active raid1 sdc1[1] sdb1[0]
            2094080 blocks super 1.2 [2/2] [UU]
7. vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b2,c2}
        mdadm: Note: this array has metadata at the start and
            may not be suitable as a boot device.  If you plan to
            store '/boot' on this device please ensure that
            your boot-loader understands md/v1.x metadata, or use
            --metadata=0.90
        mdadm: size set to 522240K
        Continue creating array? y
        mdadm: Defaulting to version 1.2 metadata
        mdadm: array /dev/md0 started.
    vagrant@vagrant:~$ sudo cat /proc/mdstat
        Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
        md0 : active raid1 sdc2[1] sdb2[0]
            522240 blocks super 1.2 [2/2] [UU]

        md1 : active raid1 sdc1[1] sdb1[0]
            2094080 blocks super 1.2 [2/2] [UU]
    vagrant@vagrant:~$ lsblk
            sdb                         8:16   0  2.5G  0 disk
        ├─sdb1                      8:17   0    2G  0 part
        │ └─md1                     9:1    0    2G  0 raid1
        └─sdb2                      8:18   0  511M  0 part
        └─md0                     9:0    0  510M  0 raid1
        sdc                         8:32   0  2.5G  0 disk
        ├─sdc1                      8:33   0    2G  0 part
        │ └─md1                     9:1    0    2G  0 raid1
        └─sdc2                      8:34   0  511M  0 part
        └─md0                     9:0    0  510M  0 raid1

8. vagrant@vagrant:~$ sudo pvcreate /dev/md1 /dev/md0
        Physical volume "/dev/md1" successfully created.
        Physical volume "/dev/md0" successfully created.

    vagrant@vagrant:~$ sudo pvs
        PV         VG        Fmt  Attr PSize   PFree  
        /dev/md0             lvm2 ---  510.00m 510.00m
        /dev/md1             lvm2 ---   <2.00g  <2.00g
        /dev/sda3  ubuntu-vg lvm2 a--  <63.00g <31.50g
9.  vagrant@vagrant:~$ sudo vgcreate vg1 /dev/md1 /dev/md0
        Volume group "vg1" successfully created
    vagrant@vagrant:~$ sudo vgdisplay
        --- Volume group ---
        VG Name               ubuntu-vg
        System ID
        Format                lvm2
        Metadata Areas        1
        Metadata Sequence No  2
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                1
        Open LV               1
        Max PV                0
        Cur PV                1
        Act PV                1
        VG Size               <63.00 GiB
        PE Size               4.00 MiB
        Total PE              16127
        Alloc PE / Size       8064 / 31.50 GiB
        Free  PE / Size       8063 / <31.50 GiB
        VG UUID               aK7Bd1-JPle-i0h7-5jJa-M60v-WwMk-PFByJ7

        --- Volume group ---
        VG Name               vg1
        System ID
        Format                lvm2
        Metadata Areas        2
        Metadata Sequence No  1
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                0
        Open LV               0
        Max PV                0
        Cur PV                2
        Act PV                2
        VG Size               2.49 GiB
        PE Size               4.00 MiB
        Total PE              638
        Alloc PE / Size       0 / 0
        Free  PE / Size       638 / 2.49 GiB
        VG UUID               GG5JJl-qLyW-5E2K-wMLw-cixB-aZ4L-qPoduA
10. vagrant@vagrant:~$ sudo lvcreate -L 100M vg1 /dev/md0
        Logical volume "lvol0" created.
    vagrant@vagrant:~$ sudo lvs
        LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
        ubuntu-lv ubuntu-vg -wi-ao----  31.50g
        lvol0     vg1       -wi-a----- 100.00m
    vagrant@vagrant:~$ sudo vgs
        VG        #PV #LV #SN Attr   VSize   VFree  
        ubuntu-vg   1   1   0 wz--n- <63.00g <31.50g
        vg1         2   1   0 wz--n-   2.49g   2.39g
11. vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg1/lvol0
        mke2fs 1.45.5 (07-Jan-2020)
        Creating filesystem with 25600 4k blocks and 25600 inodes

        Allocating group tables: done
        Writing inode tables: done
        Creating journal (1024 blocks): done
        Writing superblocks and filesystem accounting information: done
12. vagrant@vagrant:~$ sudo mkdir /tmp/new
    vagrant@vagrant:~$ sudo mount /dev/vg1/lvol0 /tmp/new

13. vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
        --2022-06-22 13:04:53--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
        Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
        Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
        HTTP request sent, awaiting response... 200 OK
        Length: 23713896 (23M) [application/octet-stream]
        Saving to: ‘/tmp/new/test.gz’
        /tmp/new/test.gz                                         100%[===============================================================================================================================>]  22.62M  2.02MB/s    in 11s     
        2022-06-22 13:05:03 (2.14 MB/s) - ‘/tmp/new/test.gz’ saved [23713896/23713896]

    vagrant@vagrant:~$ ls -la /tmp/new
        total 23184
        drwxr-xr-x  3 root root     4096 Jun 22 13:04 .
        drwxrwxrwt 13 root root     4096 Jun 22 13:03 ..
        drwx------  2 root root    16384 Jun 22 12:58 lost+found
        -rw-r--r--  1 root root 23713896 Jun 22 10:58 test.gz
14. vagrant@vagrant:~$ sudo lsblk
        NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
        sda                         8:0    0   64G  0 disk
        ├─sda1                      8:1    0    1M  0 part
        ├─sda2                      8:2    0    1G  0 part  /boot
        └─sda3                      8:3    0   63G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
        sdb                         8:16   0  2.5G  0 disk
        ├─sdb1                      8:17   0    2G  0 part
        │ └─md1                     9:1    0    2G  0 raid1
        └─sdb2                      8:18   0  511M  0 part
        └─md0                     9:0    0  510M  0 raid1
            └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
        sdc                         8:32   0  2.5G  0 disk
        ├─sdc1                      8:33   0    2G  0 part
        │ └─md1                     9:1    0    2G  0 raid1
        └─sdc2                      8:34   0  511M  0 part
        └─md0                     9:0    0  510M  0 raid1
            └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
15. vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
    vagrant@vagrant:~$ echo $?
        0

16. vagrant@vagrant:~$ sudo pvmove /dev/md0
        /dev/md0: Moved: 20.00%
        /dev/md0: Moved: 100.00%
    vagrant@vagrant:~$ sudo lsblk
        NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
        sda                         8:0    0   64G  0 disk
        ├─sda1                      8:1    0    1M  0 part
        ├─sda2                      8:2    0    1G  0 part  /boot
        └─sda3                      8:3    0   63G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
        sdb                         8:16   0  2.5G  0 disk
        ├─sdb1                      8:17   0    2G  0 part
        │ └─md1                     9:1    0    2G  0 raid1
        │   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
        └─sdb2                      8:18   0  511M  0 part
        └─md0                     9:0    0  510M  0 raid1
        sdc                         8:32   0  2.5G  0 disk
        ├─sdc1                      8:33   0    2G  0 part
        │ └─md1                     9:1    0    2G  0 raid1
        │   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
        └─sdc2                      8:34   0  511M  0 part
        └─md0                     9:0    0  510M  0 raid1

17. vagrant@vagrant:~$ sudo mdadm /dev/md1 --fail /dev/sdc1
        mdadm: set /dev/sdc1 faulty in /dev/md1
    vagrant@vagrant:~$ sudo cat /proc/mdstat
        Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
        md0 : active raid1 sdc2[1] sdb2[0]
            522240 blocks super 1.2 [2/2] [UU]
        md1 : active raid1 sdc1[1](F) sdb1[0]
            2094080 blocks super 1.2 [2/1] [U_]
18. vagrant@vagrant:~$ dmesg | grep md1
        [ 2956.669559] md/raid1:md1: not clean -- starting background reconstruction
        [ 2956.669561] md/raid1:md1: active with 2 out of 2 mirrors
        [ 2956.669636] md1: detected capacity change from 0 to 2144337920
        [ 2956.682099] md: resync of RAID array md1
        [ 2967.020134] md: md1: resync done.
        [11656.450827] md/raid1:md1: Disk failure on sdc1, disabling device.
                    md/raid1:md1: Operation continuing on 1 devices.
19. vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
        vagrant@vagrant:~$ echo $?
        0
20. vagrant@vagrant:~$ exit
        logout
        Connection to 127.0.0.1 closed.
    PS D:\netology\vagrant> vagrant destroy
            default: Are you sure you want to destroy the 'default' VM? [y/N] ==> default: Forcing shutdown of VM...
        ==> default: Destroying VM and associated drives...