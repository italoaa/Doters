#!/usr/bin/env sh


url=$1

curl $(echo $url | ggrep -Eo "stable/.*\?" | sed 's/stable/https:\/\/www.jstor.org\/citation\/text/') >> ~/Org/roam/references/Library.bib
