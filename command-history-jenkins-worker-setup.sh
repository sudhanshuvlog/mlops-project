   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
[ec2-user@ip-172-31-10-175 ~]$ su sudo root
su: user sudo does not exist or the user entry does not contain all the required fields
[ec2-user@ip-172-31-10-175 ~]$ sudo su root
[root@ip-172-31-10-175 ec2-user]# cd .
[root@ip-172-31-10-175 ec2-user]# cd /
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# yum install docker -y
Amazon Linux 2023 Kernel Livepatch repository                                                                                                              926 kB/s |  97 kB     00:00    
Last metadata expiration check: 0:00:01 ago on Sun Nov 15 04:52:18 2026.
Dependencies resolved.
===========================================================================================================================================================================================
 Package                                            Architecture                       Version                                               Repository                               Size
===========================================================================================================================================================================================
Installing:
 docker                                             x86_64                             25.0.18-1.amzn2023.0.3                                amazonlinux                              49 M
Installing dependencies:
 container-selinux                                  noarch                             4:2.245.0-1.amzn2023                                  amazonlinux                              58 k
 containerd                                         x86_64                             2.3.7-1.amzn2023.0.3                                  amazonlinux                              24 M
 iptables-libs                                      x86_64                             1.8.8-3.amzn2023.0.2                                  amazonlinux                             401 k
 iptables-nft                                       x86_64                             1.8.8-3.amzn2023.0.2                                  amazonlinux                             183 k
 libcgroup                                          x86_64                             3.0-1.amzn2023.0.1                                    amazonlinux                              75 k
 libnetfilter_conntrack                             x86_64                             1.0.8-2.amzn2023.0.2                                  amazonlinux                              58 k
 libnfnetlink                                       x86_64                             1.0.1-19.amzn2023.0.2                                 amazonlinux                              30 k
 libnftnl                                           x86_64                             1.2.2-2.amzn2023.0.2                                  amazonlinux                              84 k
 pigz                                               x86_64                             2.5-1.amzn2023.0.4                                    amazonlinux                              83 k
 runc                                               x86_64                             1.4.3-1.amzn2023.0.3                                  amazonlinux                             3.7 M

Transaction Summary
===========================================================================================================================================================================================
Install  11 Packages

Total download size: 77 M
Installed size: 290 M
Downloading Packages:
(1/11): container-selinux-2.245.0-1.amzn2023.noarch.rpm                                                                                                    1.8 MB/s |  58 kB     00:00    
(2/11): iptables-libs-1.8.8-3.amzn2023.0.2.x86_64.rpm                                                                                                      9.6 MB/s | 401 kB     00:00    
(3/11): iptables-nft-1.8.8-3.amzn2023.0.2.x86_64.rpm                                                                                                       5.0 MB/s | 183 kB     00:00    
(4/11): libcgroup-3.0-1.amzn2023.0.1.x86_64.rpm                                                                                                            1.7 MB/s |  75 kB     00:00    
(5/11): libnetfilter_conntrack-1.0.8-2.amzn2023.0.2.x86_64.rpm                                                                                             2.0 MB/s |  58 kB     00:00    
(6/11): libnfnetlink-1.0.1-19.amzn2023.0.2.x86_64.rpm                                                                                                      1.1 MB/s |  30 kB     00:00    
(7/11): libnftnl-1.2.2-2.amzn2023.0.2.x86_64.rpm                                                                                                           4.2 MB/s |  84 kB     00:00    
(8/11): pigz-2.5-1.amzn2023.0.4.x86_64.rpm                                                                                                                 3.3 MB/s |  83 kB     00:00    
(9/11): runc-1.4.3-1.amzn2023.0.3.x86_64.rpm                                                                                                                35 MB/s | 3.7 MB     00:00    
(10/11): containerd-2.3.7-1.amzn2023.0.3.x86_64.rpm                                                                                                         40 MB/s |  24 MB     00:00    
(11/11): docker-25.0.18-1.amzn2023.0.3.x86_64.rpm                                                                                                           49 MB/s |  49 MB     00:00    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                       74 MB/s |  77 MB     00:01     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                   1/1 
  Installing       : runc-1.4.3-1.amzn2023.0.3.x86_64                                                                                                                                 1/11 
  Installing       : containerd-2.3.7-1.amzn2023.0.3.x86_64                                                                                                                           2/11 
  Running scriptlet: containerd-2.3.7-1.amzn2023.0.3.x86_64                                                                                                                           2/11 
  Installing       : pigz-2.5-1.amzn2023.0.4.x86_64                                                                                                                                   3/11 
  Installing       : libnftnl-1.2.2-2.amzn2023.0.2.x86_64                                                                                                                             4/11 
  Installing       : libnfnetlink-1.0.1-19.amzn2023.0.2.x86_64                                                                                                                        5/11 
  Installing       : libnetfilter_conntrack-1.0.8-2.amzn2023.0.2.x86_64                                                                                                               6/11 
  Installing       : iptables-libs-1.8.8-3.amzn2023.0.2.x86_64                                                                                                                        7/11 
  Installing       : iptables-nft-1.8.8-3.amzn2023.0.2.x86_64                                                                                                                         8/11 
  Running scriptlet: iptables-nft-1.8.8-3.amzn2023.0.2.x86_64                                                                                                                         8/11 
  Installing       : libcgroup-3.0-1.amzn2023.0.1.x86_64                                                                                                                              9/11 
  Running scriptlet: container-selinux-4:2.245.0-1.amzn2023.noarch                                                                                                                   10/11 
  Installing       : container-selinux-4:2.245.0-1.amzn2023.noarch                                                                                                                   10/11 
  Running scriptlet: container-selinux-4:2.245.0-1.amzn2023.noarch                                                                                                                   10/11 
  Running scriptlet: docker-25.0.18-1.amzn2023.0.3.x86_64                                                                                                                            11/11 
  Installing       : docker-25.0.18-1.amzn2023.0.3.x86_64                                                                                                                            11/11 
  Running scriptlet: docker-25.0.18-1.amzn2023.0.3.x86_64                                                                                                                            11/11 
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /usr/lib/systemd/system/docker.socket.

  Running scriptlet: container-selinux-4:2.245.0-1.amzn2023.noarch                                                                                                                   11/11 
  Running scriptlet: docker-25.0.18-1.amzn2023.0.3.x86_64                                                                                                                            11/11 
  Verifying        : container-selinux-4:2.245.0-1.amzn2023.noarch                                                                                                                    1/11 
  Verifying        : containerd-2.3.7-1.amzn2023.0.3.x86_64                                                                                                                           2/11 
  Verifying        : docker-25.0.18-1.amzn2023.0.3.x86_64                                                                                                                             3/11 
  Verifying        : iptables-libs-1.8.8-3.amzn2023.0.2.x86_64                                                                                                                        4/11 
  Verifying        : iptables-nft-1.8.8-3.amzn2023.0.2.x86_64                                                                                                                         5/11 
  Verifying        : libcgroup-3.0-1.amzn2023.0.1.x86_64                                                                                                                              6/11 
  Verifying        : libnetfilter_conntrack-1.0.8-2.amzn2023.0.2.x86_64                                                                                                               7/11 
  Verifying        : libnfnetlink-1.0.1-19.amzn2023.0.2.x86_64                                                                                                                        8/11 
  Verifying        : libnftnl-1.2.2-2.amzn2023.0.2.x86_64                                                                                                                             9/11 
  Verifying        : pigz-2.5-1.amzn2023.0.4.x86_64                                                                                                                                  10/11 
  Verifying        : runc-1.4.3-1.amzn2023.0.3.x86_64                                                                                                                                11/11 

Installed:
  container-selinux-4:2.245.0-1.amzn2023.noarch   containerd-2.3.7-1.amzn2023.0.3.x86_64   docker-25.0.18-1.amzn2023.0.3.x86_64                 iptables-libs-1.8.8-3.amzn2023.0.2.x86_64  
  iptables-nft-1.8.8-3.amzn2023.0.2.x86_64        libcgroup-3.0-1.amzn2023.0.1.x86_64      libnetfilter_conntrack-1.0.8-2.amzn2023.0.2.x86_64   libnfnetlink-1.0.1-19.amzn2023.0.2.x86_64  
  libnftnl-1.2.2-2.amzn2023.0.2.x86_64            pigz-2.5-1.amzn2023.0.4.x86_64           runc-1.4.3-1.amzn2023.0.3.x86_64                    

Complete!
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# systemctl start docker
[root@ip-172-31-10-175 /]# docker run -p 8080:8080 -p 50000:50000 -dit --name jenkins --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk25
Unable to find image 'jenkins/jenkins:lts-jdk25' locally
lts-jdk25: Pulling from jenkins/jenkins
8d0037029946: Pull complete 
3b055db147fd: Pull complete 
d739cb44101d: Pull complete 
8dbdef39dae7: Pull complete 
c0debdb944aa: Pull complete 
bfa1e0807eb8: Pull complete 
b4c5b3edde88: Pull complete 
9e05215a9ca9: Pull complete 
d5ffa23cc334: Pull complete 
2d11285eff35: Pull complete 
35d29a5be2d8: Pull complete 
2f9af4076ecd: Pull complete 
Digest: sha256:415ab90d4e3b25148f7191bc04f455a20817d6c4c3b0a98f6c6b0da4877f7081
Status: Downloaded newer image for jenkins/jenkins:lts-jdk25
d886648a22bc2ae1039587b32e57ecdaed05dcc1f320c8c60efc3d51eef3909e
[root@ip-172-31-10-175 /]# docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS          PORTS                                                                                      NAMES
d886648a22bc   jenkins/jenkins:lts-jdk25   "/usr/bin/tini -- /u…"   19 seconds ago   Up 17 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:50000->50000/tcp, :::50000->50000/tcp   jenkins
[root@ip-172-31-10-175 /]# docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
c92301d3efc74b11a8c23ffa56e4ac0a
[root@ip-172-31-10-175 /]# wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.rpm yum install jdk-25_linux-x64_bin.rpm -y
wget: invalid option -- 'y'
Usage: wget [OPTION]... [URL]...

Try `wget --help' for more options.
[root@ip-172-31-10-175 /]# wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.rpm
--2026-11-15 05:02:59--  https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.rpm
Resolving download.oracle.com (download.oracle.com)... 23.37.84.122
Connecting to download.oracle.com (download.oracle.com)|23.37.84.122|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 216649659 (207M) [application/x-redhat-package-manager]
Saving to: ‘jdk-25_linux-x64_bin.rpm’

jdk-25_linux-x64_bin.rpm                       100%[===================================================================================================>] 206.61M   106MB/s    in 2.0s    

2026-11-15 05:03:01 (106 MB/s) - ‘jdk-25_linux-x64_bin.rpm’ saved [216649659/216649659]

[root@ip-172-31-10-175 /]# yum install jdk-25_linux-x64_bin.rpm -y
Last metadata expiration check: 0:10:51 ago on Sun Nov 15 04:52:18 2026.
Dependencies resolved.
===========================================================================================================================================================================================
 Package                                 Architecture                            Version                                               Repository                                     Size
===========================================================================================================================================================================================
Installing:
 jdk-25                                  x86_64                                  2000:25.0.5.0.3-1                                     @commandline                                  207 M

Transaction Summary
===========================================================================================================================================================================================
Install  1 Package

Total size: 207 M
Installed size: 375 M
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                   1/1 
  Installing       : jdk-25-2000:25.0.5.0.3-1.x86_64                                                                                                                                   1/1 
  Running scriptlet: jdk-25-2000:25.0.5.0.3-1.x86_64                                                                                                                                   1/1 
  Verifying        : jdk-25-2000:25.0.5.0.3-1.x86_64                                                                                                                                   1/1 

Installed:
  jdk-25-2000:25.0.5.0.3-1.x86_64                                                                                                                                                          

Complete!
[root@ip-172-31-10-175 /]# ls
bin  boot  dev  etc  home  jdk-25_linux-x64_bin.rpm  lib  lib64  local  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@ip-172-31-10-175 /]# mkdir data
[root@ip-172-31-10-175 /]# curl -sO http://15.252.123.77:8080/jnlpJars/agent.jar
[root@ip-172-31-10-175 /]# java -jar agent.jar -url http://15.252.123.77:8080/ -secret 8f57dbb35c24a97e0816ad88a2d05dd7e3df3959bbc36ab565f85637406ddd67 -name ec2 -webSocket -workDir "/data"  &
[1] 29956
[root@ip-172-31-10-175 /]# Nov 15, 2026 5:03:45 AM org.jenkinsci.remoting.engine.WorkDirManager initializeWorkDir
INFO: Using /data/remoting as a remoting work directory
Nov 15, 2026 5:03:45 AM org.jenkinsci.remoting.engine.WorkDirManager setupLogging
INFO: Both error and output logs will be printed to /data/remoting
Nov 15, 2026 5:03:45 AM hudson.remoting.Launcher createEngine
INFO: Setting up agent: ec2
Nov 15, 2026 5:03:45 AM hudson.remoting.Engine startEngine
INFO: Using Remoting version: 3386.v353e57a_1b_ea_0
Nov 15, 2026 5:03:45 AM org.jenkinsci.remoting.engine.WorkDirManager initializeWorkDir
INFO: Using /data/remoting as a remoting work directory
Nov 15, 2026 5:03:45 AM hudson.remoting.Launcher$CuiListener status
INFO: WebSocket connection open
Nov 15, 2026 5:03:45 AM hudson.remoting.Launcher$CuiListener status
INFO: Connected

[root@ip-172-31-10-175 /]# WARNING: A restricted method in java.lang.System has been called
WARNING: java.lang.System::load has been called by com.sun.jna.Native in an unnamed module
WARNING: Use --enable-native-access=ALL-UNNAMED to avoid a warning for callers in this module
WARNING: Restricted methods will be blocked in a future release unless native access is enabled


[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# aws s3 ls

aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# 
[root@ip-172-31-10-175 /]# yum install git -y
Last metadata expiration check: 0:23:18 ago on Sun Nov 15 04:52:18 2026.
Dependencies resolved.
===========================================================================================================================================================================================
 Package                                       Architecture                        Version                                                  Repository                                Size
===========================================================================================================================================================================================
Installing:
 git                                           x86_64                              2.50.1-1.amzn2023.0.2                                    amazonlinux                               50 k
Installing dependencies:
 git-core                                      x86_64                              2.50.1-1.amzn2023.0.2                                    amazonlinux                              4.9 M
 git-core-doc                                  noarch                              2.50.1-1.amzn2023.0.2                                    amazonlinux                              2.8 M
 perl-Error                                    noarch                              1:0.17030-2.amzn2023.0.1                                 amazonlinux                               42 k
 perl-File-Find                                noarch                              1.37-477.amzn2023.0.11                                   amazonlinux                               26 k
 perl-Git                                      noarch                              2.50.1-1.amzn2023.0.2                                    amazonlinux                               38 k
 perl-TermReadKey                              x86_64                              2.38-9.amzn2023.0.3                                      amazonlinux                               36 k
 perl-lib                                      x86_64                              0.65-477.amzn2023.0.11                                   amazonlinux                               15 k

Transaction Summary
===========================================================================================================================================================================================
Install  8 Packages

Total download size: 8.0 M
Installed size: 41 M
Downloading Packages:
(1/8): git-2.50.1-1.amzn2023.0.2.x86_64.rpm                                                                                                                1.9 MB/s |  50 kB     00:00    
(2/8): perl-Error-0.17030-2.amzn2023.0.1.noarch.rpm                                                                                                        1.6 MB/s |  42 kB     00:00    
(3/8): git-core-doc-2.50.1-1.amzn2023.0.2.noarch.rpm                                                                                                        38 MB/s | 2.8 MB     00:00    
(4/8): perl-File-Find-1.37-477.amzn2023.0.11.noarch.rpm                                                                                                    1.0 MB/s |  26 kB     00:00    
(5/8): git-core-2.50.1-1.amzn2023.0.2.x86_64.rpm                                                                                                            43 MB/s | 4.9 MB     00:00    
(6/8): perl-Git-2.50.1-1.amzn2023.0.2.noarch.rpm                                                                                                           909 kB/s |  38 kB     00:00    
(7/8): perl-TermReadKey-2.38-9.amzn2023.0.3.x86_64.rpm                                                                                                     919 kB/s |  36 kB     00:00    
(8/8): perl-lib-0.65-477.amzn2023.0.11.x86_64.rpm                                                                                                          626 kB/s |  15 kB     00:00    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                       40 MB/s | 8.0 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                   1/1 
  Installing       : git-core-2.50.1-1.amzn2023.0.2.x86_64                                                                                                                             1/8 
  Installing       : git-core-doc-2.50.1-1.amzn2023.0.2.noarch                                                                                                                         2/8 
  Installing       : perl-lib-0.65-477.amzn2023.0.11.x86_64                                                                                                                            3/8 
  Installing       : perl-TermReadKey-2.38-9.amzn2023.0.3.x86_64                                                                                                                       4/8 
  Installing       : perl-File-Find-1.37-477.amzn2023.0.11.noarch                                                                                                                      5/8 
  Installing       : perl-Error-1:0.17030-2.amzn2023.0.1.noarch                                                                                                                        6/8 
  Installing       : perl-Git-2.50.1-1.amzn2023.0.2.noarch                                                                                                                             7/8 
  Installing       : git-2.50.1-1.amzn2023.0.2.x86_64                                                                                                                                  8/8 
  Running scriptlet: git-2.50.1-1.amzn2023.0.2.x86_64                                                                                                                                  8/8 
  Verifying        : git-2.50.1-1.amzn2023.0.2.x86_64                                                                                                                                  1/8 
  Verifying        : git-core-2.50.1-1.amzn2023.0.2.x86_64                                                                                                                             2/8 
  Verifying        : git-core-doc-2.50.1-1.amzn2023.0.2.noarch                                                                                                                         3/8 
  Verifying        : perl-Error-1:0.17030-2.amzn2023.0.1.noarch                                                                                                                        4/8 
  Verifying        : perl-File-Find-1.37-477.amzn2023.0.11.noarch                                                                                                                      5/8 
  Verifying        : perl-Git-2.50.1-1.amzn2023.0.2.noarch                                                                                                                             6/8 
  Verifying        : perl-TermReadKey-2.38-9.amzn2023.0.3.x86_64                                                                                                                       7/8 
  Verifying        : perl-lib-0.65-477.amzn2023.0.11.x86_64                                                                                                                            8/8 

Installed:
  git-2.50.1-1.amzn2023.0.2.x86_64                 git-core-2.50.1-1.amzn2023.0.2.x86_64     git-core-doc-2.50.1-1.amzn2023.0.2.noarch       perl-Error-1:0.17030-2.amzn2023.0.1.noarch    
  perl-File-Find-1.37-477.amzn2023.0.11.noarch     perl-Git-2.50.1-1.amzn2023.0.2.noarch     perl-TermReadKey-2.38-9.amzn2023.0.3.x86_64     perl-lib-0.65-477.amzn2023.0.11.x86_64        

Complete!
[root@ip-172-31-10-175 /]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase for "/root/.ssh/id_rsa" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:hmjasAn+4QU+V5sQgAWfadbnvsy6+cPeOANP2P5KEm8 root@ip-172-31-10-175.ap-south-1.compute.internal
The key's randomart image is:
+---[RSA 3072]----+
| .+o             |
| .. =            |
|   * o .         |
|  o  .+.         |
|. ..oo+oS        |
|...B.o*+o        |
| .++.+*E         |
|  o = BB+        |
|   o +=O*o       |
+----[SHA256]-----+
[root@ip-172-31-10-175 /]# cat /root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzDzyQG1NFMn3+x0XGIYDIAdCyM66NuN9EwYaRvFuw3q6DZc4oHc52ItVO5IG657W4I7RTMZ8A3w5hiwVyRCIZ7K+5jPyqozLXatpqnu07WThJiHrKKk3JbOcwtN5lU4qSsNaA4DnRYwMeWOAL/L5upALfrjoPHrEPSzIOjS/9Wqh5dXPycJ+M2A8doH5GH4Aw7i/9auBivOg/FzBKUYo2BQHhSxMuK8ZeYDXK28Qmrjm/SKMHQvxEZ+PVY6UsM/DNNXKQTQHdCHXzaz9OZnY4SXvmtIlgwmeWB8pRdwKBuE75oafZa41oOaGcThCgk8ezK8Wne7l1ahB3IfVQiQ1szcLYeiEjCuwGRYrXpOlkRELX9Ah7KUMbP5eJC8+g+YGjkCpDpW5Iyswz3EikPG0yWq2U3l1x/jo+3xFmN4WO2Jj3dEt1pHQ2CyocpnnZDusp4XBWsAvBuQUuzrNPZ+kOzLxJDvOhNlG3SI4CIRs7pZXLLiYp4EzhW+9O2TSN+Js= root@ip-172-31-10-175.ap-south-1.compute.internal
[root@ip-172-31-10-175 /]# nohup ./venv/bin/mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlruns --host 0.0.0.0 --port 5000
nohup: ignoring input and appending output to 'nohup.out'
nohup: failed to run command './venv/bin/mlflow': No such file or directory
[root@ip-172-31-10-175 /]# cd data/workspace/Mlops\ pipeline
[root@ip-172-31-10-175 Mlops pipeline]# ls
Dockerfile   Readme.md  command-history-jenkins-worker-setup.sh  data-generator.py  dvc.yaml             metrics.json  mlruns  pipeline.png      session-screenshots  venv
Jenkinsfile  artifacts  data                                     dvc.lock           mermaid-diagram.png  mlflow.db     models  requirements.txt  src
[root@ip-172-31-10-175 Mlops pipeline]# nohup ./venv/bin/mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlruns --host 0.0.0.0 --port 5000
nohup: ignoring input and appending output to 'nohup.out'
^C[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# nohup ./venv/bin/mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlruns --host 0.0.0.0 --port 5000 &
[2] 34119
[root@ip-172-31-10-175 Mlops pipeline]# nohup: ignoring input and appending output to 'nohup.out'

[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# curl http://15.252.123.77:8000/
curl -X POST http://15.252.123.77:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"income": 50000, "loan_amount": 20000, "credit_score": 700}'
{"message":"Loan Risk API Running"}{"risk":"Medium","confidence":0.9956474900245667}[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS          PORTS                                                                                      NAMES
8174e1d42739   loan-risk-app:3             "/app/entrypoint.sh"     24 seconds ago   Up 22 seconds   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp                                                  webapp
d886648a22bc   jenkins/jenkins:lts-jdk25   "/usr/bin/tini -- /u…"   45 minutes ago   Up 45 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:50000->50000/tcp, :::50000->50000/tcp   jenkins
[root@ip-172-31-10-175 Mlops pipeline]# curl -X POST http://15.252.123.77:8000/predict   -H "Content-Type: application/json"   -d '{"income": 50000, "loan_amount": 20000, "credit_score": 800}'
{"risk":"Low","confidence":0.9906501173973083}[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# 
[root@ip-172-31-10-175 Mlops pipeline]# cd /


[root@ip-172-31-10-175 /]# history
    1  cd .
    2  cd /
    3  yum install docker -y
    4  systemctl start docker
    5  docker run -p 8080:8080 -p 50000:50000 -dit --name jenkins --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk25
    6  docker ps
    7  docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    8  wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.rpm yum install jdk-25_linux-x64_bin.rpm -y
    9  wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.rpm
   10  yum install jdk-25_linux-x64_bin.rpm -y
   11  ls
   12  mkdir data
   13  curl -sO http://15.252.123.77:8080/jnlpJars/agent.jar
   14  java -jar agent.jar -url http://15.252.123.77:8080/ -secret 8f57dbb35c24a97e0816ad88a2d05dd7e3df3959bbc36ab565f85637406ddd67 -name ec2 -webSocket -workDir "/data"  &
   15  aws s3 ls
   16  yum install git -y
   17  ssh-keygen -t rsa
   18  cat /root/.ssh/id_rsa.pub
   19  nohup ./venv/bin/mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlruns --host 0.0.0.0 --port 5000
   20  cd data/workspace/Mlops\ pipeline
   21  ls
   22  nohup ./venv/bin/mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlruns --host 0.0.0.0 --port 5000
[root@ip-172-31-10-175 /]# 
