# add if logic for price rx rows

# if logic for readingstype

# search-based book

case $booktype on

Reader)

echo "booktype is" $booktype
readingstype=" Reader"

;;

Explorer)

readingstype=" Explorer"

;;

*)

readingstype=$booktype
;;

esac

echo "readingstype is " $readingstype | tee --append $sfb_log
