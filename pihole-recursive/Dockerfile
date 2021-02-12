FROM pihole/pihole:latest

# ENV PYTHONIOENCODING=UTF-8
# ENV LC_ALL=en_US.UTF-8
# ENV LANGUAGE=en_US.UTF-8

# RUN apt-get update && apt-get install -y openssh-server sudo python3
# RUN mkdir /var/run/sshd

# # user:password | chpasswd
# RUN useradd -ms /bin/bash pi && echo "pi:raspberry" | chpasswd
# RUN adduser pi sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
# EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]



# EXPOSE 22
# EXPOSE 53/tcp
# EXPOSE 53/udp
# EXPOSE 443/tcp
# EXPOSE 5335/tcp
# EXPOSE 5335/udp

# doesn't work
# ENV LANGUAGE en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

RUN apt-get update -qq \
    && apt-get install -y unbound \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# doesn't work
# ENV LANGUAGE en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

COPY pi-hole.conf /etc/unbound/unbound.conf.d/pi-hole.conf

RUN echo "WEBTHEME=default-dark" >> /etc/pihole/setupVars.conf
# RUN echo "https://raw.githubusercontent.com/walchko/judoon/master/hosts.txt" >> /etc/pihole/adlists.list \
#     && pihole -g

# RUN service unbound restart
