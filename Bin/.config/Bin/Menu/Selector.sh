#!/bin/bash

echo "start"

case $1 in
    "Nvim")
        ;;
    "Execute")
        ../popup.sh fish
        ;;
    "Search")
        ;;
    "Launch")
        ../popup.sh ~/.config/Bin/launcher.sh

esac

echo "end"
