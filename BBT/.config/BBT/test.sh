#!/bin/bash

active=$(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index')

case $active in
    1)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[0].label')
        ;;

    2)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[1].label')
        ;;
        
    3)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[2].label')
        ;;
        
    4)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[3].label')
        ;;
        
    5)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[4].label')
        ;;
        
    6)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[5].label')
        ;;
        
    7)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[6].label')
        ;;
        
    8)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[7].label')
        ;;
        
    9)
        echo $(/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[8].label')
        ;;
esac


