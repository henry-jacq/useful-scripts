#!/bin/bash

# Author: Henry
# Description: A script to write your journals
# Created date: 01/01/2023

function timezone(){
    search=$1

    zoneinfo=/usr/share/zoneinfo/posix/
    tzlist=$(find -L $zoneinfo -type f -printf "%P\n")

    if [[ $search == "" ]]; then
        echo -e "Usage: $0 <Time-zone>"
        exit 1
    fi

    grep -i "$search" <<< "$tzlist" \
    | while read z
    do
        time=$(TZ=$z date +%X)
        day=$(TZ=$z date +%A)
        echo "${day} · ${time}\n"
    done
}



function main(){

    date=$(date +%D | tr '/' '-')
    filename="${date}.md"
    timezone=$(timezone kolkata)
    journal_dir="journals"

    if [[ ! -d ${journal_dir} ]]; then
        mkdir ${journal_dir}
    fi

    if [[ ! -f ${filename} ]]; then
        echo -e "-> Creating journal ${date}.md\n"
        touch ${journal_dir}/${filename}
        if [[ $? == 0 ]]; then
            echo -e "# ${date} · ${timezone}\n" > ${filename}
            echo -e "->  Start your journal...\n"
        fi
    else
        echo -e "-> Journal ${date}.md already exists.\n"
        echo -e "-> Start your journal...\n"
    fi
}

main "$@"