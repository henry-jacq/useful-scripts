#!/bin/bash

# Author: Henry
# Description: Show date and time in other time zones
# Created date: 02/01/2023

search=$1

format='%a %F %T'
zoneinfo=/usr/share/zoneinfo/posix/

tzlist=$(find -L $zoneinfo -type f -printf "%P\n")

if [[ $search == "" ]]; then
    echo -e "Usage: $0 <Time-zone>"
    exit 1
fi

grep -i "$search" <<< "$tzlist" \
| while read z
  do
      d=$(TZ=$z date +"$format")
      printf "%-30s %s\n" "$z" "$d"
done
