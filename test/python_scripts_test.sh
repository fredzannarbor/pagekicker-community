# python script tests

python3 scripts/bin/wikifetcher.py --infile ../seeds/paella --outfile ../scr/test
python2.7 bin/PKsum.py -l "5" -o scr/sumtest ../test/tmpbody.md 
python3 bin/PKsum.py -l "5" -o scr/sumtest ../test/tmpbody.md #not working right now
python2.7 bin/nerv3.py ../test/tmpbody.md scr/nervoutput 123

