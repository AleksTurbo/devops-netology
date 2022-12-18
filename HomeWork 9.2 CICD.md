# Домашнее задание к занятию "09.02 Процессы CI/CD"

## Подготовка к выполнению

1-8. Подготавливаем среду: готово

<img src="img/HW 9.2 YC 2 wm.png"/>

<img src="img/HW 9.2 sonar.png" />

<img src="img/HW 9.2 nexus.png"/>

## SonarQube

### Основная часть

1-4 Запускаем sonar-scanner:

```bash
[root@oracle sonar]# sonar-scanner --version
INFO: Scanner configuration file: /sonar/conf/sonar-scanner.properties
INFO: Project root configuration file: /sonar/sonar-project.properties
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-5.76.5.1.el9uek.x86_64 amd64
```

5-8 Тестируем проект:

```bash
[root@oracle sonar]# sonar-scanner -Dsonar.projectKey=netology -Dsonar.sources=. -Dsonar.host.url=http://192.168.153.118:9000 -Dsonar.login=5ede965ddeb6cc5a7971e59bf1cf2b030ab558e8 -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /sonar/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-5.76.5.1.el9uek.x86_64 amd64
INFO: User cache: /root/.sonar/cache
INFO: Scanner configuration file: /sonar/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: Analyzing on SonarQube server 9.1.0
INFO: Default locale: "en_US", source code encoding: "UTF-8"
INFO: Load global settings
INFO: Load global settings (done) | time=100ms
INFO: Server id: 9CFC3560-AYUhNlVL2tw-lB-j7l7L
INFO: User cache: /root/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=60ms
INFO: Load/download plugins (done) | time=163ms
INFO: Process project properties
INFO: Process project properties (done) | time=13ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=2ms
INFO: Project key: netology
INFO: Base dir: /home/aleksturbo/netology/sonar
INFO: Working dir: /home/aleksturbo/netology/sonar/.scannerwork
INFO: Load project settings for component key: 'netology'
INFO: Load project settings for component key: 'netology' (done) | time=18ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=60ms
INFO: Load active rules
INFO: Load active rules (done) | time=1497ms
...
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=1ms
INFO: SCM Publisher No SCM system was detected. You can use the 'sonar.scm.provider' property to explicitly specify it.
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=14ms
INFO: Analysis report generated in 102ms, dir size=102.7 kB
INFO: Analysis report compressed in 24ms, zip size=13.8 kB
INFO: Analysis report uploaded in 60ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://192.168.153.118:9000/dashboard?id=netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://192.168.153.118:9000/api/ce/task?id=AYUl_BruIH5tCBBWb8y2
INFO: Analysis total time: 4.700 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 6.060s
INFO: Final Memory: 7M/30M
INFO: ------------------------------------------------------------------------

```

9. Cкриншот успешного прохождения анализа:

<img src="img/HW 9.2 sonar QG.png"/>

[Fixed "fail.py"](cicd/fail.py)

## Nexus

### Основная часть

1-3. Загружаем артефакты в Nexus:

<img src="img/HW 9.2 nexus artefacts.png"/>

4. [maven-metadata.xml](cicd/maven-metadata.xml)

## Maven

### Подготовка к выполнению

1-4. Подготавливаем Maven:

```bash
aleksturbo@AlksTrbNoute:/$ mvn --version
Apache Maven 3.6.3
Maven home: /usr/share/maven
Java version: 11.0.17, vendor: Ubuntu, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "5.10.16.3-microsoft-standard-wsl2", arch: "amd64", family: "unix"
```

5. Размещаем pom.xml:

```bash
aleksturbo@AlksTrbNoute:~/netology/93cicd/mvn$ ls -la
total 16
drwxr-xr-x 3 aleksturbo aleksturbo 4096 Dec 18 17:11 .
drwxr-xr-x 6 aleksturbo aleksturbo 4096 Dec 17 18:47 ..
-rw-r--r-- 1 aleksturbo aleksturbo  798 Dec 18 17:21 pom.xml
```

### Основная часть

1. Модифицируем pom.xml под нашу среду:

```xml
      <url>http://192.168.153.118:8081/repository/maven-public/</url>
    </repository>
  </repositories>
  <dependencies>
    <dependency>
      <groupId>netology</groupId>
      <artifactId>java</artifactId>
      <version>8_282</version>
      <classifier>distrib</classifier>
      <type>tar.gz</type>
```

2. Запускаем команду mvn package:

```bash
aleksturbo@AlksTrbNoute:~/netology/93cicd/mvn$ mvn package
[INFO] Scanning for projects...
[INFO] 
[INFO] --------------------< com.netology.app:simple-app >---------------------
[INFO] Building simple-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
Downloading from my-repo: http://192.168.153.118:8081/repository/maven-public/netology/java/8_282/java-8_282.pom
Downloading from central: https://repo.maven.apache.org/maven2/netology/java/8_282/java-8_282.pom
[WARNING] The POM for netology:java:tar.gz:distrib:8_282 is missing, no dependency information available
Downloading from my-repo: http://192.168.153.118:8081/repository/maven-public/netology/java/8_282/java-8_282-distrib.tar.gz
Downloaded from my-repo: http://192.168.153.118:8081/repository/maven-public/netology/java/8_282/java-8_282-distrib.tar.gz (0 B at 0 B/s)
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ simple-app ---
[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
[INFO] skip non existing resourceDirectory /home/aleksturbo/netology/93cicd/mvn/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ simple-app ---
[INFO] No sources to compile
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ simple-app ---
[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
[INFO] skip non existing resourceDirectory /home/aleksturbo/netology/93cicd/mvn/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ simple-app ---
[INFO] No sources to compile
[INFO] 
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ simple-app ---
[INFO] No tests to run.
[INFO] 
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ simple-app ---
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.385 s
[INFO] Finished at: 2022-12-18T20:04:57+03:00
[INFO] ------------------------------------------------------------------------
```

3. Проверяем директорию ~/.m2/repository/:

```bash
aleksturbo@AlksTrbNoute:~/netology/93cicd/mvn$ ls -la ~/.m2/repository/netology/java/8_282
total 20
drwxr-xr-x 2 aleksturbo aleksturbo 4096 Dec 18 20:04 .
drwxr-xr-x 3 aleksturbo aleksturbo 4096 Dec 18 20:04 ..
-rw-r--r-- 1 aleksturbo aleksturbo  175 Dec 18 20:04 _remote.repositories
-rw-r--r-- 1 aleksturbo aleksturbo    0 Dec 18 20:04 java-8_282-distrib.tar.gz
-rw-r--r-- 1 aleksturbo aleksturbo   40 Dec 18 20:04 java-8_282-distrib.tar.gz.sha1
-rw-r--r-- 1 aleksturbo aleksturbo  394 Dec 18 20:04 java-8_282.pom.lastUpdated
```

4. pom.xml:

[pom.xml](cicd/pom.xml)