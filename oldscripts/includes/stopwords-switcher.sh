#!/bin/bashv

# selecting stopfile 

if [ "$wikilang" = "en" ] ; then
	stopfile="$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
elif [ "$wikilang" = "sv" ] ; then
	stopfile="$scriptpath""locale/stopwords/sv"
elif [ "$wikilang" = "de" ] ; then
	stopfile="$scriptpath""locale/stopwords/de/stopwords-german.txt"
elif [ "$wikilang" = "fr" ] ; then
	stopfile="$scriptpath""locale/stopwords/fr/stopwords-french.txt"
else
	stopfile="$scriptpath""lib/IBMcloud/examples/pk-stopwords.txt"
fi

echo "we are using language-specific stopfile $stopfile"

if cmp -s "$stopfile $scriptpath/lib/IBMcloud/examples/pk-stopwords.txt" ; then
	echo "stopfiles are identical, no action"
else
	echo "Rotating selected stopfile into place"
	cp $stopfile "$scriptpath/lib/IBMcloud/examples/pk-stopwords.txt"
fi 

