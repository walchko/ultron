
![](https://upload.wikimedia.org/wikipedia/commons/2/24/Ansible_logo.svg)

---

Ansible is an agentless automation scripting language (using yaml files and back end is python) that uses SSH to access servers and execute commands. Owned now by Red Hat, but still open source.

- *Optional*: setup virtualenv
    - `python3 -m venv ~/ansi`
    - `source ~/ansi/bin/activate`
    - `pip install -U pip setuptools wheel`
- Install: `pip install ansible`

## Usage

Simple ping example of all the servers listed in the inventory file:

- `ansible -i inventory multi -m ping`

| Switch | Notes |
|--------|-------|
|`-i inventory`| inventory file shown below, could be called anything
|`multi`       | is the group which contains the sub groups `pis` and `ubuntu`
|`-m ping`     | calls the ping module

- `ansible-playbook mybook.yml`
  
| Switch | Notes |
|--------|-------|
| `-v`   | verbose
| `-vv`  | very verbose
| `-vvvv`| super verbose
| `-b`   | Elevate to root user  |
| `-i <file>` | Use an inventory file which contains info about servers |
| `-u <user>` | Specify what user to login as |
|`--ask-pass` | ask ssh password
|`--ask-become-pass` | ask sudo password on remote system
|`--ask-vault-pass` | ask vault password to decrypt



## Inventory
```
# Simple stupid inventory example
[pis]
raspberrypi.local

[pis:vars]
ansible_user=pi

[ubuntu]
ubuntu.local

[ubuntu:vars]
ansible_user=ubuntu

[multi:children]
pis
ubuntu
```

To see what ansible knows about your system:

```
ansible -i inventory -u pi raspberrypi.local -m setup

# if you setup a ansible.cfg with NVENTORY = inventory.yml
ansible -u pi -m setup raspberrypi.local
ansible -u pi -m ping raspberrypi.local
```

A large dictionary of information will print to the screen. This info can also be
used dynamically.


## Configuration

```
```

# References

- Ansible docs: [List of Modules](https://docs.ansible.com/ansible/2.9/modules/list_of_packaging_modules.html)
