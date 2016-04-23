#!/bin/bash

# search all PDFs in directory for patterns provided in text file

# assumes all PDFs are decrypted 

# default values

outdir="out`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1`"
csv="n"
pdforiginals="y"
reporttitle="Keyword Scan"
pdfdir="." # run file from within decrypted dir
singleseed="no" #default don't use
patternfile="patternfile"

# command line processing 


while :
do
case $1 in
--help | -\?)
echo "requires user to provide path to directory containing one or more txt files"
exit 0  # This is not an error, the user requested help, so do not exit status 1.
;;
--pdfdir)
pdfdir=$2
shift 2
;;
--pdfdir=*)
pdfdir=${1#*=}
shift
;;
--outdir)
outdir=$2
shift 2
;;
--outdir=*)
outdir=${1#*=}
shift
;;
--patternfile)
patternfile=$2
shift 2
;;
--patternfile=*)
patternfile=${1#*=}
shift
;;
--reporttitle)
reporttitle=$2
shift 2
;;
--reporttitle=*)
reporttitle=${1#*=}
shift 2
;;
--pdforiginals)
pdforiginals=$2
shift 2
;;
--pdforiginals=*)
pdforiginals=${1#*=}
shift
;;
--decrypt)
decrypt=$2
shift 2
;;
--decrypt=*)
decrypt=${1#*=}
shift
;;
--csv)
csv=$2
shift 2
;;
--csv=*)
csv=${1#*=}
shift
;;
--singleseed)
singleseed=$2
shift 2
;;
--singleseed=*)
singleseed=${1#*=}
shift
;;
--seedfile)
seedfile=$2
shift 2
;;
--seedfile=*)
seedfile=${1#*=}
shift
;;
  --) # End of all options
	    shift
	    break
	    ;;
	-*)
	    echo "WARN: Unknown option (ignored): $1" >&2
	    shift
	    ;;
	*)  # no more options. Stop while loop
	    break
	    ;;

esac
done

# Suppose some options are required. Check that we got them.

if [ ! "$pdfdir" ]; then
  echo "ERROR: option '--pdfdir[pdfdir]' not given. See --help" >&2
   exit 1
fi

if [ "$singleseed" = "no" ]; then

	echo "singleseed is not in use" 

else
	echo "singleseed is $singleseed"
	echo "$singleseed" > patternfile
fi

# file processing begins

mkdir -p -m 755 $outdir

while read pattern
do
	pattern_filename=`echo "$pattern"|tr -cd 'A-Za-z0-9_-'`
	echo -e \#  "$reporttitle" on "$pattern" > $outdir/"$pattern_filename"

done<"$patternfile"

for file in *.pdf
do

	# creating file name stamp

	convert \
	-colorspace RGB \
	-size 2550x3300 xc:transparent \
	-fill grey \
	-pointsize 96 \
	-gravity North \
	-annotate +0+50 "$file" \
	 $outdir/filestamp.pdf

	# looking for search term in each file

	echo "searching file $file in $pdfdir" 
	while read pattern
	do
		N=$((N+1))
		pattern_filename=`echo "$pattern"|tr -cd 'A-Za-z0-9_-'`
			if pdfgrep -q "$pattern" "$file" 2> /dev/null; then 
				echo -e "\n" >> $outdir/$pattern_filename
				echo -e '##' "$file" >> $outdir/$pattern_filename
				pdfgrep -n -C line "$pattern" "$file" 2> /dev/null | tee --append $outdir/$pattern_filename | echo $(cut -d: -f 1) | tr ' ' '\n' | uniq | tr '\n' ' ' > pagelist

				if [ "$pdforiginals" = "y" ] ; then
					pdftk "$pdfdir"/"$file" cat `cat pagelist` output $outdir/$N".orig."$pattern_filename".pdf"
					pdftk $outdir/$N".orig."$pattern_filename".pdf" multistamp $outdir/filestamp.pdf output $outdir/$N".stamped."$pattern_filename".pdf"
				else
					pass
				fi
				


				if [ "$csv" = "y" ] ; then
					pdfgrep -n -H -C line "$pattern" "$file" 2> /dev/null | tee --append $outdir/$pattern_filename".csv"
				else
					true
				fi
			fi
	echo "$file" >> "$outdir"/"$pattern_filename".files_searched.txt
	done<"$patternfile"
done

while read pattern
do

	pattern_filename=`echo "$pattern"|tr -cd 'A-Za-z0-9_-'`
	pdftk $outdir/*stamped.$pattern_filename.pdf cat output $outdir/$pattern_filename".pages.pdf"
	pattern_filename=`echo "$pattern"|tr -cd 'A-Za-z0-9_-'`
	sed 's/$/    /' $outdir/$pattern_filename > $outdir/$pattern_filename".md"
	pandoc --latex-engine=xelatex -o $outdir/$pattern_filename".references.pdf" $outdir/$pattern_filename".md"  
	pandoc -o $outdir/$pattern_filename".references.html" $outdir/$pattern_filename".md"
	echo "completed searching files for $pattern"	

done<"$patternfile"

echo "completed analysis of files in directory $pdfdir and stored results in $outdir"
exit 
0
