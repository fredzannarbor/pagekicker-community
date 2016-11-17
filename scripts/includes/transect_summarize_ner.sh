for file in "$TMPDIR"$uuid"/xtarget."*
do

		"$PYTHON27_BIN" $scriptpath"bin/nerv3.py" $file $file"_nouns.txt" "$uuid"
		echo "ran nerv3 on $file" | tee --append $sfb_log
		cat "$TMPDIR$uuid"/Places >> "$TMPDIR"$batch_uuid"/"$sku"."$safe_product_name"_Places"
		cat "$TMPDIR$uuid"/People >>  "$TMPDIR"$batch_uuid"/"$sku"."$safe_product_name"_People"
		cat "$TMPDIR$uuid"/Other >>  "$TMPDIR"$batch_uuid"/"$sku"."$safe_product_name"_Other"

		echo "python_bin for running PKsum is" $PYTHON_BIN "and PYTHON_BIN actually is"
		"$PYTHON_BIN" --version

		"$PYTHON_BIN" bin/PKsum.py -l "$summary_length" -o $file"_summary.txt" $file
		sed -i 's/ \+ / /g' $file"_summary.txt"
		cp $file"_summary.txt" $file"_pp_summary.txt"
		echo "ran summarizer on $file" | tee --append $sfb_log
		awk 'length>=50' $file"_pp_summary.txt" >  "$TMPDIR"$uuid/awk.tmp && mv  "$TMPDIR"$uuid/awk.tmp $file"_pp_summary.txt"
		awk 'length<=4000' $file"_pp_summary.txt" >  "$TMPDIR"$uuid/awk.tmp && mv  "$TMPDIR"$uuid/awk.tmp $file"_pp_summary.txt"
		#echo "---end of summary section of 140K bytes---" >> $file"_pp_summary.txt"
		#echo "---end of summary section of 140K bytes---" >> $file"_summary.txt"
		cat $file"_pp_summary.txt" >>  "$TMPDIR"$uuid/pp_summary.txt
		cat $file"_summary.txt" >>  "$TMPDIR"$uuid/summary.txt
done
