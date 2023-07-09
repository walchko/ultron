FROM debian:latest
ENV ALICE_PASSWORD alice
ENV TIMEZONE 'America/Los_Angeles'

# add software
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 tzdata && \
    apt-get autoremove;

# sshd
RUN mkdir /run/sshd; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config;

# user:password | chpasswd
RUN useradd -ms /bin/bash alice; \
    echo "alice:${ALICE_PASSWORD}" | chpasswd; \
    adduser alice sudo; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;
RUN ln -fs "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
