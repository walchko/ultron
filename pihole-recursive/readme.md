![](container.png)

# Docker for Recursive PiHole

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/walchko/pihole-recursive)

## Using

- Build: `docker-compose build --compress --force-rm --no-cache --pull --parallel`
- Run: `docker-compose up`
    - You can add the `-d` switch to detach it from the terminal and run it in the background
- Stop:
    - if attached to terminal, use `ctrl-C`
    - if detached: `docker-compose down`

## Final Config

![](https://docs.pi-hole.net/images/RecursiveResolver.png)

- uncheck google
- add `127.0.0.1#5335`


# References

- [pihole unbound](https://docs.pi-hole.net/guides/dns/unbound/)
