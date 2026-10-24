FROM rockylinux:9
ENV ROOT_PASSWORD root
ENV ALICE_PASSWORD alice
ENV TIMEZONE America/Los_Angeles

# sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config; \
# sshd setup
RUN dnf -y --nodocs install openssh-server; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    ssh-keygen -q -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''; \
    dnf -y clean all;

# subscription-manager
# add useful commands
RUN dnf -y --nodocs install expect sudo rsync epel-release which nano; \
    dnf -y --nodocs install htop; \
    dnf -y remove vim-minimal; \
    dnf -y clean all;

# setup users and permissions
RUN useradd -ms /bin/bash alice && \
    echo "alice:${ALICE_PASSWORD}" | chpasswd; \
    adduser alice sudo; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
    echo "root:${ROOT_PASSWORD}" | chpasswd; \
    echo "alias ls='ls -h --color=auto'" >> /etc/bashrc; \
    echo "alias grep='grep --color=auto'" >> /etc/bashrc; \
    echo "export EDITOR=nano" >> /etc/profile; \
    ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

EXPOSE 22

# D: don't detach and thus not a daemon
# e: errors to stderr instead of system log
CMD ["/usr/sbin/sshd", "-D", "-e"]