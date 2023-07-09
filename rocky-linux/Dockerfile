FROM rockylinux:9
ENV ROOT_PASSWORD root
ENV ALICE_PASSWORD alice
ENV TIMEZONE America/Los_Angeles

# sshd
RUN dnf -y install openssh-server openssh-clients; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config; \
    ssh-keygen -q -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''; \
    rm -f /run/nologin; \
    dnf clean all;

RUN useradd -ms /bin/bash alice && \
    echo "alice:${ALICE_PASSWORD}" | chpasswd; \
    echo "root:${ROOT_PASSWORD}" | chpasswd;
RUN ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]