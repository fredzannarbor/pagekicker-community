#!/bin/bash
# usage  decimator.sh "$1" "$2"
echo $1
echo $2
bin/decimator.sh --pdfinfile "$1" --outdir scr --tldr "$2"
