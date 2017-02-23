# returns tldr.txt & tldr.md
if [ -z "$tldr" ] ; then
	echo "no tldr supplied, generate automatically"
	echo "TL;DR: ""$tldr" > $TMPDIR$uuid/tldr.txt
  echo "  " > $TMPDIR$uuid/tldr.md
  echo "  " >> $TMPDIR$uuid/tldr.md
  echo "# TL;DR: ""$tldr" >> $TMPDIR$uuid/tldr.md
	sed -n 1p $TMPDIR$uuid/pp_summary_all.txt | cut -c 1-72 >> $TMPDIR$uuid/tldr.txt
  sed -n 1p $TMPDIR$uuid/pp_summary_all.txt | cut -c 1-72 >> $TMPDIR$uuid/tldr.md
	# 60 was not enough, 80 would be a full line, 72 is conventional
	echo "automatically generated tldr is $TMPDIR$uuid/tldr.txt"
  echo "..." >> $TMPDIR$uuid/tldr.txt
  echo "..." >> $TMPDIR$uuid/tldr.md
  echo "  " >> $TMPDIR$uuid/tldr.md
  echo "  " >> $TMPDIR$uuid/tldr.md

else
	echo "TL;DR: ""$tldr" > $TMPDIR$uuid/tldr.txt
  echo "  " > $TMPDIR$uuid/tldr.md
  echo "  " >> $TMPDIR$uuid/tldr.md
  echo "# TL;DR: ""$tldr" >> $TMPDIR$uuid/tldr.md
  echo "..." >> $TMPDIR$uuid/tldr.txt
  echo "..." >> $TMPDIR$uuid/tldr.md
  echo "  " >> $TMPDIR$uuid/tldr.md
  echo "  " >> $TMPDIR$uuid/tldr.md

fi
