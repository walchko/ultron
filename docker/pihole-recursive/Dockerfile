FROM pihole/pihole:latest

RUN apt-get update -qq \
    && apt-get install -y unbound \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY pi-hole.conf /etc/unbound/unbound.conf.d/pi-hole.conf

RUN echo "WEBTHEME=default-dark" >> /etc/pihole/setupVars.conf
