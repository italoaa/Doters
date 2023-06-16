mv ~/.config/yabai/yabairc ~/.config/yabai/yabaicp
mv ~/.config/yabai/yabaiToggle ~/.config/yabai/yabairc
mv ~/.config/yabai/yabaicp ~/.config/yabai/yabaiToggle
del yabaicp

yabai --restart-service
