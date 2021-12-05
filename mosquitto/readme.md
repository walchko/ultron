![Mosquitto Logo](https://raw.githubusercontent.com/docker-library/docs/757578e3a44e5460a8a11d32a81776f8b74231a9/eclipse-mosquitto/logo.png)

# Mosquitto

So, somewhere they changed `conf` to `config` and this didn't see my configuration
file ... all kinds of problems. **Becareful** of copy/paste examples from the
interweb, they may still have `conf`!

```
mqtt
├── data
├── log
│   └── mosquitto.log
├── config
│   └── mosquitto.conf
└── mosquitto.passwd
```

## Running

```
docker-compose up -d
```

## Annoying

For some reason, the container sets everything to `UID`/`GID` of `1883` which
requires you to change it back to `1000` so you can view the logs or change the
configuration file.

This can be fixed by making the `config` folder read only:

```yaml
volumes:
  - ./config:/mosquitto/config:ro
```

However, this does not fix the `log` folder.

## Debug

Check to see if anything is attached to the port, here we have `mosquitto`:

```
[sudo] password for kevin:
tcp6       0      0 :::1883                 :::*                    LISTEN      3035850/docker-prox
```

Use the `mosquitto` command to publish and subscribe to topics

```
(venv) 🐧 kevin@dalek ~ % mosquitto_pub -h 10.0.1.199 -t test -m "howdy" -p 8883 -d
Client mosq-z8nVKJReyRT36xjh0h sending CONNECT
Client mosq-z8nVKJReyRT36xjh0h received CONNACK (0)
Client mosq-z8nVKJReyRT36xjh0h sending PUBLISH (d0, q0, r0, m1, 'test', ... (5 bytes))
Client mosq-z8nVKJReyRT36xjh0h sending DISCONNECT
```

```
mosquitto_sub -h 10.0.1.199 - test -p 1883 -d
```

where:

- `h`: host ip address
- `t`: topic to publish/subscribe to
- `m`: message to send
- `p`: port to use, default is 1883
- `d`: prints a lot of debugging info

# References

- dockerhub: [eclipse-mosquitto image](https://hub.docker.com/_/eclipse-mosquitto)
- eclipse.org: [Python client docs](https://www.eclipse.org/paho/index.php?page=clients/python/docs/index.php)
- https://techoverflow.net/2021/11/25/how-to-setup-standalone-mosquitto-mqtt-broker-using-docker-compose/
- https://gitlab.com/robconnolly/hass-config/blob/master/docker-compose.yml
- https://centurio.net/2019/12/16/configure-mosquitto-mqtt-broker-user-authentication-in-docker-running-on-synology-nas/
