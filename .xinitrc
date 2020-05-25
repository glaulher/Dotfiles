#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)
#invoke global X session script
#. /etc/X11/Xsession &
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

systemctl --user set-environment DISPLAY=:0

sleep 1 && $HOME/.config/i3status/i3status_scripts/openweatherrun &
sleep 2 && $HOME/.config/i3status/i3status_scripts/calendar &
sleep 4 && pnmixer &
sleep 6 && cbatticon &
sleep 10 && $HOME/.config/i3status/i3status_scripts/power_menu &

# Aqui o i3 é mantido como padrão
session=${1:-i3}

case $session in
    i3|i3wm           ) exec i3;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    # Nenhuma sessão conhecida, tenta como comando
    *                 ) exec $1;;
esac
