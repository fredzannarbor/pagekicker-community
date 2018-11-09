cp $scriptpath"assets/rebuild.md"  "$TMPDIR$uuid/rebuild.md"
cp $confdir"jobprofiles/signatures/"$sigfile  "$TMPDIR$uuid/$sigfile"
echo "# Acknowledgements from  ""$imprintname" "Robot ""$editedby" >>  "$TMPDIR$uuid/robo_ack.md"
echo "I would like to thank ""$imprintname"" for the opportunity to write this book." >>  "$TMPDIR$uuid/robo_ack.md"
echo "  " >>  "$TMPDIR$uuid/robo_ack.md"
echo "  " >>  "$TMPDIR$uuid/robo_ack.md"
cat $scriptpath/assets/robo_ack.md >>  "$TMPDIR$uuid/robo_ack.md"
echo "This book was created with revision "$SFB_VERSION "on branch" `git rev-parse --abbrev-ref HEAD` "of the PageKicker software running on  the server $environment. " >>  "$TMPDIR$uuid/robo_ack.md"
echo "  " >>  "$TMPDIR"$uuid/robo_ack.md
echo "  " >>  "$TMPDIR"$uuid/robo_ack.md

# modify acknowledgments based on source -- should become case rather than if

# no active mod options

# complete building acknowledgments

echo "  " >>  "$TMPDIR$uuid/robo_ack.md"
echo "  " >>  "$TMPDIR$uuid/robo_ack.md"
echo '<i>'"$robot_location"'</i>' >>  "$TMPDIR$uuid/robo_ack.md"
echo "  " >>  "$TMPDIR$uuid/robo_ack.md"
echo "  " >>  "$TMPDIR$uuid/robo_ack.md"
echo '![Robot author photo]'"($sigfile)" >>  "$TMPDIR$uuid/robo_ack.md"
