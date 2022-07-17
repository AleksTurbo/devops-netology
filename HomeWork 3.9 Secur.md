# Домашняя работа  к занятию "3.9. Элементы безопасности информационных систем"

## 1. Bitwarden плагин:

## 2. Bitwarden 2 factor autoruty:

## 3. Apache2 
    root@pve:~# apt install apache2
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
        Generating a RSA private key
        .............+++++
        ................+++++
        writing new private key to '/etc/ssl/private/apache-selfsigned.key'

    nano /etc/apache2/conf-available/ssl-params.conf
        SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
        SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLHonorCipherOrder On
        Header always set X-Frame-Options DENY
        Header always set X-Content-Type-Options nosniff
        SSLCompression off
        SSLUseStapling on
        SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
        SSLSessionTickets Off
    
    ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

    nano /etc/apache2/sites-available/default-ssl.conf
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

    ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

    a2enmod ssl
    a2enmod headers
    apache2ctl configtest
    systemctl restart apache2

    