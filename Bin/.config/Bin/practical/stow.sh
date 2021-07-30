#!/bin/bash
topdir=.

find "$topdir" ! -path "$topdir" -prune -type d -exec sh -c '
    for dirpath do
        name=$(echo $dirpath | sed "s/.\///")
        cd $dirpath
        mkdir .config
        cd .config
        mkdir $name 
        cd ..
        find . -type f -print0 -exec mv {} .config/$name/ \;
    done' sh {} +
