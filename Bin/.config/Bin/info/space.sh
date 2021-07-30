#!/bin/bash

active=$(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index')

# var space is defined in the BBT app
space=1
index=$space-1
name=$(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.['"$index"'].label')
data="$space: $name"

active_color="0,0,0,255"

unactive_color="255,255,255,255"

active_background_color="172,218,232,255"

unactive_background_color="0,0,0,255"

true="{\"text\":\"$data\",\"font_color\":\"$active_color\",\"background_color\":\"$active_background_color\"}"
false="{\"text\":\"$data\",\"font_color\":\"$unactive_color\",\"background_color\":\"$unactive_background_color\"}"

if [[ $active -eq $space ]]
then
    # active
    echo $true
else
    echo $false
fi

