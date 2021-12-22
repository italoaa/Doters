# init 
export LANG=en_US.UTF-8
export LC_ALL=$LANG
# EXA CONFIG AND ALIASES

# wal -n -i ~/Personal/bkg/Fav/wallpaper.png -o ~/Personal/Programing/Scripts/wal_to_alacritty.sh

function fish_greeting
     pokemon-colorscripts -r
end

function tmux-sessionizer
    ~/.config/Bin/tmux/tmux-sessionizer
end

bind \cf tmux-sessionizer
 
set -g theme_color_scheme zenburn

balias showFunc 'echo "serve <port> , multi <Lhost>,<port>"'

set rockyou "~/Personal/CTF's/KaliLists/rockyou.txt"

function serve
         python -m SimpleHTTPServer $argv
end

function multi
         msfconsole -qx 'use multi/handler; set PAYLOAD generic/shell_reverse_tcp; set LHOST '$argv[1]'; set LPORT '$argv[2]';exploit'
end

balias tnmap 'nmap -sC -sV -oA nmap/initial'

# Yabai
balias ys 'brew services restart yabai'
balias sk 'brew services restart skhd'
balias sp 'brew services restart spacebar'
balias rem 'emacsclient -e "(kill-emacs)"; emacs --daemon'
balias kem 'emacsclient -e "(kill-emacs)"'
balias oem 'emacsclient -c'

balias o. "open ."
balias l "exa --group-directories-first"
balias la "exa --icons --group-directories-first --long --all --group --header --binary --links --inode --blocks"
balias ll "exa --icons --group-directories-first --long --all --group --header"
balias lg "exa --icons --group-directories-first --long --all --group --header --git"




balias cl "clear"
balias bp "bpython"
balias nvimconf "cd ~/.config/nvim; nvim"
balias r "ranger"
balias p "python"
balias p3 "python3"

## this is for faster config

balias confish "cd ~/.confg ; nvim ~/.config/fish/config.fish"
balias tmuxh "cat ~/tmux.txt"

# PATH #
## Vi mode ## 
fish_vi_key_bindings

# Setting PATH for Python 3.9
# The original version is saved in .zprofile.pysave
# set PATH "/Library/Frameworks/Python.framework/Versions/3.9/bin:$PATH"
