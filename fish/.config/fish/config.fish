# init 
export LANG=en_US.UTF-8
export LC_ALL=$LANG
# EXA CONFIG AND ALIASES

set -g theme_color_scheme zenburn

# Trash
alias rm 'echo Use del or trash or /bin/rm'
alias del trash

# Yabai
alias ys 'yabai --restart-service'
alias sk 'skhd --restart-service'
alias sp speedtest

alias o. "open ."
alias l "~/.cargo/bin/exa --group-directories-first"
alias ls "~/.cargo/bin/exa --icons --group-directories-first --long --all"
alias la "~/.cargo/bin/exa --icons --group-directories-first --long --all --group --header --binary --links --inode --blocks"
alias ll "~/.cargo/bin/exa --icons --group-directories-first --long --all --group --header"
alias lg "~/.cargo/bin/exa --icons --group-directories-first --long --all --group --header --git"
alias cl clear

# PATH #
## Vi mode ## 
fish_vi_key_bindings

starship init fish | source
