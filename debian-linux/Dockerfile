FROM debian:latest
ENV ALICE_PASSWORD alice
ENV TIMEZONE 'America/Los_Angeles'

# add software
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 tzdata nano && \
    apt-get autoremove;

# sshd setup
RUN mkdir /run/sshd; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config;

# user:password | chpasswd
RUN useradd -ms /bin/bash alice; \
    echo "alice:${ALICE_PASSWORD}" | chpasswd; \
    adduser alice sudo; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
    echo "alias ls='ls -h --color=auto'" >> /etc/bashrc; \
    echo "alias grep='grep --color=auto'" >> /etc/bashrc; \
    echo "export EDITOR=nano" >> /etc/profile; \
    ln -fs "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime

EXPOSE 22

# D: don't detach and thus not a daemon
# e: errors to stderr instead of system log
CMD ["/usr/sbin/sshd", "-D", "-e"]
