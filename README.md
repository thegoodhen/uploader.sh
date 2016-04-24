# uploader.sh

A simple .sh script for uploading files to transfer.sh

This script is intended to simplify the workflow whenever the need arises to share multiple files quickly. A standard approach would be to
select them, right click -> compress, then select the zip, open a file sharing site or ftp client or similar, copy the link to the clipboard, paste...

This involves a lot of mouse usage and the process is tedious.

Furthermore, drag'n' drop cannot be utilized from console applications, such as the RANGER file manager. 
This makes it hard to share files over Skype or Facebook with your collegues from within ranger.

This little script aims to make such sharing not only possible, but easier than with aforementioned standard methods.

## Dependencies

This script relies on the transfer.sh service and the website of the same name. It also makes use of console applications listed below:

- xclip
- zip
- curl

Those applications need to be installed using sudo apt-get install app in order for this script to work.

## Usage

Script should be copied somewhere where your shell can find it, such as /usr/bin and set as executable using chmod. See man chmod for more info.

call uploader.sh [-zfcth] filename1 filename2...

- z: zip files? - create a zip file from the given files before uploading? Option is ignored if only one file is passed to this script
- f: write to file? - whether the links to the files uploaded should be appended to the top of file located under /tmp/uploader/fileList.txt
- c: clipboard? whether the links should be copied to a clipboard
- t [number]: trim the /tmp/uploader/fileList.txt file to the last [number] lines.

Please note that when neither -f or -c option is selected, the links are lost and it makes no sense to call this script with both of these options missing.



## Usage from within Ranger.fm

Add the following lines to your /home/username/.config/ranger/rc.conf to make this script work from within Ranger fm:

- map \uz shell uploader.sh -cfz %%s
- map \us shell uploader.sh -cf %%s
- map \uv shell vim /tmp/uploader/fileList.txt

The first one maps \uz to "upload selected as zip, copy link to clipboard"
Second one maps \us to "upload files separately, copy links as separate lines to clipboard"
And finally the third one effectively means "view history of uploaded files, in newest-top order"

## Known limitations:

- No support for spaces in filenames yet. I have to fix this soon.
- The format of the list of uploaded files should be changed to allow for easier copying using Vim.
- I need to handle the situation when no input arguments are present.

## Warranty

No warranty is implied, and I am not responsible for anything at all. 




