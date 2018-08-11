#!/bin/sh
# (c) Pete Birley

#this sets the vnc password
/usr/local/etc/start-vnc-expect-script.sh
#fixes a warning with starting nautilus on firstboot - which we will always be doing.
USER=root mkdir -p ~/.config/nautilus
USER=root service rpcbind start
#this starts the vnc server
USER=root vncserver :1 -geometry 1920x1080 -depth 24
