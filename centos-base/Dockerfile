FROM centos:latest

MAINTAINER "taojun" "taojun@doweidu.com"

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y wget which openssl openssl-devel ifconfig --nogpgcheck

RUN yum -y install openssh-server

EXPOSE 22

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519


RUN yum install -y lsof net-tools logrotate strace sshpass initscripts crontabs htop dstat rsync lsync git

RUN echo "root:jump" | chpasswd

RUN sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/' /etc/ssh/sshd_config
RUN sed -i 's/#RSAAuthentication/RSAAuthentication/' /etc/ssh/sshd_config

RUN useradd work && su work -l -c"mkdir -p /home/work/.ssh && chmod 700 /home/work/.ssh && echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDfwFPFqt6ZIV/cTj7wNx+K2jVs2Iz2ArT/x72Y2HIfq5GZgKKwJ6zrPEauulou+4Hrk/dNCNHJ8VkCPXBCpU7R0tuY4joz0Ex+aHacF813yx6Sjx/UPrKya6dTtv3TZAYFKRgKBXCHtuPoWVkUpZCj6AUQ1yUIwPxzW2YJ8G7d4Q== taojun@doweidu.com' > /home/work/.ssh/authorized_keys && chmod 644 /home/work/.ssh/authorized_keys"

RUN yum install -y epel-release

#rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum install -y nginx 
RUN yum install -y php56w php56w-opcache --nogpgcheck
RUN yum install -y yum-plugin-replace --nogpgcheck
RUN yum install -y php56w-cli php56w-bcmath php56w-soap php56w-common php56w-devel php56w-fpm php56w-gd php56w-mbstring php56w-mcrypt php56w-mysql php56w-pdo php56w-pear php56w-pecl-geoip php56w-pecl-imagick php56w-pecl-xdebug php56w-xml php56w-pecl-redis --nogpgcheck

RUN yum install -y gcc


RUN echo no| pecl install mongodb && echo 'extension=mongodb.so' > /etc/php.d/mongodb.ini 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /ace/log/php  /ace/upload /ace/log/nginx /ace/log/php-fpm /ace/run

RUN phpmemory_limit=512M && \
    timezone='Asia\/Shanghai' && \
    service_runner=work && \
    ace_path='\/ace\/' && \
    sed -i 's/memory_limit = .*/memory_limit = '${phpmemory_limit}'/' /etc/php.ini && \
    sed -i 's/error_log = php_errors\.log/error_log = '${ace_path}'log\/php\/php_errors.log/' /etc/php.ini && \
    sed -i 's/http_x_forwarded_for\"/http_x_forwarded_for\" \"\$request_time\"/' /etc/nginx/nginx.conf && \
    sed -i 's/access_log .*;/access_log '${ace_path}'log\/nginx\/access.log main;/' /etc/nginx/nginx.conf && \
    sed -i 's/error_log .*;/error_log '${ace_path}'log\/nginx\/error.log;/' /etc/nginx/nginx.conf && \
    sed -i 's/user .*;/user '${service_runner}';/' /etc/nginx/nginx.conf && \
    sed -i 's/pid .*;/pid '${ace_path}'run\/nginx.pid;/' /etc/nginx/nginx.conf && \
    sed -i 's/error_log = .*/error_log = '${ace_path}'log\/php-fpm\/error.log/' /etc/php-fpm.conf && \
    sed -i 's/pid = .*/pid = '${ace_path}'run\/php-fpm.pid/' /etc/php-fpm.conf && \
    sed -i 's/user = .*/;user = '${service_runner}'/' /etc/php-fpm.d/www.conf && \
    sed -i 's/pm = dynamic/pm = static/' /etc/php-fpm.d/www.conf && \
    sed -i 's/pm.max_children = .*/pm.max_children = 30/' /etc/php-fpm.d/www.conf && \
    sed -i 's/group = .*/;group = '${service_runner}'/' /etc/php-fpm.d/www.conf && \
    sed -i 's/;request_slowlog_timeout = .*/request_slowlog_timeout = 10/' /etc/php-fpm.d/www.conf && \
    sed -i 's/slowlog = .*/slowlog = '${ace_path}'log\/php-fpm\/www-slow.log/' /etc/php-fpm.d/www.conf && \
    sed -i 's/listen = .*/listen = '${ace_path}'run\/php5-fpm.sock/' /etc/php-fpm.d/www.conf && \
    sed -i 's/php_admin_value\[error_log\] = .*/php_admin_value\[error_log\] = '${ace_path}'log\/php-fpm\/www-error.log/' /etc/php-fpm.d/www.conf && \
    sed -i 's/;date.timezone =/date.timezone = '${timezone}'/' /etc/php.ini && \
    sed -i 's/;always_populate_raw_post_data = .*/always_populate_raw_post_data = -1/' /etc/php.ini


CMD ["/usr/sbin/sshd", "-D"]
