![](https://camo.githubusercontent.com/f00bfb9e2c9bab56de7d58355da8aa19db8f451e33ea11aa7ec1a37af0433fac/68747470733a2f2f63646e322e68756273706f742e6e65742f68756266732f353835363033392f646f636b65726875622f6b61736d5f6c6f676f2e706e67)

# Kasm

Kasm is a docker environment built off of Ubuntu (default), Suse or CentOS and a web server.
The webserver provides access to the desktop environment. Below is an example of `hackbox`
built off kasm (see more below).

> To run this image in a local environment start the docker container with the following command, 
> and connect to your machine on https://localhost:6901 and log in with username `kasm_user` and password `password`.
>
> ```
> docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password xcad2k/hackbox
> ```

- github [docker core images](https://github.com/kasmtech/workspaces-core-images) for building OS environments, where the desktop is available via a web browser
- github [docker app images](https://github.com/kasmtech/workspaces-images) which contain apps (Chrome, blender, gimp, etc) for use

## Hackbox

An example of building off of kasm, [hackbox](https://github.com/ChristianLempa/hackbox/blob/main/src/Dockerfile)

```dockerfile
FROM kasmweb/core-ubuntu-bionic:1.10.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME


######### Customize Container Here ###########

RUN apt update
RUN apt -y upgrade
RUN apt -y install openvpn
RUN apt -y install unzip

# Change Background to sth cool
COPY assets/mr-robot-wallpaper.png  /usr/share/extra/backgrounds/bg_default.png

# Install Starship
RUN wget https://starship.rs/install.sh
RUN chmod +x install.sh
RUN ./install.sh -y

# Add Starship to bashrc
RUN echo 'eval "$(starship init bash)"' >> .bashrc

# Add Starship Theme
COPY config/starship.toml .config/starship.toml

# Install Hack Nerd Font
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
RUN unzip Hack.zip -d /usr/local/share/fonts

# Install Terminator
RUN apt -y install terminator

# Set up Nerd font in Terminator
RUN mkdir .config/terminator
COPY config/terminator.toml .config/terminator/config

# Install XFCE Dark Theme
RUN apt install numix-gtk-theme


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
```
