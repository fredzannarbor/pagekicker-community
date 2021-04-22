#!/bin/bash

. ../../conf/config.txt

while read isbn
do
$LOCAL_MYSQL_PATH --user $LOCAL_MYSQL_USER --password=$LOCAL_MYSQL_PASSWORD sfb-jobs << EOF
insert into isbns (ISBN) values('$isbn');
EOF
echo "inserted ISBN" $isbn "into isbns table"
done<add_these_isbns
