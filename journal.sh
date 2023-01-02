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

    date=$(date +%F)
    day_of_year=$(date +%j)
    filename="${date}.md"
    timezone=$(timezone kolkata)
    journal_dir="logs"

    if [[ ! -d ${journal_dir} ]]; then
        mkdir ${journal_dir}
    fi

    if [[ -f "${journal_dir}/${filename}" ]]; then
        echo -e "[!] Can't create new journal.\n"
        echo -e "[!] Journal ${date}.md already exists.\n"
        echo -e "-> Write your today's journal...\n"
        exit 1
    else
        echo -e "-> Creating journal ${date}.md\n"
        touch ${journal_dir}/${filename}
        if [[ $? == 0 ]]; then
            echo -e "# ${date} · ${timezone}" > ${journal_dir}/${filename}
            echo -e "# Day of year: ${day_of_year}\n" >> ${journal_dir}/${filename}
            echo -e "-> Start your journal now...\n"
        else
            echo -e "-> Can't create journal '${filename}'"
        fi
    fi
}

main "$@"
