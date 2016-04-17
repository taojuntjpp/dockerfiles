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

#RUN echo "root:jump" | chpasswd

RUN sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/' /etc/ssh/sshd_config
RUN sed -i 's/#RSAAuthentication/RSAAuthentication/' /etc/ssh/sshd_config

RUN useradd work && su work -l -c"mkdir -p /home/work/.ssh && chmod 700 /home/work/.ssh && echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDfwFPFqt6ZIV/cTj7wNx+K2jVs2Iz2ArT/x72Y2HIfq5GZgKKwJ6zrPEauulou+4Hrk/dNCNHJ8VkCPXBCpU7R0tuY4joz0Ex+aHacF813yx6Sjx/UPrKya6dTtv3TZAYFKRgKBXCHtuPoWVkUpZCj6AUQ1yUIwPxzW2YJ8G7d4Q== taojun@doweidu.com' > /home/work/.ssh/authorized_keys && chmod 644 /home/work/.ssh/authorized_keys"


CMD ["/usr/sbin/sshd", "-D"]
