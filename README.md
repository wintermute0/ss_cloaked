# for ubuntu:

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

docker build -t ss_cloaked
docker run -d -p 80:80 ss_cloaked
