FROM alpine:latest

ARG ROOT_PASSWORD=root
ARG USERNAME=rick
ARG PASSWORD=rick
ARG TIMEZONE=America/Los_Angeles

# sshd setup
RUN apk update; \
    apk upgrade; \
    apk add --no-cache openssh-server; \
    ssh-keygen -q -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' \
        && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
        && ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''; \
    mkdir -p /home/${USERNAME}/.ssh;

RUN apk add --no-cache \
        sudo \
        python3 \
        nano \
        bash \
        figlet \
        tzdata; \
    rm /var/cache/apk/*

# setup users and permissions
RUN adduser -s /bin/bash ${USERNAME} wheel; \
    echo "${USERNAME}:${PASSWORD}" | chpasswd; \
    echo '${USERNAME} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
    echo "root:${ROOT_PASSWORD}" | chpasswd; \
    sed -i 's/root:\/bin\/ash/root:\/bin\/bash/g' /etc/passwd; \
    echo "export EDITOR=nano" >> /etc/profile; \
    ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak; \
    mv /etc/motd /etc/motd.bak; \
    mv /etc/profile /etc/profile.bak;

COPY sshd_config /etc/ssh/
COPY motd /etc/motd
COPY profile /etc/profile
COPY bashrc /etc/bashrc
COPY authorized_keys /home/${USERNAME}/.ssh

RUN chmod a+x /etc/bashrc; \
    ln -s /etc/bashrc /home/${USERNAME}/.bashrc; \
    ln -s /etc/bashrc /root/.bashrc; \
    chmod a+x /etc/motd; \
    mv /etc/bash /etc/bash.old;

EXPOSE 22

# D: don't detach and thus not a daemon
# e: errors to stderr instead of system log
CMD ["/usr/sbin/sshd", "-D", "-e"]