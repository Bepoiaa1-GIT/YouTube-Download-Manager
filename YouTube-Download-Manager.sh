#!/bin/bash
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

start=${1:-"start"}
jumpto $start

start:
echo Created by Bepoiaa1
sleep 1
jumpto ytdl

# Ask for youtube-dl availability
ytdl:
read -n1 -p "Do you have youtube-dl installed? [Y,N]" YTDL
case $YTDL in  
  y|Y) jumpto con ;; 
  n|N) sudo apt-get install youtube-dl ;; 
  *) jumpto ytdl ;; 
esac

# Ask for URL
con:
echo
echo -n "Paste URL from video: ";
read 'URL';
# Ask for file name
echo -n "Enter file name: ";
read 'FN';
jumpto askfr

askfr:
# Ask for format
read -n1 -p "Which format you want to use? [A = Audio,V = Video]" ASKFRMT
case $ASKFRMT in
  a|A) jumpto YTD3 ;; 
  v|V) jumpto YTD4 ;; 
  *) jumpto askfr ;; 
esac

YTD4:
# Downloading via youtube-dl
echo
echo Prepering...
FORMAT=video
sleep 1
echo "Log:" 2>&1 
youtube-dl --output "/home/$USER/Videos/$FN.%(ext)s" $URL
echo Finished!
jumpto PDF

YTD3:
# Downloading via youtube-dl
echo
echo Prepering...
FORMAT=mp3
sleep 1
echo "Log:" 2>&1 
youtube-dl --extract-audio --audio-format mp3 --output "/home/$USER/Music/$FN.%(ext)s" $URL
echo Finished!
jumpto OD

OD:
# Open directory
case $FORMAT in
  video) xdg-open /home/$USER/Videos ;; 
  mp3) xdg-open /home/$USER/Music ;; 
esac
exit
