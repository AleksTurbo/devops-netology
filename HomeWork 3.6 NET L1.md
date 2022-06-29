1. aleksturbo@AlksTrbNout:~$ telnet
   telnet> open stackoverflow.com 80
      Trying 151.101.129.69...
      Connected to stackoverflow.com.
      Escape character is '^]'.
   GET /questions HTTP/1.0
   HOST: stackoverflow.com

      HTTP/1.1 301 Moved Permanently
      cache-control: no-cache, no-store, must-revalidate
      location: https://stackoverflow.com/questions
      x-request-guid: 352a2c92-9ff7-4019-83c7-261e5f8b4097
      feature-policy: microphone 'none'; speaker 'none'
      content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
      Accept-Ranges: bytes
      Date: Wed, 29 Jun 2022 12:46:42 GMT
      Via: 1.1 varnish
      Connection: close
      X-Served-By: cache-fra19122-FRA
      X-Cache: MISS
      X-Cache-Hits: 0
      X-Timer: S1656506801.895018,VS0,VE1352
      Vary: Fastly-SSL
      X-DNS-Prefetch-Control: off
      Set-Cookie: prov=709e24c6-e738-0a59-fff5-6a947e806a96; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly
 2. Google Crome http://stackoverflow.com/
      DevTools - F12:
         1.URL запроса: http://stackoverflow.com/
               Метод запроса: GET
               Код статуса: 307 Internal Redirect
               Правило для URL перехода: strict-origin-when-cross-origin
            Ответ:
               Cross-Origin-Resource-Policy: Cross-Origin
               Location: https://stackoverflow.com/
               Non-Authoritative-Reason: HSTS
         2. URL запроса: https://stackoverflow.com/
               Метод запроса: GET
               Код статуса: 200 
               Удаленный адрес: 151.101.193.69:443
               Правило для URL перехода: strict-origin-when-cross-origin
            Ответ:
               accept-ranges: bytes
               cache-control: private
               content-encoding: gzip
               content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
               content-type: text/html; charset=utf-8
               date: Wed, 29 Jun 2022 12:51:52 GMT
               feature-policy: microphone 'none'; speaker 'none'
               strict-transport-security: max-age=15552000
               vary: Accept-Encoding,Fastly-SSL
               via: 1.1 varnish
               x-cache: MISS
               x-cache-hits: 0
               x-dns-prefetch-control: off
               x-frame-options: SAMEORIGIN
               x-request-guid: 780c4d12-0e68-4432-b8d0-9a9f3bba8952
               x-served-by: cache-fra19122-FRA
               x-timer: S1656507112.141696,VS0,VE285
      1вый запрос - перенаправление на HTTPS с кодом 307
      2ой запрос - собственно отображение сайта.
         Наибольшее время загрузки (419мс) имеет основная страница
3. root@pve:~# curl 2ip.ru
   178.155.12.9
4. root@pve:~# whois 178.155.12.9
      
      inetnum:        178.155.0.0 - 178.155.63.255
      netname:        MTS-BROADBAND
      descr:          MTS PJSC
      country:        RU
      admin-c:        MT12425-RIPE
      admin-c:        MTS134-RIPE
      tech-c:         MT12425-RIPE
      tech-c:         MTS134-RIPE
      status:         ASSIGNED PA
      mnt-by:         KUBANGSM-MNT
      created:        2012-03-27T07:58:25Z
      last-modified:  2015-12-10T13:25:09Z
      source:         RIPE # Filtered

      person:         Mobile TeleSystem
      remarks:        OJSC Mobile TeleSystems Branch Macro-region South
      address:        61, Gimnazicheskaya str., Krasnodar, Russia, 350000
      phone:          +78612460116
      fax-no:         +78612671535
      nic-hdl:        MT12425-RIPE
      mnt-by:         KUBANGSM-MNT
      created:        2012-12-12T07:54:10Z
      last-modified:  2012-12-12T11:38:14Z
      source:         RIPE # Filtered

      person:         Mobile TeleSystems
      remarks:        OJSC Mobile TeleSystems Branch Macro-region South
      address:        61, Gimnazicheskaya str., Krasnodar, Russia, 350000
      phone:          +78612460116
      fax-no:         +78612671535
      nic-hdl:        MTS134-RIPE
      mnt-by:         KUBANGSM-MNT
      created:        2015-02-16T07:21:31Z
      last-modified:  2017-10-30T22:44:15Z
      source:         RIPE # Filtered

      % Information related to '178.155.12.0/23AS29497'

      route:          178.155.12.0/23
      descr:          MTS PJSC Krasnodar region
      origin:         AS29497
      mnt-by:         KUBANGSM-MNT
      mnt-by:         MTU-NOC
      created:        2017-12-08T13:20:28Z
      last-modified:  2017-12-08T13:20:28Z
      source:         RIPE

      % This query was served by the RIPE Database Query Service version 1.103 (WAGYU)
   Провайдер: MTS PJSC
   АвтСистема: AS29497

5. root@pve:~# traceroute -A 8.8.8.8
      traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
      1  192.168.153.1 (192.168.153.1) [*]  0.315 ms  0.302 ms  0.295 ms
      2  100.69.128.1 (100.69.128.1) [*]  0.907 ms  1.094 ms  1.012 ms
      3  77.66.207.24 (77.66.207.24) [AS29497]  1.334 ms  1.238 ms  1.312 ms
      4  morsk-cr02-be21.4024.knd.mts-internet.net (195.34.58.141) [AS8359]  1.566 ms  1.685 ms  1.618 ms
      5  * ler-cr03-be7.23.rnd.mts-internet.net (212.188.1.157) [AS8359]  6.758 ms *
      6  kai-cr02-ae2.61.rnd.mts-internet.net (195.34.53.178) [AS8359]  22.046 ms * *
      7  * * *
      8  m9-cr04-be4.77.msk.mts-internet.net (195.34.53.115) [AS8359]  21.006 ms  20.967 ms  21.452 ms
      9  m9-cr04-be3.77.msk.mts-internet.net (195.34.53.186) [AS8359]  21.057 ms 209.85.149.166 (209.85.149.166) [AS15169]  21.650 ms m9-cr04-be3.77.msk.mts-internet.net (195.34.53.186) [AS8359]  21.103 ms
      10  209.85.149.166 (209.85.149.166) [AS15169]  21.639 ms 72.14.211.222 (72.14.211.222) [AS15169]  22.086 ms *
      11  * 108.170.250.129 (108.170.250.129) [AS15169]  22.070 ms *
      12  108.170.227.74 (108.170.227.74) [AS15169]  21.336 ms 108.170.250.129 (108.170.250.129) [AS15169]  21.700 ms  21.779 ms
      13  108.170.250.146 (108.170.250.146) [AS15169]  21.062 ms 142.251.238.84 (142.251.238.84) [AS15169]  33.991 ms 108.170.250.146 (108.170.250.146) [AS15169]  21.453 ms
      14  142.251.238.68 (142.251.238.68) [AS15169]  38.173 ms 209.85.249.158 (209.85.249.158) [AS15169]  38.605 ms 142.251.49.24 (142.251.49.24) [AS15169]  33.965 ms
      15  142.250.235.74 (142.250.235.74) [AS15169]  36.189 ms 142.250.56.131 (142.250.56.131) [AS15169]  36.889 ms 172.253.51.245 (172.253.51.245) [AS15169]  37.482 ms
      16  142.250.209.171 (142.250.209.171) [AS15169]  35.270 ms 172.253.51.187 (172.253.51.187) [AS15169]  37.061 ms 172.253.51.241 (172.253.51.241) [AS15169]  37.019 ms
      17  * * *
      18  * * *
      19  * * *
      20  * * *
      21  * * *
      22  * * *
      23  * * *
      24  * * *
      25  * dns.google (8.8.8.8) [AS15169]  34.741 ms *

6.  root@pve:~# mtr 8.8.8.8 --aslookup
                                  My traceroute  [v0.94]
         pve (192.168.153.50) -> 8.8.8.8                                                                  2022-06-29T16:40:44+0300
         Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                          Packets               Pings
         Host                                                                          Loss%   Snt   Last   Avg  Best  Wrst StDev
         1. AS???    192.168.153.1                                                      0.0%    89    0.5   0.3   0.2   0.5   0.1
         2. AS???    100.69.128.1                                                       0.0%    89    1.0   1.0   0.8   2.2   0.2
         3. AS29497  77.66.207.24                                                       0.0%    89    1.0   1.2   0.9   3.2   0.3
         4. AS8359   morsk-cr02-be21.4024.knd.mts-internet.net                          0.0%    89    1.1   1.3   1.0   3.0   0.3
         5. AS8359   ler-cr03-be7.23.rnd.mts-internet.net                              58.0%    89    6.6   6.5   6.4   7.1   0.2
         6. AS8359   kai-cr02-ae2.61.rnd.mts-internet.net                              22.7%    88   27.5  23.1  21.0  27.5   1.5
         7. AS8359   a433-cr02-be3.61.msk.mts-internet.net                             85.1%    88   20.9  21.0  20.8  21.3   0.1
         8. AS8359   m9-cr04-be4.77.msk.mts-internet.net                               35.6%    88   21.0  21.0  20.8  21.3   0.1
         9. AS15169  209.85.149.166                                                     0.0%    88   21.3  21.4  21.1  23.1   0.2
         10. AS15169  172.253.68.11                                                      0.0%    88   20.8  20.8  20.7  21.2   0.1
         11. AS15169  108.170.250.83                                                    14.8%    88   20.9  22.0  20.8  39.9   3.3
         12. AS15169  209.85.249.158                                                    21.6%    88   38.8  45.6  38.5  65.1   6.6
         13. AS15169  216.239.43.20                                                      0.0%    88   42.8  40.5  37.9  72.3   6.0
         14. AS15169  216.239.62.13                                                      0.0%    88   36.7  36.6  36.5  37.1   0.1
         15. (waiting for reply)
         16. (waiting for reply)
         17. (waiting for reply)
         18. (waiting for reply)
         19. (waiting for reply)
         20. (waiting for reply)
         21. (waiting for reply)
         22. (waiting for reply)
         23. (waiting for reply)
         24. AS15169  dns.google                                                         0.0%    88   36.7  36.2  35.9  40.0   0.5

7. root@pve:~# dig +short NS dns.google
      ns3.zdns.google.
      ns2.zdns.google.
      ns4.zdns.google.
      ns1.zdns.google.

   root@pve:~# dig +short A dns.google
      8.8.8.8
      8.8.4.4
 
8. root@pve:~# dig -x 8.8.8.8
      ;; QUESTION SECTION:
      ;8.8.8.8.in-addr.arpa.          IN      PTR
      ;; ANSWER SECTION:
      8.8.8.8.in-addr.arpa.   34646   IN      PTR     dns.google.
   root@pve:~# dig -x 8.8.4.4
      ;; QUESTION SECTION:
      ;4.4.8.8.in-addr.arpa.          IN      PTR
      ;; ANSWER SECTION:
      4.4.8.8.in-addr.arpa.   52030   IN      PTR     dns.google.

   dns.google