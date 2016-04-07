#/bin/bash

echo "# programmatically generated parser syntax from list of variable names"
echo "while :"
echo "do"
echo "case \$1 in"
echo "--help | -\?)"
echo "# Call your help or usage function here"
echo "exit 0  # This is not an error, the user requested help, so do not exit status 1."
echo ";;"

while read line
do
	echo "--"$line")"
	echo $line"=\$2"
	echo "shift 2"
	echo ";;"
	echo "--"$line"=*)"
	echo $line='${1#*=}'
	echo "shift"
	echo ";;"
done <sorted_list

cat endsyntax

exit 0
