

# Pi Hole

```
apt update && upgrade -y
apt install curl htop -y
curl -sSL https://install.pi-hole.net | bash
```

- Change password: `pihole -a -p`
- Change to fahrenheit: `pihole -a -f`

[Ref](https://www.naturalborncoder.com/linux/2023/07/12/installing-pi-hole-on-proxmox/)

## Black and White Lists

```
pihole -w mparticle.weather.com
pihole --regex [0-9a-zA-Z\-\.]+tiktok[0-9a-zA-Z\-\.]+
pihole --regex (\.|^)litix\.io$
```
## AdLists

```
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://raw.githubusercontent.com/walchko/judoon/master/hosts.txt
https://v.firebog.net/hosts/AdguardDNS.txt
https://v.firebog.net/hosts/Prigent-Adult.txt
https://v.firebog.net/hosts/RPiList-Phishing.txt
https://v.firebog.net/hosts/RPiList-Malware.txt
https://v.firebog.net/hosts/Easyprivacy.txt
https://v.firebog.net/hosts/Prigent-Ads.txt
https://v.firebog.net/hosts/Admiral.txt
https://v.firebog.net/hosts/static/w3kbl.txt
```

https://discourse.pi-hole.net/t/pi-hole-as-part-of-a-post-installation-script/3523/4

```
curl -L https://install.pi-hole.net | bash /dev/stdin --unattended
```

create `/etc/pihole/setupVars.conf`

```
echo -n P@ssw0rd | sha256sum | awk '{printf "%s",$1 }' | sha256sum
```
```
WEBPASSWORD=<some_double_sha256_hash>
PIHOLE_INTERFACE=eth0
IPV4_ADDRESS=192.168.x.y/24
IPV6_ADDRESS=fd00::2
QUERY_LOGGING=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=false
INSTALL_WEB_SERVER=false
DNSMASQ_LISTENING=single
PIHOLE_DNS_1=8.8.8.8
PIHOLE_DNS_2=8.8.4.4
PIHOLE_DNS_3=2001:4860:4860:0:0:0:0:8888
PIHOLE_DNS_4=2001:4860:4860:0:0:0:0:8844
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSSEC=false
TEMPERATUREUNIT=C
WEBUIBOXEDLAYOUT=traditional
API_EXCLUDE_DOMAINS=
API_EXCLUDE_CLIENTS=
API_QUERY_LOG_SHOW=all
API_PRIVACY_MODE=false
BLOCKING_ENABLED=true
REV_SERVER=true
REV_SERVER_CIDR=192.168.x.0/24
REV_SERVER_TARGET=192.168.x.z
REV_SERVER_DOMAIN=my.local.domain
CACHE_SIZE=10000
```

# Reference

- [ansible pihole](https://codeberg.org/ansible/pihole)