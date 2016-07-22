#pricing logic

if [[ "$wordcount" -lt "1000" ]] ; then

	price=0.99

elif [[ "$wordcount"  -lt "10000" ]] ; then

	price=1.99

elif [[ "$wordcount"  -lt "80000" ]] ; then

	price=2.99

elif [[ "$wordcount"  -lt "120000" ]] ; then

	price=3.99

elif [ "$wordcount"  -lt "250000" ] ; then

	price=4.99
else

	price=4.99

fi

