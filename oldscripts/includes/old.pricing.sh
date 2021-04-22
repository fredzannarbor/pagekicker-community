#pricing logic

# echo "doccount is" $doccount

echo "price is " $price
echo "doccount is "$doccount

if [ "$doccount" -lt 9 ] ; then

	price=0.99

elif [ $doccount  -lt 19 ] ; then

	price=0.99

elif [ $doccount  -lt 49 ] ; then

	price=2.99

elif [ $doccount  -lt 99 ] ; then

	price=4.99

elif [ $doccount  -lt 249 ] ; then

	price=4.99

elif [ $doccount  -lt 499 ] ; then

	price=4.99

else

	price=4.99

fi

