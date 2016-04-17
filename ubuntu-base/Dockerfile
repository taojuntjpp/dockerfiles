FROM ubuntu:16.04

MAINTAINER taojun "taojun@doweidu.com"

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

EXPOSE 22

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

RUN useradd work
RUN echo "work:work" | chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


CMD ["/usr/sbin/sshd", "-D"]
