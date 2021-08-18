
current=$(cat ~/Dot/alacritty/.config/alacritty/alacritty.yml | grep opa | awk '{print $2}')

if [[ $1 -eq -1 ]]
then
    echo 'afds'
fi

if [[ $1 -eq 1 ]]
then
    printf %.2f "$(($current))"
fi
