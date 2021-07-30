#!/usr/bin/env bash

find /Users/italoamaya/.config -name "*.*" | fzf --bind=tab:up,btab:down | xargs -I {} alacritty "{}"
