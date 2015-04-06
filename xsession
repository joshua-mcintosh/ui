#!/usr/bin/env zsh

setup () {
        start-pulseaudio-x11 &
        eval $(gnome-keyring-daemon --start --components=gpg) &
        eval $(gnome-keyring-daemon --start --components=secrets) &
        eval $(gnome-keyring-daemon --start --components=ssh) &
        eval $(gnome-keyring-daemon --start --components=pkcs11) &
        nm-applet &
        xset +fp ~/.fonts/
        xset +fp /usr/local/share/fonts/
        #xset +fp /usr/share/fonts/TTF/
        #xset +fp /usr/share/fonts/OTF/
        xset +fp /usr/share/fonts/truetype
        xset +fp /usr/share/fonts/opentype
        xset +fp /usr/share/fonts/X11
        xset fp rehash
        xrdb -merge ~/.Xdefaults
        xfce4-power-manager &
        dunst &
        dropbox start &
		tmux set-environment -g DISPLAY $DISPLAY &
		urxvtd -f -o -q &
        #xcompmgr -C -c &
		. /$HOME/.fehbg;
}

case $1 in
	
	openbox-session|Openbox)
		setup &
		 dbus-launch --exit-with-session openbox-session;
		;;

    wmii|Wmii|WMII)
        setup &
         dbus-launch --exit-with-session wmii;
        ;;

    rio|plan9)
        setup &
        xautolock -time 15 -locker slock &
         dbus-launch --exit-with-session rio -term urxvtc -virtuals 4;
        ;;

    herbstluftwm|hc)
        setup &
        xautolock -time 15 -locker slock &
         dbus-launch --exit-with-session herbstluftwm;
        ;;

	dwm|Dwm)
		setup &
        (bash -c 'conky | while read; do xsetroot -name "$REPLY"; done') &
        xautolock -time 15 -locker slock &
        xbindkeys &
		 dbus-launch --exit-with-session dwm;
		;;

    monsterwm|monster)
        setup &
        xautolock -time 15 -locker slock &
        xbindkeys &
         dbus-launch --exit-with-session monster_and_bar.sh;
        ;;

    bspwm|'')
        setup &
        xautolock -time 15 -locker slock &
        xbindkeys &
        sxhkd &
         dbus-launch --exit-with-session bspwm;

esac

