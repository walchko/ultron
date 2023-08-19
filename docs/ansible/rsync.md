# `rsync`

> The `ansible.posix.synchronize` is a piece of shit! It only works if you
> are logging in as `root`, if you need to login as a user, then you
> are screwed!

This works by using `rsync` from the remote computer back to your computer
to pull files.

```yaml
- name: A better rsync that works
  ansible.builtin.shell: |
    rsync -r --rsh 'sshpass -p {{ password }} ssh' /here kevin@nibbler.local:/there
  become: true
```

## Setup

```
apt install rsync sshpass  # debian
dnf install rsync sshpass  # redhat - those fuckers!
```
