#!/usr/bin/env bash

cat ./options.txt | fzf --bind=tab:up,btab:down | xargs -I {} echo "{}" 
