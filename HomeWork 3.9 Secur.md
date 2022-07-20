# Домашняя работа  к занятию "3.9. Элементы безопасности информационных систем"

## 1. Bitwarden плагин установлен: 
![Bitwarden плагин](https://github.com/AleksTurbo/devops-netology/blob/main/PluginBitwarden.png "Bitwarden плагин")

## 2. Bitwarden 2 factor autoruty включено: 
![Bitwarden 2 factor autoruty](https://github.com/AleksTurbo/devops-netology/blob/main/Bitwarden2FactorAutority.png "Bitwarden 2 factor autoruty")

## 3. Apache2 
```bash
root@pve:~# apt install apache2
root@pve:~# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
```        
        Generating a RSA private key
        .............+++++
        ................+++++
        writing new private key to '/etc/ssl/private/apache-selfsigned.key'

```bash
root@pve:~# nano /etc/apache2/conf-available/ssl-params.conf
```
        SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
        SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLHonorCipherOrder On
        Header always set X-Frame-Options DENY
        Header always set X-Content-Type-Options nosniff
        SSLCompression off
        SSLUseStapling on
        SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
        SSLSessionTickets Off
    
```ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf```

```nano /etc/apache2/sites-available/default-ssl.conf```

        <IfModule mod_ssl.c>
            <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost
                DocumentRoot /usr/share/apache2/default-site
                ServerName pve
                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on
                SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                        SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                        SSLOptions +StdEnvVars
                </Directory>

            </VirtualHost>
        </IfModule>

```ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf```

```a2enmod ssl```<br>
```a2enmod headers```<br>
```apache2ctl configtest```<br>
    ```systemctl restart apache2```

![Apache2SSL](https://github.com/AleksTurbo/devops-netology/blob/main/Apache2SSL.png "Apache2SSL")

 ## 4. TLS 
```apt install sslscan```<br>
```sslscan https://aleksturbo.sytes.net```

        Version: 2.0.7
        OpenSSL 1.1.1n  15 Mar 2022

        Connected to 178.155.12.9

        Testing SSL server aleksturbo.sytes.net on port 443 using SNI name aleksturbo.sytes.net

        SSL/TLS Protocols:
        SSLv2     disabled
        SSLv3     disabled
        TLSv1.0   enabled
        TLSv1.1   enabled
        TLSv1.2   enabled
        TLSv1.3   enabled

        TLS Fallback SCSV:
        Server supports TLS Fallback SCSV

        TLS renegotiation:
        Secure session renegotiation supported

        TLS Compression:
        OpenSSL version does not support compression
        Rebuild with zlib1g-dev package for zlib support

        Heartbleed:
        TLSv1.3 not vulnerable to heartbleed
        TLSv1.2 not vulnerable to heartbleed
        TLSv1.1 not vulnerable to heartbleed
        TLSv1.0 not vulnerable to heartbleed

        Supported Server Cipher(s):
        Preferred TLSv1.3  256 bits  TLS_AES_256_GCM_SHA384        Curve 25519 DHE 253
        Accepted  TLSv1.3  256 bits  TLS_CHACHA20_POLY1305_SHA256  Curve 25519 DHE 253
        Accepted  TLSv1.3  128 bits  TLS_AES_128_GCM_SHA256        Curve 25519 DHE 253
        Preferred TLSv1.2  256 bits  ECDHE-RSA-AES256-GCM-SHA384   Curve 25519 DHE 253
        Accepted  TLSv1.2  256 bits  DHE-RSA-AES256-GCM-SHA384     DHE 2048 bits
        Accepted  TLSv1.2  256 bits  ECDHE-RSA-CHACHA20-POLY1305   Curve 25519 DHE 253
        Accepted  TLSv1.2  256 bits  DHE-RSA-CHACHA20-POLY1305     DHE 2048 bits
        Accepted  TLSv1.2  256 bits  DHE-RSA-AES256-CCM8           DHE 2048 bits
        Accepted  TLSv1.2  256 bits  DHE-RSA-AES256-CCM            DHE 2048 bits
        Accepted  TLSv1.2  256 bits  ECDHE-ARIA256-GCM-SHA384      Curve 25519 DHE 253
        Accepted  TLSv1.2  256 bits  DHE-RSA-ARIA256-GCM-SHA384    DHE 2048 bits
        Accepted  TLSv1.2  128 bits  ECDHE-RSA-AES128-GCM-SHA256   Curve 25519 DHE 253
        Accepted  TLSv1.2  128 bits  DHE-RSA-AES128-GCM-SHA256     DHE 2048 bits
        Accepted  TLSv1.2  128 bits  DHE-RSA-AES128-CCM8           DHE 2048 bits
        Accepted  TLSv1.2  128 bits  DHE-RSA-AES128-CCM            DHE 2048 bits
        Accepted  TLSv1.2  128 bits  ECDHE-ARIA128-GCM-SHA256      Curve 25519 DHE 253
        Accepted  TLSv1.2  128 bits  DHE-RSA-ARIA128-GCM-SHA256    DHE 2048 bits
        Accepted  TLSv1.2  256 bits  ECDHE-RSA-AES256-SHA384       Curve 25519 DHE 253
        Accepted  TLSv1.2  256 bits  DHE-RSA-AES256-SHA256         DHE 2048 bits
        Accepted  TLSv1.2  256 bits  ECDHE-RSA-CAMELLIA256-SHA384  Curve 25519 DHE 253
        Accepted  TLSv1.2  256 bits  DHE-RSA-CAMELLIA256-SHA256    DHE 2048 bits
        Accepted  TLSv1.2  128 bits  ECDHE-RSA-AES128-SHA256       Curve 25519 DHE 253
        Accepted  TLSv1.2  128 bits  DHE-RSA-AES128-SHA256         DHE 2048 bits
        Accepted  TLSv1.2  128 bits  ECDHE-RSA-CAMELLIA128-SHA256  Curve 25519 DHE 253
        Accepted  TLSv1.2  128 bits  DHE-RSA-CAMELLIA128-SHA256    DHE 2048 bits
        Accepted  TLSv1.2  256 bits  ECDHE-RSA-AES256-SHA          Curve 25519 DHE 253
        Accepted  TLSv1.2  256 bits  DHE-RSA-AES256-SHA            DHE 2048 bits
        Accepted  TLSv1.2  256 bits  DHE-RSA-CAMELLIA256-SHA       DHE 2048 bits
        Accepted  TLSv1.2  128 bits  ECDHE-RSA-AES128-SHA          Curve 25519 DHE 253
        Accepted  TLSv1.2  128 bits  DHE-RSA-AES128-SHA            DHE 2048 bits
        Accepted  TLSv1.2  128 bits  DHE-RSA-CAMELLIA128-SHA       DHE 2048 bits
        Accepted  TLSv1.2  256 bits  AES256-GCM-SHA384
        Accepted  TLSv1.2  256 bits  AES256-CCM8
        Accepted  TLSv1.2  256 bits  AES256-CCM
        Accepted  TLSv1.2  256 bits  ARIA256-GCM-SHA384
        Accepted  TLSv1.2  128 bits  AES128-GCM-SHA256
        Accepted  TLSv1.2  128 bits  AES128-CCM8
        Accepted  TLSv1.2  128 bits  AES128-CCM
        Accepted  TLSv1.2  128 bits  ARIA128-GCM-SHA256
        Accepted  TLSv1.2  256 bits  AES256-SHA256
        Accepted  TLSv1.2  256 bits  CAMELLIA256-SHA256
        Accepted  TLSv1.2  128 bits  AES128-SHA256
        Accepted  TLSv1.2  128 bits  CAMELLIA128-SHA256
        Accepted  TLSv1.2  256 bits  AES256-SHA
        Accepted  TLSv1.2  256 bits  CAMELLIA256-SHA
        Accepted  TLSv1.2  128 bits  AES128-SHA
        Accepted  TLSv1.2  128 bits  CAMELLIA128-SHA
        Accepted  TLSv1.2  128 bits  DHE-RSA-SEED-SHA              DHE 2048 bits
        Accepted  TLSv1.2  128 bits  SEED-SHA
        Preferred TLSv1.1  256 bits  ECDHE-RSA-AES256-SHA          Curve 25519 DHE 253
        Accepted  TLSv1.1  256 bits  DHE-RSA-AES256-SHA            DHE 2048 bits
        Accepted  TLSv1.1  256 bits  DHE-RSA-CAMELLIA256-SHA       DHE 2048 bits
        Accepted  TLSv1.1  128 bits  ECDHE-RSA-AES128-SHA          Curve 25519 DHE 253
        Accepted  TLSv1.1  128 bits  DHE-RSA-AES128-SHA            DHE 2048 bits
        Accepted  TLSv1.1  128 bits  DHE-RSA-CAMELLIA128-SHA       DHE 2048 bits
        Accepted  TLSv1.1  256 bits  AES256-SHA
        Accepted  TLSv1.1  256 bits  CAMELLIA256-SHA
        Accepted  TLSv1.1  128 bits  AES128-SHA
        Accepted  TLSv1.1  128 bits  CAMELLIA128-SHA
        Accepted  TLSv1.1  128 bits  DHE-RSA-SEED-SHA              DHE 2048 bits
        Accepted  TLSv1.1  128 bits  SEED-SHA
        Accepted  TLSv1.1  128 bits  TLS_RSA_WITH_IDEA_CBC_SHA
        Preferred TLSv1.0  256 bits  ECDHE-RSA-AES256-SHA          Curve 25519 DHE 253
        Accepted  TLSv1.0  256 bits  DHE-RSA-AES256-SHA            DHE 2048 bits
        Accepted  TLSv1.0  256 bits  DHE-RSA-CAMELLIA256-SHA       DHE 2048 bits
        Accepted  TLSv1.0  128 bits  ECDHE-RSA-AES128-SHA          Curve 25519 DHE 253
        Accepted  TLSv1.0  128 bits  DHE-RSA-AES128-SHA            DHE 2048 bits
        Accepted  TLSv1.0  128 bits  DHE-RSA-CAMELLIA128-SHA       DHE 2048 bits
        Accepted  TLSv1.0  256 bits  AES256-SHA
        Accepted  TLSv1.0  256 bits  CAMELLIA256-SHA
        Accepted  TLSv1.0  128 bits  AES128-SHA
        Accepted  TLSv1.0  128 bits  CAMELLIA128-SHA
        Accepted  TLSv1.0  128 bits  DHE-RSA-SEED-SHA              DHE 2048 bits
        Accepted  TLSv1.0  128 bits  SEED-SHA
        Accepted  TLSv1.0  128 bits  TLS_RSA_WITH_IDEA_CBC_SHA

        Server Key Exchange Group(s):
        TLSv1.3  128 bits  secp256r1 (NIST P-256)
        TLSv1.3  192 bits  secp384r1 (NIST P-384)
        TLSv1.3  260 bits  secp521r1 (NIST P-521)
        TLSv1.3  128 bits  x25519
        TLSv1.3  224 bits  x448
        TLSv1.2  128 bits  secp256r1 (NIST P-256)
        TLSv1.2  192 bits  secp384r1 (NIST P-384)
        TLSv1.2  260 bits  secp521r1 (NIST P-521)
        TLSv1.2  128 bits  x25519
        TLSv1.2  224 bits  x448

        SSL Certificate:
        Signature Algorithm: sha256WithRSAEncryption
        RSA Key Strength:    2048

        Subject:  aleksturbo.sytes.net
        Altnames: DNS:aleksturbo.sytes.net
        Issuer:   R3

        Not valid before: Jul 11 18:00:52 2022 GMT
        Not valid after:  Oct  9 18:00:51 2022 GMT

 ## 5. ssh
```vagrant up```
```vagrant ssh control```

```vagrant@control:~$ ssh-keygen```

    Generating public/private rsa key pair.
        Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): 
        /home/vagrant/.ssh/id_rsa already exists.
        Overwrite (y/n)? y
        Enter passphrase (empty for no passphrase): 
        Enter same passphrase again:
        Your identification has been saved in /home/vagrant/.ssh/id_rsa
        Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
        The key fingerprint is:
        SHA256:uoCtqkN8/CR6O2d+DqWo9XGdEPshVnP5BNc1z4YGWH4 vagrant@control
        The key's randomart image is:
        +---[RSA 3072]----+
        |           +o...o|
        |          ..+. +o|
        |       . o o..E +|
        |        + o oo . |
        |. .    *S.   .   |
        | o *..+.= o      |
        |. +o*+.. +       |
        |..o+.=+o         |
        |++o.*o+.         |
        +----[SHA256]-----+

```vagrant@control:~$ ssh-copy-id node1 && ssh-copy-id node2 && ssh-copy-id node3```

        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        vagrant@node1's password:

        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'node1'"
        and check to make sure that only the key(s) you wanted were added.

        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        vagrant@node2's password: 

        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'node2'"
        and check to make sure that only the key(s) you wanted were added.

        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        vagrant@node3's password: 

        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'node3'"
        and check to make sure that only the key(s) you wanted were added.

```vagrant@control:~$ ssh vagrant@node1```

            Welcome to Ubuntu 20.10 (GNU/Linux 5.8.0-63-generic x86_64)

            * Documentation:  https://help.ubuntu.com
            * Management:     https://landscape.canonical.com
            * Support:        https://ubuntu.com/advantage

            System information as of Sun Jul 17 06:34:44 PM UTC 2022

            System load:                      0.02
            Usage of /:                       15.7% of 30.88GB
            Memory usage:                     66%
            Swap usage:                       5%
            Processes:                        114
            Users logged in:                  0
            IPv4 address for br-19c29771acc0: 172.18.0.1
            IPv4 address for docker0:         172.17.0.1
            IPv4 address for docker_gwbridge: 172.19.0.1
            IPv4 address for eth0:            10.0.2.15
            IPv4 address for eth1:            192.168.56.51


            This system is built by the Bento project by Chef Software
            More information can be found at https://github.com/chef/bento
            Last login: Mon May 16 18:48:20 2022 from 192.168.56.50
            vagrant@node1:~$ 
 ## 6. ssh node

```vagrant@control:~$ mv ~/.ssh/id_rsa ~/.ssh/id_rsa_node```
```vagrant@control:~$ sudo nano ~/.ssh/config```

        Host node1
        HostName 192.168.56.51
        User vagrant
        Port 22
        IdentityFile ~/.ssh/id_rsa_node
   
```vagrant@control:~$ ssh node1```

        Welcome to Ubuntu 20.10 (GNU/Linux 5.8.0-63-generic x86_64)

        * Documentation:  https://help.ubuntu.com
        * Management:     https://landscape.canonical.com
        * Support:        https://ubuntu.com/advantage

        System information as of Sun Jul 17 06:45:31 PM UTC 2022

        System load:                      0.01
        Usage of /:                       16.4% of 30.88GB
        Memory usage:                     59%
        Swap usage:                       7%
        Processes:                        113
        Users logged in:                  0
        IPv4 address for br-19c29771acc0: 172.18.0.1
        IPv4 address for docker0:         172.17.0.1
        IPv4 address for docker_gwbridge: 172.19.0.1
        IPv4 address for eth0:            10.0.2.15
        IPv4 address for eth1:            192.168.56.51


        This system is built by the Bento project by Chef Software
        More information can be found at https://github.com/chef/bento
        Last login: Sun Jul 17 18:43:36 2022 from 192.168.56.50

 ## 7. Wireshark 
```vagrant@control:~$ sudo tcpdump -nnei any -c 100 -w 100packets.pcap```

        tcpdump: listening on any, link-type LINUX_SLL (Linux cooked v1), capture size 262144 bytes
        100 packets captured
        108 packets received by filter
        0 packets dropped by kernel
    
```vagrant@control:~$ sudo cp 100packets.pcap /vagrant/100packets.pcap```
    
![Wireshark](https://github.com/AleksTurbo/devops-netology/blob/main/Wireshark.png "Wireshark")

