# Change IP Addr

`cat /etc/network/interfaces`:

```conf
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# primary nic dhcp
allow-hotplug ens18
iface ens18 inet dhcp
```

```conf
# primary nic static
auto ens18
iface ens18 inet static
    address 10.10.0.15/24
    gateway 10.10.0.1
    dns-nameservers 10.10.0.200 10.10.0.201
```