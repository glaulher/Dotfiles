#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)
#invoke global X session script
. /etc/X11/Xsession &

pnmixer && sleep 1 &
cbatticon && sleep 1 &
$HOME/.config/i3status/i3status_scripts/openweatherrun && sleep 1 &
sleep 6 && $HOME/.config/i3status/i3status_scripts/calendar &
sleep 10 && $HOME/.config/i3status/i3status_scripts/power_menu &

#systemctl --user set-environment DISPLAY=:0

# Aqui o i3 é mantido como padrão
session=${1:-i3}

case $session in
    i3|i3wm           ) exec i3;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    # Nenhuma sessão conhecida, tenta como comando
    *                 ) exec $1;;
esac
