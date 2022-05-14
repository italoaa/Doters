#!/usr/bin/env bash
url="https://live.musopen.org:8085/streamvbr0?1652517990019"
pkill -f "https://live.musopen.org:8085/streamvbr0?" || mpv "https://live.musopen.org:8085/streamvbr0?"
