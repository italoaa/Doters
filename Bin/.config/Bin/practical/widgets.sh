#!/bin/bash
if [ $1 -eq 1 ]
then
    echo "true"
    ## Change how yabai looks
    yabai -m config layout bsp
    yabai -m config top_padding 34
    yabai -m config bottom_padding 5
    yabai -m config left_padding 240
    yabai -m config right_padding 5
    yabai -m config window_gap 10
fi

if [ $1 -eq 0 ]
then
    echo "false"
    ## Change how yabai looks
    yabai -m config layout bsp
    yabai -m config top_padding 10
    yabai -m config bottom_padding 10
    yabai -m config left_padding 10
    yabai -m config right_padding 10
    yabai -m config window_gap 10
fi
