#!/usr/bin/env bash

find /System/Library/CoreServices /System/Applications /Applications /System/Applications/Utilities -maxdepth 1 -name "*.app" | fzf --bind=tab:up,btab:down | xargs -I {} open "{}"
