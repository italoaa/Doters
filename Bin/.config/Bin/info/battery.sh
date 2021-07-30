#!/bin/bash

export LC_TIME="en_US.UTF-8"
TIME=$(date +"%H:%M")
DATE=$(date +"%a %d/%m")

BATTERY_PERCENTAGE=$(pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto | cut -f1 -d'%')
BATTERY_STATUS=$(pmset -g batt | grep "'.*'" | sed "s/'//g" | cut -c 18-19)

data="$BATTERY_PERCENTAGE"

chargin_color="163,190,140,255"
 
not_chargin_color="255,255,255,255"

chagin_background_color="0,0,0,255"

not_chargin_background_color="0,0,0,255"

true="{\"text\":\"$data\",\"font_color\":\"$chargin_color\",\"background_color\":\"$chagin_background_color\"}"
false="{\"text\":\"$data\",\"font_color\":\"$not_chargin_color\",\"background_color\":\"$not_chargin_background_color\"}"




if [ "$BATTERY_STATUS" == "Ba" ]; then
    #Battery not Chargin
    echo $false
elif [ "$BATTERY_STATUS" == "AC" ]; then
    #Battery Chargin 
    echo $true
fi

