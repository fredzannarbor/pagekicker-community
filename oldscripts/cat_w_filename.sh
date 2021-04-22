#!/bin/bash
for i in $* 
do
	echo $i
	echo "from file" $i >> oneliners.txt
	cat $i >>  oneliners.txt
done



