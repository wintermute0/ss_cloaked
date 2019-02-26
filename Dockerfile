FROM centos:7

# install dependencies
RUN yum install epel-release -y
RUN yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel -y
RUN yum install wget -y

# install shadowsocks-libev
RUN cd /etc/yum.repos.d/ ; wget https://copr.fedoraproject.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo
RUN yum install shadowsocks-libev -y

# install Cloak
RUN rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
RUN curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
RUN yum install go -y
RUN yum install make -y

RUN cd /etc ; git clone https://github.com/cbeuw/Cloak.git
RUN cd /etc/Cloak ; make server

# config shadowsocks, ss_opt is '-p password -c[cloaked]'
COPY ./setup.py /etc
ARG SS_OPT=
RUN python /etc/setup.py $SS_OPT

# start
ENTRYPOINT ["ss-server", "-v", "-c", "/etc/shadowsocks-libev/config.json"]