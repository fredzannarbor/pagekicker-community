#!/bin/bash
# python script tests
PYTHON_BIN="$1"
PYTHON27_BIN="$2"
echo -n "PYTHON_BIN version is " 
$PYTHON_BIN --version
echo -n "which PYTHON_BIN is " 
which $PYTHON_BIN
echo -n "PYTHON27_BIN version is " 
$PYTHON27_BIN --version
echo -n "which PYTHON27_BIN is " 
which $PYTHON27_BIN
echo ""
echo "running tests using " $PYTHON_BIN
echo ""

#working "$PYTHON_BIN" bin/wikifetcher.py --infile seeds/paella --outfile scr/test
"$PYTHON_BIN" bin/wiki_seeds_2_pages.py --infile "seeds/paella" --pagehits "scr/pagehits_py3"
"$PYTHON_BIN"  bin/PKsum.py -l "5" -o scr/sumtest ../test/tmpbody.md #not working right now
"$PYTHON_BIN"  bin/csvreader.py "../test/1001_1.csv" "1234" 1
"$PYTHON_BIN" bin/nerv3.py ../test/tmpbody.md scr/nervoutput 1234

if [ "$3" = "yes" ] ; then
echo ""
echo "running tests using " $PYTHON27_BIN
echo ""
"$PYTHON27_BIN" bin/wikifetcher.py --infile seeds/paella --outfile scr/test
"$PYTHON27_BIN" bin/wiki_seeds_2_pages.py --infile "seeds/paella" --pagehits "scr/pagehits_py2"
"$PYTHON27_BIN"  bin/PKsum.py -l "5" -o scr/sumtest ../test/tmpbody.md 
# working "$PYTHON27_BIN" bin/nerv3.py ../test/tmpbody.md scr/nervoutput 123
# working "$PYTHON27_BIN"  bin/csvreader.py "../test/1001_1.csv" "123" 1

else 

echo "not running tests using " $PYTHON27_BIN

fi
