#!/usr/bin/env sh

while read line;
      do echo "$line"
      # do //yt-dlp -x --audio-format mp3 -f 251 ytsearch1:"$line";
done; < $1
