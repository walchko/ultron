# PiHole


```
apt update && upgrade -y
apt install curl htop -y
curl -sSL https://install.pi-hole.net | bash
```

- Change password: `pihole -a -p`
- Change to fahrenheit: `pihole -a -f`

## Black and White Lists

```
pihole -w mparticle.weather.com
pihole --regex [0-9a-zA-Z\-\.]+tiktok[0-9a-zA-Z\-\.]+
pihole --regex (\.|^)litix\.io$
```

## AdLists

```
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts,
https://raw.githubusercontent.com/walchko/judoon/master/hosts.txt,
https://v.firebog.net/hosts/AdguardDNS.txt,
https://v.firebog.net/hosts/Prigent-Adult.txt,
https://v.firebog.net/hosts/RPiList-Phishing.txt,
https://v.firebog.net/hosts/RPiList-Malware.txt,
https://v.firebog.net/hosts/Easyprivacy.txt,
https://v.firebog.net/hosts/Prigent-Ads.txt,
https://v.firebog.net/hosts/Admiral.txt,
https://v.firebog.net/hosts/static/w3kbl.txt
```

# References

- [Install](https://www.naturalborncoder.com/linux/2023/07/12/installing-pi-hole-on-proxmox/)
