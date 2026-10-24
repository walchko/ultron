#
# FROM debian:stretch
# FROM python:3.9-buster
FROM ubuntu:20.04

RUN apt-get update -qq \
    && apt-get install -yq \
        locales \
        locales-all \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Not essential, but wise to set the lang
# Note: Users with other languages should set this in their derivative image
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Python binary and source dependencies
RUN apt-get update -qq \
    && apt-get install -yq --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        htop \
        libcurl4-openssl-dev \
        libffi-dev \
        libsqlite3-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        ffmpeg \
        sqlite3 \
        wget \
        zlib1g-dev \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qq \
    && apt-get install -yq \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install the recent pip release
# RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
#     python2 get-pip.py && \
#     python3 get-pip.py && \
#     rm get-pip.py && \
#     pip2 --no-cache-dir install requests[security] && \
#     pip3 --no-cache-dir install requests[security] && \
#     rm -rf /root/.cache

# Install some dependencies.

# RUN python3 -m venv /venv
#
# RUN . /venv/bin/activate \
#     && pip3 --no-cache-dir install -U \
#         pip \
#         setuptools \
#         wheel \
#         jupyter \
#         colorama \
#         attrs \
#         msgpack \
#         pillow \
#         pyyaml \
#         pyzmq \
#         simplejson \
#         numpy \
#         opencv-python \
#         matplotlib \
#     && rm -rf /root/.cache

# Move notebook contents into place.
# ADD . /usr/src/jupyter-notebook
# ADD ./.bashrc /root
# ADD ./hostname /etc

#pip3 install --no-cache-dir /usr/src/jupyter-notebook && \
#pip2 install --no-cache-dir widgetsnbextension && \
#pip3 install --no-cache-dir widgetsnbextension && \

# # Install dependencies and run tests.
# #RUN BUILD_DEPS="nodejs" && \
# RUN apt-get install -yq $BUILD_DEPS && \
#     \
#     apt-get clean && \
#     rm -rf /root/.cache && \
#     rm -rf /root/.config && \
#     rm -rf /root/.local && \
#     rm -rf /root/tmp && \
#     rm -rf /var/lib/apt/lists/* && \
#     apt-get purge -y --auto-remove \
#         -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $BUILD_DEPS

# Run tests.
#RUN pip3 install --no-cache-dir notebook[test] && nosetests -v notebook

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/ \
    && echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py

# VOLUME /notebooks
# WORKDIR /notebooks

# EXPOSE 8888

RUN useradd -ms /bin/bash jupuser \
    && chsh --shell /bin/bash jupuser

USER jupuser

COPY --chown=jupuser:jupuser bashrc /home/jupuser/.bashrc

# Add a notebook profile.
RUN mkdir -p -m 700 /home/jupuser/.jupyter/ \
    && chown -R jupuser:jupuser /home/jupuser/.jupyter \
    && echo "c.NotebookApp.ip = '*'" >> /home/jupuser/.jupyter/jupyter_notebook_config.py

RUN python3 -m venv /home/jupuser/venv \
    && . /home/jupuser/venv/bin/activate \
    && pip3 --no-cache-dir install -U \
        pip \
        setuptools \
        wheel \
        jupyter \
        colorama \
        attrs \
        msgpack \
        pillow \
        pyyaml \
        pyzmq \
        simplejson \
        numpy \
        opencv-python \
        matplotlib \
        slurm \
    && rm -rf /home/jupuser/.cache

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -


#RUN mkdir -p -m 700 /home/jupuser/tmp \
#    && chown -R jupuser:jupuser /home/jupuser/tmp

WORKDIR /  
# WORKDIR /home/jupuser

# COPY --chown=jupuser:jupuser cert.pem .

#VOLUME /home/jupuser

# This fixes issues with the volume command setting wrong permissions
# RUN chown -R jupuser:jupuser /home/jupuser

# COPY bashrc /root/.bashrc
COPY bashrc /home/jupuser/.bashrc
# ENV PATH=""
# , "--certfile=/home/jupuser/cert.pem"
CMD ["/home/jupuser/venv/bin/jupyter-notebook", "--no-browser", "--allow-root", "--NotebookApp.token=1234"]

#entrypoint /bin/bash
#ENTRYPOINT /bin/bash
