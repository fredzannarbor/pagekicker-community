echo "singleseed is" ${FLAGS_singleseed}

searchterm=${FLAGS_singleseed}

# echo http://api.mendeley.com/oapi/documents/search/"$searchterm"?consumer_key=13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6

curl --compressed --retry 2 --retry-delay 5 --retry-max 15 --connect-timeout 30 --max-time 60 --max-redirs 2 --junk-session-cookies -o tmp/tiphys/mendeley/$searchterm.json http://api.mendeley.com/oapi/documents/search/"$searchterm"?consumer_key=13a47f20711f5d5ffe8e8f4db1df1daa04f8bd9b6

echo "ran Mendeley search" | tee --append $tiphys_log

# echo "arxiv search is" http://export.arxiv.org/api/query?search_query=all:"$searchterm"&start=0&max_results=${FLAGS_rows}

curl --compressed --retry 2 --retry-delay 5 --retry-max 15 --connect-timeout 30 --max-time 60 --max-redirs 2 --junk-session-cookies -o tmp/tiphys/arxiv/$searchterm http://export.arxiv.org/api/query?search_query=all:"$searchterm"&start=0&max_results=${FLAGS_rows}

echo "ran arxiv search" | tee --append $tiphys_log

# echo "plos search is " http://api.plos.org/search?q="$searchterm"&api_key=$plos_API_key

curl --compressed --retry 2 --retry-delay 5 --retry-max 15 --connect-timeout 30 --max-time 60 --max-redirs 2 --junk-session-cookies -o tmp/tiphys/plos/$searchterm  http://api.plos.org/search?q="$searchterm"&api_key={plos_API_key}

echo "ran PLOS search" | tee --append $tiphys_log
