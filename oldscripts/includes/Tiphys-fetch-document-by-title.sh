# convert special characters occurring in the seed to their unicode equivalents for submission as $safeseed inside search query URL

		safetitle=$(echo "$exacttitle" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/!/%21/g' -e 's/"/%22/g' -e 's/#/%23/g' -e 's/\$/%24/g' -e 's/\&/%26/g' -e 's/'\''/%27/g' -e 's/(/%28/g' -e 's/)/%29/g' -e 's/\*/%2a/g' -e 's/+/%2b/g' -e 's/,/%2c/g' -e 's/-/%2d/g' -e 's/\./%2e/g' -e 's/\//%2f/g' -e 's/:/%3a/g' -e 's/;/%3b/g' -e 's//%3e/g' -e 's/?/%3f/g' -e 's/@/%40/g' -e 's/\[/%5b/g' -e 's/\\/%5c/g' -e 's/\]/%5d/g' -e 's/\^/%5e/g' -e 's/_/%5f/g' -e 's/`/%60/g' -e 's/{/%7b/g' -e 's/|/%7c/g' -e 's/}/%7d/g' -e 's/~/%7e/g')

	curl --compressed --retry 2 --retry-delay 5 --retry-max 15 --connect-timeout 30 --max-time 60 --max-redirs 2 --junk-session-cookies -o tmp/tiphys/mendeley/$searchterm.json http://api.mendeley.com/oapi/documents/search/title:$safetitle"?consumer_key=13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6"

