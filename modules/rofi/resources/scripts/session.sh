#!/bin/sh

chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Hibernate\n󰍃  Log Out\n  Lock" | rofi -dmenu -i -theme $ROFI_THEMES/simple.rasi)

case "$chosen" in
	"  Power Off") poweroff ;;
	"  Restart") reboot ;;
	"  Suspend") systemctl suspend-then-hibernate ;;
	"  Hibernate") systemctl hibernate ;;
	"󰍃  Log Out") i3-msg exit ;;
	"  Lock") betterlockscreen -l ;;
	*) exit 1 ;;
esac
