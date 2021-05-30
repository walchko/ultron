#
# FROM debian:stretch
# FROM python:3.9-buster
FROM ubuntu:20.04

# Not essential, but wise to set the lang
# Note: Users with other languages should set this in their derivative image
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING UTF-8

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
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        wget \
        zlib1g-dev \
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
RUN pip3 --no-cache-dir install -U \
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
    && rm -rf /root/.cache

# Move notebook contents into place.
#ADD . /usr/src/jupyter-notebook
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

CMD ["jupyter", "notebook", "--no-browser", "--allow-root"]
