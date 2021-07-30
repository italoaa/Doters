# init 
export LANG=en_US.UTF-8
export LC_ALL=$LANG
# EXA CONFIG AND ALIASES

function pywal
    # generate color scheme from current wallpaper
    set current_wallpaper "(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"
    wal -i $current_wallpaper -n
end

function tmux-sessionizer
    ~/.config/Bin/tmux/tmux-sessionizer
end

bind \cf tmux-sessionizer
 

set -g theme_color_scheme zenburn

# Ubersicht
balias uber "cd ~/Library/Application\ Support/Übersicht/widgets/"


# Yabai
balias ys 'brew services restart yabai'
balias sk 'brew services restart skhd'
balias sp 'brew services restart spacebar'

balias o. "open ."
balias l "exa --group-directories-first"
balias la "exa --group-directories-first --long --all --group --header --binary --links --inode --blocks"
balias ll "exa --group-directories-first --long --all --group --header"
balias lg "exa --group-directories-first --long --all --group --header --git"
balias lt "exa --group-directories-first --long --all --group --header -T"




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
