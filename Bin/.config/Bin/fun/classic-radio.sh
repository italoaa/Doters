#!/usr/bin/env bash
url="https://live.musopen.org:8085/streamvbr0?"
pkill -f $url || mpv $url
