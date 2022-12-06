#!/usr/bin/env sh

PERCENTAGE=$(pmset -g batt | ggrep -Eo "%" | cut -d% -f1 | awk '{print $3}')
CHARGING=$(pmset -g batt | ggrep 'AC Power')

if [[ $PERCENTAGE = "" ]]; then
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ $CHARGING != "" ]]; then
  ICON=""
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
