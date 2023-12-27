<img src="https://pi-hole.github.io/graphics/Vortex/Vortex_with_Wordmark.svg" width="150">

---

## Use DHCP

1. Setup Google WiFi to **ONLY** service 1 address to pihole server
2. Enable DHCP on pihole
    - If using `docker-compose`, remove all `ports` and add `network_mode: host`
      this gives the container the same IP addresses as the host and DHCP will
      now work. You can still `ssh` into the machine

## Better Blacklists

My [list](https://github.com/walchko/judoon/tree/master)

- https://firebog.net keeps a good list of domains to avoid
- [pihole](https://pi-hole.net/blog/2023/03/22/pi-hole-ftl-v5-22-web-v5-19-and-core-v5-16-1-released/#page-content)
  now supports ABP (Ad Block Plus) formats for domains which should be faster than
  regex:
  - `||ads.example.com^` will block:
    - http://ads.example.com
    - http://more.ads.example.com/foo.gif
    - https://ads.example.com:8000
  - it will **not** block http://ads.example.com.ua
- If you update the adlist, go to: Tools -> Update Gravity -> Update

## Groups and Clients

**Don't use!!**

Ok, so this allows you to build groups of clients and apply different adlists to. I have 
**no** need for this.
