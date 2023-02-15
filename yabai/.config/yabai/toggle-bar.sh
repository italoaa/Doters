disp=$(system_profiler SPDisplaysDataType | grep "Resolution" | wc -l)

baron="yabai -m config external_bar all:26:0"
baroff="yabai -m config external_bar off:26:0"

if [ 1 = $disp ]; then
	/usr/local/bin/trash ~/.config/yabai/yabairc
	cp ~/.config/yabai/yabaircbaroff ~/.config/yabai/yabairc
	brew services stop sketchybar
else
	/usr/local/bin/trash ~/.config/yabai/yabairc
	cp ~/.config/yabai/yabaircbaron ~/.config/yabai/yabairc
	brew services start sketchybar
fi

brew services restart yabai
