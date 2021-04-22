#!/bin/bash

if [ "$1" ]; then

  WORDLINE=$((($RANDOM * $RANDOM) % $(wc -l $1 | awk '{print $1}') + 1))"p"
  sed -n $WORDLINE $1

else
  echo "USAGE: random_line.sh $FILE"
fi

exit 0