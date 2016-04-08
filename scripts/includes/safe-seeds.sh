	# 1) create escaped version of seed that can survive the Unix command line for passing from SFB.sh to Magento, etc.
	# to respond to Blackstone's Commentaries bug 182

	escapeseed=$(echo "$seed" | sed -e 's/"/_/g' -e 's/#/ /g'  -e 's/\&/ /g' -e 's/'\''/_/g'  -e 's/, /_/g' -e 's/,/_/g'  -e 's/\//_/g' -e 's// /g' -e 's/\\/ /g' -e 's/|/_/g')
	
	# 2) convert special characters occurring in the seed to their unicode equivalents for submission as $safeseed inside search query URL

	safeseed=$(echo "$seed" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/!/%21/g' -e 's/"/%22/g' -e 's/#/%23/g' -e 's/\$/%24/g' -e 's/\&/%26/g' -e 's/'\''/%27/g' -e 's/(/%28/g' -e 's/)/%29/g' -e 's/\*/%2a/g' -e 's/+/%2b/g' -e 's/,/%2c/g' -e 's/-/%2d/g' -e 's/\./%2e/g' -e 's/\//%2f/g' -e 's/:/%3a/g' -e 's/;/%3b/g' -e 's//%3e/g' -e 's/?/%3f/g' -e 's/@/%40/g' -e 's/\[/%5b/g' -e 's/\\/%5c/g' -e 's/\]/%5d/g' -e 's/\^/%5e/g' -e 's/_/%5f/g' -e 's/`/%60/g' -e 's/{/%7b/g' -e 's/|/%7c/g' -e 's/}/%7d/g' -e 's/~/%7e/g')
	
