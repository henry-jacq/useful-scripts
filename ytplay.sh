#!/bin/sh

# Author: Henry
# Date: Saturday 07 January 2023 10:36:31 PM IST
# Description: This script stream youtube videos in local media player (mpv)

mpv_lt="/usr/bin/mpv"
yt="https://www.youtube.com/"
query=$(printf '%s' "$*" | tr ' ' '+')
link=$(curl -s ${yt}results?search_query=${query} | grep -Eo "watch\?v=.{11}" | head -n 1)

if [[ $1 == "" ]]; then
        echo "Usage: $0 <video to play>"
        exit 1
fi
if [[ ! -f $mpv_lt ]]; then
        echo "Install 'mpv' to play yt videos"
        exit 1
fi

mpv ${yt}${link}
