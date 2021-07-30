#!/bin/bash

cputemp=$(/usr/local/bin/istats fan | /usr/bin/awk 'FNR == 2 {print $4}')

# low
low_color="158,236,139,255"
low_background_color="0,0,0,255"
low="{\"text\":\"$cputemp\",\"font_color\":\"$low_color\",\"background_color\":\"$low_background_color\"}"

# mid
mid_color="236,233,139,255"
mid_background_color="0,0,0,255"
mid="{\"text\":\"$cputemp\",\"font_color\":\"$mid_color\",\"background_color\":\"$mid_background_color\"}"

#high
high_color="236,188,139,255"
high_background_color="0,0,0,255"
high="{\"text\":\"$cputemp\",\"font_color\":\"$high_color\",\"background_color\":\"$high_background_color\"}"

# Max
max_color="236,139,139,255"
max_background_color="0,0,0,255"
max="{\"text\":\"$cputemp\",\"font_color\":\"$max_color\",\"background_color\":\"$max_background_color\"}"



if [[ $cputemp < 2000 ]]; then
    echo $low
elif [[ $cputemp < 3000 ]]; then
    echo $mid
elif [[ $cputemp < 4000 ]]; then
    echo $high
elif [[ $cputemp < 5000 ]]; then
    echo $max
fi

