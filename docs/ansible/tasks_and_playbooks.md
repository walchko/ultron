# Playbooks


```yaml
---
- name: Debug string
  hosts: all
  gather_facts: false

  # scripting variables that apply to each task also
  vars:
    bob: "hello there bob"

  # global env variable that apply to each task also
  environment:
    LANG=fr_FR.UTF-8

  - debug: msg="The var is {{ bob }}"

  # import another playbook
  - import_playbook: apt.yml

  # include playbook, allows dynamic vars
  - include_playbook: play2.yml

  tasks:
    - name: Doing something cool using some_module
      some_module
      register: foo

    - debug: var=foo

    - debug: var=foo.key

    - debug: var=foo["key"]
```

For modularized playbooks, it can be confusing what higher level playbook
called a lower level playbook. Roles helps with this:

```yaml
roles:
    - python
```

Now, every `TASK` that prints, will pre-pend `python` onto the output.

## Var File

You can reference variables in a yaml file

```yaml
---
# playbook that doesn't have to change, you can
# just update vars.yml now
pre_tasks:
  - name: load variable files
    include_vars: "{{ item }}"
    with_first_found:
      - "{{ ansible_os_family }}.yml"
      - "default.yml"
```

```yaml
---
# default.yml
ip_addr: 10.100.100.10
count: 25
```

## APT

Can make more generic by using the `package` module rather than the `apt` module.

```yaml
---
- name: APT
  hosts: all
  tasks:
    - name: Pass options to dpkg on run
      ansible.builtin.apt:
        upgrade: dist
        update_cache: yes

    - name: Remove useless packages from the cache
      ansible.builtin.apt:
        autoclean: yes

    - name: Remove dependencies that are no longer required
      ansible.builtin.apt:
        autoremove: yes
```

## PIP

```yaml
---
- name: PIP
  ansible.builtin.pip:
    name:
      - django>1.11.0,<1.12.0
      - bottle>0.10,<0.20,!=0.11
```


## Commands and Shell

```yaml
---
- name: Commands and Shell
  hosts: all

  tasks:
    - name: Run shell
      ansible.builtin.shell: |
          apt install -y python3
          which python
    - name: Run command
      ansible.builtin.command: service httpd status
    - name: Run another command
      ansible.builtin.command: >
        service httpd status

```

## Services

```yaml
- name: Start httpd
  ansible.builtin.service:
    name: httpd
    state: started
    enable: true
```

## Homebrew

```yaml
# Update homebrew and upgrade all packages
- ansible.builtin.homebrew:
    update_homebrew: yes
    upgrade_all: yes

- ansible.builtin.homebrew:
    name: foo
    state: present
    install_options: with-baz,enable-debug
    update_homebrew: yes
```

## Env with Lineinfile

`become: false` turns off root priv and uses the login user.

```yaml
- name: Add env var to remote server bash env
  lineinfile:
    dest: "~/.bash_profile"
    regexp: '^ENV_VAR='
    line: 'ENV_VAR=value'
  become: false

- name: Get the vlue of the remote env var
  ansible.builtin.shell: |
    source ~/.bash_profile && echo $ENV_VAR
  register: foo

- debug: msg="The var is {{ foo.stdout }}"
```
