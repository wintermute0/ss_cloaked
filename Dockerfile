FROM centos:7

# install dependencies
RUN yum install epel-release -y
RUN yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel -y

# install shadowsocks-libev
RUN cd /etc/yum.repos.d/
RUN wget https://copr.fedoraproject.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo
RUN yum update -y
RUN yum install shadowsocks-libev -y

# install Cloak
RUN rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
RUN curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
RUN yum install go -y
RUN yum install make -y

RUN cd /etc
RUN git clone https://github.com/cbeuw/Cloak.git
RUN cd Cloak
RUN make server

# config shadowsocks, ss_opt is '-p password -c[cloaked]'
RUN python setup.sh $ss_opt

# run application on startup
RUN systemctl enable shadowsocks-libev
RUN systemctl start shadowsocks-libev
RUN systemctl status shadowsocks-libev
RUN chkconfig shadowsocks-libev on

# configure firewall (if needed)
RUN firewall-cmd --zone=public --add-port=80/tcp --permanent
RUN firewall-cmd --zone=public --add-port=80/udp --permanent
RUN firewall-cmd --zone=public --add-port=443/tcp --permanent
RUN firewall-cmd --zone=public --add-port=443/udp --permanent
RUN firewall-cmd --reload

# watch log
RUN journalctl | grep ss-server