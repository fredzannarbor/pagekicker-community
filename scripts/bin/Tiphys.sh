#!/bin/bash


. ../conf/config.txt

echo "completed reading config file and  beginning logging at" `date +'%m/%d/%y%n %H:%M:%S'` | tee --append $tiphys_log

# . bin/authenticate_mendeley.py

# echo "ran authenticate"

echo "running Tiphys" | tee --append $tiphys_log

echo "working directory is" `pwd` | tee --append $tiphys_log

. flags.sh 

# . includes/api-manager.sh

# . ../includes/api-manager.sh

# 

. includes/Tiphys-search-by-keyword.py

# . includes/Tiphys-document-parser.sh


# . includes/Tiphys-keyword-search.sh
