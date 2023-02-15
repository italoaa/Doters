#!/usr/bin/env bash

status="$(mpc status)"

if [ "$(echo "$status" | wc -l | tr -d ' ')" == "1" ]; then
  output=""
  icon=""
else
  artist=$(mpc current -f %artist%)
  if [ "$artist" == "" ]; then
    artist="_"
  fi

  song=$(mpc current -f %title%)
  if [ "$song" == "" ]; then
    song="_"
  fi
  icon=""


  if [ "$song" == "_" ];then
     song=$(mpc current)
     output="$song"
  else
    output="$artist • $song"
  fi

fi

sketchybar -m \
  --set mpd icon="$icon" \
  --set mpd label="$output"
