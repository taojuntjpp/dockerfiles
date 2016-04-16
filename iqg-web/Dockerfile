FROM centos:7


MAINTAINER "taojun" <taojun@doweidu.com>

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y wget nginx openssl openssl-devel --nogpgcheck

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

WORKDIR /etc/yum.repos.d

RUN wget -O CentOS-Base.repo https://lug.ustc.edu.cn/wiki/_export/code/mirrors/help/centos?codeblock=3 


RUN rpm --import /etc/pki/rpm-gpg/RPM* 

RUN rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/7/x86_64/e/epel-release-7-5.noarch.rpm --force --nodeps 

RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm --force --nodeps 

RUN yum install -y --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-pecl-apcu php-cli php-bcmath php-soap php-common php-devel php-fpm php-gd php-mbstring php-mcrypt php-mysql php-pdo php-pear php-pecl-geoip php-pecl-imagick php-pecl-xdebug php-xml php-mongo --nogpgcheck


RUN yum install -y lsof net-tools logrotate strace sshpass
RUN yum install -y initscripts crontabs htop dstat rsync lsync git

#RUN echo no| pecl install mongo && echo 'extension=mongo.so' > /etc/php.d/mongo.ini 


RUN ln -s /etc/nginx nginx
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN useradd work &&  su work -l -c"mkdir -p /home/work/.ssh && echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/WmGvIpr9jK3W9AdaC75gvYAEeGLXzer3DGI4hWG+FD71zOXeWVzayZnNQJu0QyoMSHdUK2AQI7ucay0PJ8Wa+SdC4PidxYs6JYlc6EuqJihsUx2kwXh14O6VK5JK3m63FsgIJes3Hm7g5lxkH/LPhSmgw8dxfcamUeirZX0LPdgJctEn+zHGygo07Xqu/8RHaKgboUwBBmcU4fMlJWDcOoYRcZ7kPX2U831N1iU86U99sB+ywEiiMM4WY3V4TvI3jQQDm1Dc7pSw0JlDChQbNKH79Iz7szFznpGSJrhdsu0LkbLuVOXn5x0PimFM0Q8s1hlnLWN6KbTo+B6JsLEn cway@sous-MacBook-Pro.local' > /home/work/.ssh/authorized_keys "
RUN mkdir ~/.ssh
RUN mkdir -p /ace/log/php  /ace/log/nginx /ace/log/php-fpm /ace/run

VOLUME [ "/sys/fs/cgroup" ]



CMD ["/usr/sbin/init"]
