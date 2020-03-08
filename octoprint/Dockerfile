FROM python:3.7-buster AS builder
LABEL maintainer walchko
WORKDIR /opt/octoprint


RUN apt-get update -qq \
    && apt-get install --no-install-recommends -yq \
        python3-dev \
        build-essential \
    && pip3 install virtualenv \
    && /usr/local/bin/virtualenv /opt/octoprint/venv \
    && . venv/bin/activate \
    && pip3 install -U pip setuptools wheel \
    && pip3 install -U octoprint

# Create an user to run things and change permissions
FROM python:3.7-slim-buster
WORKDIR /opt/octoprint
RUN useradd -ms /bin/bash octoprint \
    && adduser octoprint dialout
COPY --chown=octoprint:octoprint --from=builder /opt/octoprint .

USER octoprint

# This fixes issues with the volume command setting wrong permissions
RUN mkdir /home/octoprint/.octoprint \
    && chown -R octoprint:octoprint /home/octoprint/.octoprint \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /tmp/*

VOLUME /home/octoprint/.octoprint


EXPOSE 5000

CMD ["/opt/octoprint/venv/bin/octoprint", "serve"]
