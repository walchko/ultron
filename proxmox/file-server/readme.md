# File Server

You can't do an NFS server from a container

## NFS

```
sudo apt install nfs-kernel-server
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
```


Share directory, nfs defaults `root` user actions to `nobody:nogroup` so make sure they own it

```
sudo mkdir /mnt/nfs -p
sudo chown nobody:nogroup -R /mnt/nfs
sudo chmod 755 /mnt/nfs
```

```
sudo sh -c 'echo "/mnt/nfs 10.0.1.0/24(rw,sync,no_subtree_check)" >> /etc/exports'
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
```

```
$ sudo cat /proc/fs/nfsd/versions
-2 +3 +4 +4.1 +4.2
```

## Samba

```bash
sudo apt install samba samba-common samba-common-bin cifs-utils python3-pexpect
```

```conf
/etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   wins support = yes
   dns proxy = no

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

############ Misc ############
# Allow users who've been granted usershare privileges to create
# public shares, not just authenticated ones
   usershare allow guests = yes

#======================= Share Definitions =======================
[nfs]
   read only = no
   path = /mnt/nfs
   guest ok = yes
```

```bash
sudo systemctl restart smbd.service
sudo systemctl restart nmbd.service
```

```bash
# not sure you need to do this
smbpasswd -a [username]
```

```
iptables -A INPUT -p udp --dport 137 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
iptables -A INPUT -p udp --dport 138 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 139 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 445 -s 10.0.1.0/24 -m state --state NEW -j ACCEPT
```





## Ansible Stuff

```ansible
- name: Create Samba configuration
  ansible.builtin.template:
    src: samba.conf.j2
    dest: "{{ smb_conf }}"
    owner: root
    group: root
    mode: u=rw,go=r
  notify:
    - testparm
    - restart samba

- name: Configure Samba share(s)
  ansible.builtin.blockinfile:
    path: "{{ smb_conf }}"
    insertafter: "#===== Share Definitions ====="
    block: |
      [{{ samba.label }}]
      path = "{{ samba.path }}"
      available = {{ samba.available }}
      valid users = {{ samba.users | join(" ") }}
      browsable = {{ samba.browsable }}
      read only = {{ samba.readonly }}
      writable = {{ samba.writable }}

# Username used must belong to a an existing system account, else it won't save
- name: Set Samba password
  ansible.builtin.expect:
    command: smbpasswd -a {{ smb_user }}
    timeout: 3
    responses:
      'New SMB password': "{{ lookup('community.general.passwordstore', 'hosts/'~inventory_hostname~'/samba/'~smb_user~'') }}"
      'Retype new SMB password': "{{ lookup('community.general.passwordstore', 'hosts/'~inventory_hostname~'/samba/'~smb_user~'') }}"
  loop: "{{ samba.users }}"
  loop_control:
    loop_var: smb_user
  no_log: true
  notify: restart samba
```

# References

- [ansible samba install](https://codeberg.org/ansible/samba/src/branch/main/tasks/config.yml)