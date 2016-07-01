#!/usr/local/bin/python
###################################################
#PKsummarizer.py
#Inputs:
#1)input text file 
#2)uuid
#3)summary type (for now we'll just use # of lines as a proxy, in future, could 
#  be something like: short, long, proportional
#Outputs:
#1) summary of input text
#Attributes to add:
#1) use seed as input for query based summarization
# 
#######

import sys, os  
import summarize


#=================================================
def main():
	input_text = str(sys.argv[1])
	uuid_path = str(sys.argv[2])
	sum_lines = sys.argv[3]
	os.chdir(uuid_path)
	
	ss = summarize.SimpleSummarizer()
	with open(input_text) as tosumfile:
		input = tosumfile.read()
	
	summaried = ss.summarize(input, sum_lines)
	
	with open('sum_text.txt', "w+") as towritefile:
		towritefile.write(summaried)

    
#=================================================
if __name__ == '__main__':
    main()