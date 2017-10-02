for file in "$TMPDIR$uuid/xtarget."*
do
		#"$PYTHON_BIN" $scriptpath"bin/nerv3.py" $file $file"_nouns.txt" "$uuid"
		cd "$NER_BIN" && java -mx600m -cp "*:lib/*" edu.stanford.nlp.ie.crf.CRFClassifier \
		 -loadClassifier classifiers/english.all.3class.distsim.crf.ser.gz -textFile "$file" \
		 -outputFormat tabbedEntities > "$file"_ner.tsv
		echo "ran NER on $file"
		cd "$scriptpath"

    # parse file


		#cat "$TMPDIR$uuid"/Places >> "$TMPDIR"$uuid"/"$sku"."$safe_product_name"_Places"
	  #cat "$TMPDIR$uuid"/People >>  "$TMPDIR"$uuid"/"$sku"."$safe_product_name"_People"
	  #cat "$TMPDIR$uuid"/Other >>  "$TMPDIR"$uuid"/"$sku"."$safe_product_name"_Other"

		echo -n "python_bin for running PKsum is" $PYTHON_BIN "and PYTHON_BIN actually is "
		"$PYTHON_BIN" --version

		"$PYTHON_BIN" bin/PKsum-clean.py -l "$summary_length" -o $file"_summary.txt" $file
		sed -i 's/ \+ / /g' $file"_summary.txt"
		cp $file"_summary.txt" $file"_pp_summary.txt"
		echo "ran summarizer on $file"
		awk 'length>=50' $file"_pp_summary.txt" >  "$TMPDIR"$uuid/awk.tmp && mv  "$TMPDIR"$uuid/awk.tmp $file"_pp_summary.txt"
		awk 'length<=4000' $file"_pp_summary.txt" >  "$TMPDIR"$uuid/awk.tmp && mv  "$TMPDIR"$uuid/awk.tmp $file"_pp_summary.txt"
		#echo "---end of summary section of 140K bytes---" >> $file"_pp_summary.txt"
		#echo "---end of summary section of 140K bytes---" >> $file"_summary.txt"
		cat $file"_pp_summary.txt" | awk '!x[$0]++' >>  "$TMPDIR"$uuid/pp_summary.txt
		cat $file"_summary.txt" | awk '!x[$0]++' >>  "$TMPDIR"$uuid/summary.txt
done
