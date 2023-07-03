#!/bin/sh

G_MESSAGES_DEBUG=Dialogs.DRun rofi -show drun -drun-display-format {name} -theme $ROFI_THEMES/launch.rasi -filter "$1" 
