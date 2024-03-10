# File Server


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