# install shadowsocks
apt-get update
apt-get --yes install shadowsocks-libev 
vim /etc/shadowsocks-libev/config.json
systemctl restart shadowsocks-libev.service

# enable BBR 
echo 'net.core.default_qdisc=fq' > /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' > /etc/sysctl.conf
sudo sysctl -p
sysctl net.ipv4.tcp_congestion_control

