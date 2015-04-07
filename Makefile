
SHELL = /bin/bash
DEFAULT = xmonad
.PHONY: all clean dmenu symlink-xmonad sxhkd wipe-wm xdefaults xsession

all: install

install: symlink-$(DEFAULT) dmenu xdefaults xsession completed

completed:
	@echo "UI make completed"

symlink-bspwm: wipe-wm confdir sxhkd
	@ln -s $(realpath bspwm) ${HOME}/.wm 2>/dev/null;\
	ln -s $(realpath bspwm) ${HOME}/.config/bspwm 2>/dev/null \
	|| [[ -h ${HOME}/.bspwm ]];\
	echo "Bspwm linked";

symlink-xmonad: wipe-wm sxhkd
	@ln -s $(realpath xmonad) ${HOME}/.wm 2>/dev/null;\
	ln -s $(realpath xmonad) ${HOME}/.xmonad 2>/dev/null \
	|| [[ -h ${HOME}/.xmonad ]];\
	echo "Xmonad linked";

sxhkd: confdir
	@ln -s $(realpath sxhkd) ${HOME}/.config 2>/dev/null \
	|| [[ -h ${HOME}/.config/sxhkd ]];\
	echo "Sxhkd linked";

dmenu: confdir
	@ln -s $(realpath dmenu) ${HOME}/.config 2>/dev/null \
	|| [[ -h ${HOME}/.config/dmenu ]]; \
	echo "Dmenu linked";

xdefaults:
	@unlink ${HOME}/.Xdefaults;\
	ln -s $(realpath Xdefaults) ${HOME}/.Xdefaults;\
	echo "Xdefaults linked";

xsession:
	@unlink ${HOME}/.xsession;\
	ln -s $(realpath xsession) ${HOME}/.xsession;\
	echo "Xsession linked";

confdir:
	@mkdir ${HOME}/.config 2>/dev/null || true;


wipe-wm:
	@unlink ${HOME}/.wm;
