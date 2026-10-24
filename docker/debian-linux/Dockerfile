FROM debian:stable-slim
# FROM debian:latest
# FROM ubuntu:rolling
# FROM ubuntu:latest

ENV ALICE_PASSWORD alice
ENV TIMEZONE 'America/Los_Angeles'
ARG DEBIAN_FRONTEND=noninteractive

# add software
RUN apt-get update && \
    apt-get install -y  --no-install-recommends \
        openssh-server \
        sudo \
        python3 \
        tzdata \
        nano;

RUN apt purge -y curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc \
    && rm -rf /usr/share/man \
    && apt autoremove -y \
    && apt clean -y

# sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
# sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config;
# sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config;
# echo "PasswordAuthentication no" >> /etc/ssh/sshd_config; \
# echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config; \
# sshd setup
RUN mkdir /run/sshd; \
    sed -i 's/^\(PrintMotd\) .*/\1 yes/' /etc/ssh/sshd_config; \
    sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config; \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config; \
    echo "AllowUsers alice" >> /etc/ssh/sshd_config; \
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config;

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
