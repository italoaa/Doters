#!/usr/bin/env sh

echo "light\ndefault"| fzf --bind=tab:up,btab:down | xargs -I {} emacs --with-profile "{}"
