#pricing logic

# echo "doccount is" $doccount

echo "price is " $price
echo "doccount is "$doccount

if [ "$wordcount" -lt 1000 ] ; then

	price=0.99

elif [ "$wordcount"  -lt 10000 ] ; then

	price=1.99

elif [ "$wordcount"  -lt 80000 ] ; then

	price=2.99

elif [ $doccount  -lt 120000 ] ; then

	price=3.99

elif [ $doccount  -lt 250000 ] ; then

	price=4.99
else

	price=9.99

fi

