FROM ubuntu:16.04

MAINTAINER taojun "taojun@doweidu.com"

RUN apt-get update
RUN apt-get install -y openssh-server

EXPOSE 22

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

RUN useradd work && RUN echo "work:work" | chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN su work -l -c"mkdir -p /home/work/.ssh && echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDfwFPFqt6ZIV/cTj7wNx+K2jVs2Iz2ArT/x72Y2HIfq5GZgKKwJ6zrPEauulou+4Hrk/dNCNHJ8VkCPXBCpU7R0tuY4joz0Ex+aHacF813yx6Sjx/UPrKya6dTtv3TZAYFKRgKBXCHtuPoWVkUpZCj6AUQ1yUIwPxzW2YJ8G7d4Q== taojun@doweidu.com' > /home/work/.ssh/authorized_keys"




CMD ["/usr/sbin/sshd", "-D"]
