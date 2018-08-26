#
# Ubuntu Desktop (Gnome) Dockerfile
#
# https://github.com/intlabs/Docker-Ubuntu-Desktop-Gnome
#

# Install GNOME3 and VNC server.
# (c) Pete Birley

# Pull base image.
FROM ubuntu:14.04

# Setup enviroment variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOSTNAME xsun-dev

RUN mkdir /home/xsun
RUN mkdir /home/xsun/.vim
ENV HOME=/home/xsun
WORKDIR $HOME

#Update the package manager and upgrade the system
RUN apt-get update && \
apt-get upgrade -y && \
apt-get update


# Installing fuse filesystem is not possible in docker without elevated priviliges
# but we can fake installling it to allow packages we need to install for GNOME
RUN apt-get install libfuse2 -y && \
cd /tmp ; apt-get download fuse && \
cd /tmp ; dpkg-deb -x fuse_* . && \
cd /tmp ; dpkg-deb -e fuse_* && \
cd /tmp ; rm fuse_*.deb && \
cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst && \
cd /tmp ; dpkg-deb -b . /fuse.deb && \
cd /tmp ; dpkg -i /fuse.deb

# Upstart and DBus have issues inside docker.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

# Install GNOME and tightvnc server.
RUN apt-get update && apt-get install -y xorg gnome-core gnome-session-fallback tightvncserver libreoffice
RUN apt-get update && apt-get install -y rpcbind nfs-common g++  vim ssh net-tools iputils-ping cscope git gdb autocutsel 

RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:alessandro-strada/google-drive-ocamlfuse-beta
RUN apt-get update
RUN apt-get install google-drive-ocamlfuse

# Pull in the hack to fix keyboard shortcut bindings for GNOME 3 under VNC
ADD script/gnome-keybindings.pl /usr/local/etc/gnome-keybindings.pl
RUN chmod +x /usr/local/etc/gnome-keybindings.pl

# Add the script to fix and customise GNOME for docker
ADD script/gnome-docker-fix-and-customise.sh /usr/local/etc/gnome-docker-fix-and-customise.sh
RUN chmod +x /usr/local/etc/gnome-docker-fix-and-customise.sh

# Set up VNC
ADD script/cn1.jpg /usr/share/backgrounds/gnome/cn1.jpg
ADD script/cn2.jpg /usr/share/backgrounds/gnome/cn2.jpg
ADD script/.bashrc /home/xsun/.bashrc
ADD vim/.   /home/xsun/.
RUN mkdir -p /home/xsun/.vnc
RUN mkdir -p /home/xsun/work
RUN mkdir -p ~/.config/nautilus
ADD script/xstartup /home/xsun/.vnc/xstartup
RUN chmod 755 /home/xsun/.vnc/xstartup
ADD script/spawn-desktop.sh /usr/local/etc/spawn-desktop.sh
RUN chmod +x /usr/local/etc/spawn-desktop.sh
RUN apt-get install -y expect
ADD script/start-vnc-expect-script.sh /usr/local/etc/start-vnc-expect-script.sh
RUN chmod +x /usr/local/etc/start-vnc-expect-script.sh
ADD script/vnc.conf /etc/vnc.conf
RUN service rpcbind start

RUN echo 'root:root' |chpasswd
RUN useradd xsun
RUN usermod -aG sudo xsun
RUN echo 'xsun:xsun' |chpasswd
USER xsun




# Define default command.
#CMD bash -C '/usr/local/etc/spawn-desktop.sh';'bash'


# Expose ports.
EXPOSE 5901 
EXPOSE 5902 

#docker run -ti -h xsun-dev -p 5901:5901 -p 5902:5902 --privileged=true ecb7dfc59485 bash 
#docker run -ti -p 5901:5901 --privileged --cap-add SYS_ADMIN --device /dev/fuse cdf33dadecd2 bash
#google-drive-ocamlfuse
#google-drive-ocamlfuse /home/xsun/work
