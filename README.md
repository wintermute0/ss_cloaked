# Ubuntu:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

docker build -t ss_simple .
docker run -d -p 80:80 ss_simple

docker build -t ss_cloaked --build-arg SS_OPT=-c\ -p\ password .
docker run -d -p 443:443 ss_cloaked
```

# Connect to ss_locaked:

```
ss-local -c /usr/local/etc/shadowsocks-libev.json

shadowsocks-libev.json

"plugin":".../Cloak/build/ck-client",
"plugin_opts":".../Cloak/config/ckclient.json"

ckclient.json

"UID":"<AdminUID>",
"PublicKey":"<PK>",
```
