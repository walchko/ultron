# Time Machine and Samba

> **WARNING:** Apple appears to have deprecated afp in favor of smb.
> Although I appear to be able to setup something using `netatalk`,
> the backups don't appear to be valid (macOS 30GB in size, but
> in linux only 4Kb in size).

```conf
# cat /etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   wins support = yes
   dns proxy = no

# Fruit global config
   fruit:aapl = yes
   fruit:nfs_aces = no
   fruit:copyfile = no
   fruit:model = MacSamba

# Samba will automatically "register" the presence of its server to the rest of the network using mDNS. Since we are using avahi for this we can disable mdns registration.
   multicast dns register = no

#### Debugging/Accounting ####
   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d

####### Authentication #######
   server role = standalone server
   passdb backend = tdbsam
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user


######## Protocol versions ######
#   client max protocol = default
#   client min protocol = SMB2_02
#   server max protocol = SMB3
#   server min protocol = SMB2_02

############ Misc ############
# Allow users who've been granted usershare privileges to create
# public shares, not just authenticated ones
   usershare allow guests = yes

#======================= Share Definitions =======================
[nfs]
   read only = no
   path = /mnt/nfs
   guest ok = yes

[apple]
   read only = no
   path = /mnt/apple
   guest ok = yes

[timemachine]
  # Load in modules (order is critical!)
  vfs objects = catia fruit streams_xattr
  fruit:time machine = yes
  fruit:time machine max size = 300G
  comment = Time Machine Backup
  path = /mnt/timemachine
  available = yes
  valid users = kevin
  browseable = yes
  guest ok = yes
  writable = yes
```

`cat /etc/avahi/services/samba.service`

```xml
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_smb._tcp</type>
    <port>445</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>0</port>
    <txt-record>model=TimeCapsule8,119</txt-record>
  </service>
  <service>
    <type>_adisk._tcp</type>
    <txt-record>dk0=adVN=timemachine,adVF=0x82</txt-record>
    <txt-record>sys=waMa=0,adVF=0x100</txt-record>
  </service>
</service-group>
```

```bash
chown kevin:kevin -R /mnt/timemachine
```

# References

- [Time Machine with Samba](https://blog.jhnr.ch/2023/01/09/setup-apple-time-machine-network-drive-with-samba-on-ubuntu-22.04/)
- [Another Time Machine with Samba](https://dev.to/ea2305/time-machine-backup-with-your-home-server-1lj6)
- samba.org: [smb.conf](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html)