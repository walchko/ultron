![](https://camo.githubusercontent.com/73fd8305ca1a62929a093f3923ba25659c825757/68747470733a2f2f70692d686f6c652e6769746875622e696f2f67726170686963732f566f727465782f566f727465785f776974685f746578742e706e67)

# PiHole

# Setup

## Ubuntu Fixes
Follow the [documentation](https://github.com/pi-hole/docker-pi-hole) from github.
For Ubuntu systems, summary of steps:

- Modern releases of Ubuntu (17.10+) include [`systemd-resolved`](http://manpages.ubuntu.com/manpages/bionic/man8/systemd-resolved.service.8.html) which is configured by default to implement a caching DNS stub resolver. This will prevent pi-hole from listening on port 53.
    - The stub resolver should be disabled with: `sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf`
    - All this does is uncomment `DNSStubListener` and set it to `no` in`/etc/systemd/resolved.conf`
- This will not change the nameserver settings, which point to the stub resolver thus preventing DNS resolution. Change the `/etc/resolv.conf` symlink to point to `/run/systemd/resolve/resolv.conf`, which is automatically updated to follow the system's [`netplan`](https://netplan.io/):
`sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'`
    - All this does is create a symlink:  `/etc/resolv.conf -> /run/systemd/resolve/resolv.conf`

## Run this Dockerfile

- Create a `.env` file:
    ```
    PASSWORD="my-cool-password"
    HOST_IP=1.2.3.4
    DNS_1=127.0.0.1
    DNS_2=1.2.3.4
    ```
- Run `docker-compose up -d` to get things going
    - `-d` will detach it from the terminal, you can omit and use `ctrl-c` to shut it down
- To terminate, use: `docker-compose down`
- You must be in this sub folder with the yaml to run `up` and `down` commands

# Change Log

| Version | Date | Log |
|-------|-------------|------------------------------|
| 0.1.0 |  8 Mar 2020 | init                         |
