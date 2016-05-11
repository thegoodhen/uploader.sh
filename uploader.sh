#!/bin/sh
#Written by thegoodhen as a file uploader script to be used manely with ranger fm

#Sources:http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

#dependencies:transfer.sh; curl; xclip



# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
verbose=0
zip=0
writeToFile=0
trimLines=0
clipboard=0
zipName="tempArchive.zip"

while getopts "zft:chn:" opt; do
    case "$opt" in
    h)  
        echo "usage: script -(zftc) files-to-upload; z=zip? n (name) archive name f=write links to temp file? t (lineNum)-limit max tempfile lines? c-copy links to clip"
        exit 0
        ;;
    z)
        zip=1
        ;;
    f)  writeToFile=1
        ;;
    t)  trimLines=$OPTARG
        ;;
    c)  clipboard=1
        ;;
    n) zipName=$OPTARG
        echo "$zipName"
        ;;
    esac
done

shift $((OPTIND-1))


## delete the whitespace or something (????)
if [ "$1" = "--" ]; then
    shift
fi

multipleFiles=0
if [ $# -gt 1 ]; then #multiple files   
    multipleFiles=1
fi

returnString=""
fileList=""

## DO STUFF HERE

SAVEIFS=$IFS
#set the separator to newline
IFS="
"

NL="
"
#fix extension (append if not present) (actually you can comment it out and it will still work, as "zip" is really smart :3)
zipName=$(echo "$zipName"|sed "s/\.zip//g")".zip"

echo "$zipName"
if [ $zip -eq 1 ] && [ $multipleFiles -eq 1 ]; then
        for i
        do
            echo "$i"
            fileList=$(echo "$fileList" \""$i"\")
        done
        echo $(echo "$zipName" "$fileList")
        eval "zip $(echo "$zipName" "$fileList")"
        returnString=$(curl --upload-file ./tempArchive.zip https://transfer.sh/archive.zip)
else
    for i
    do
        #a=$(echo $i|sed -n "s/\s/\\ /pIg")
        fileList=$(echo "$fileList" -F filedata=@\""$i"\")
    done
    fileList=$(echo "-i" "$fileList" https://transfer.sh)
    echo "$fileList"
    echo $fileList
    IFS=$SAVEIFS
    #returnString=$(curl  $(echo $fileList))
    returnString=$(eval "curl $(echo $fileList)")
fi

IFS=$SAVEIFS

#we have to grep the urls from the output now!
returnString=$(echo  "$returnString"|grep "^https://.*$")

if [ $clipboard -eq 1 ]; then
    echo "$returnString"|xclip -selection c
fi

if [ $writeToFile -eq 1 ]; then
    mkdir /tmp/uploader/
    echo "$returnString" "\n\n---------------------------------------------------" |cat - /tmp/uploader/fileList.txt > /tmp/uploader/temp.txt && mv /tmp/uploader/temp.txt /tmp/uploader/fileList.txt 
fi

if [ "$trimLines" != "0" ]; then
    head -n "$trimLines" /tmp/uploader/fileList.txt > /tmp/uploader/fileList.txt
fi


