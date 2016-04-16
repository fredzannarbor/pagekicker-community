#!/bin/bash

# renames files per PDF file name

# this script has not been heavily tested but is nondestructive, i.e. it only makes changes on copied files

# input: path to directory containing PDF files
# output: directory containing same files renamed with document title from PDF metadata

# relative path to PageKicker config file here (run from $scriptpath)

. ../conf/config.txt


while :
do
case $1 in
--help | -\?)
echo "requires directory name"
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
--renamed_files_dir)
renamed_files_dir=$2
shift 2
;;
--renamed_files_dir=*)
renamed_files_dir=${1#*=}
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
elif [ ! "$renamed_files_dir" ]; then
 	echo "ERROR: option '--renamed_files_dir[renamed_files_dir]' not given. See --help" >&2
  exit 1
else
	echo "proceeding"
fi

mkdir -m 755 "$renamed_files_dir"

cd "$pdfdir"
i=1
for file in *.pdf
	
do
	title=`pdftk $file dump_data output| sed -n '/InfoKey: Title/{n;p}'`
	echo "title is" $title
	cd "$scriptpath"
	if [ -z "$title" ]; then
		cp "$pdfdir"/"$file" "$renamed_files_dir"
	else
		safe_file_name=$(echo "$title" | cut -d":" -f2 | sed -e 's/[^A-Za-z0-9._-]/_/g' -e '1s/^.//' )
		j=$( printf "%04d" "$i" )
		cp "$pdfdir"/"$file" "$renamed_files_dir"/"$safe_file_name"-"$j".pdf
	fi
	(( i++ ))
	cd "$pdfdir"
done
cd $scriptpath
echo "renamed files in new directory $renamed_files_dir"
ls -lart "$renamed_files_dir"

