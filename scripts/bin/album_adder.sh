#!/bin/bash

echo $0 "adds pics to fb album"

filelist=$1
echo $filelist
filename=$(head -1 $filelist)
albumid=3383434980410523652
bookcredit="image from THE SHIP KILLERS vol. 9 by the late Joe Hinds"
bookurl="http://www.amazon.com/Definitive-Illustrated-History-Torpedo-Boat/dp/193484067X/"
photocaption="$bookcredit"" ""$bookurl"" filename is "$filename
echo $photocaption
fbcmd addpic "$filename" "$albumid" "$photocaption"
sed -i '1,1d' $filelist 
exit 0

