GETTING STARTED

1.  Make sure all dependencies are installed.
2.  Copy conf/config_template.txt to conf/config.txt and customize all values.
3. Run scripts/bin/setup.sh to create various directories that are needed.
4. Make sure that all API keys are stored in scripts/install/api-manager.sh. The Wikipedia key currently resides in scripts/. This should be changed in future.
5.  Modify the file scripts/seeds/current-seed to include several search terms that correspond to Wikipedia article titles.
6.  cd to $scriptpath and run the following test command:

 bin/create-catalog-entry.sh --builder "yes" --booktitle "Test" --yourname "Fred" --jobprofilename "Default" --sample_tweets "no" --import "no"  

It should create epub, mobi, and docx files and deposit them in $TMPDIR/pagekicker/$uuid.  that same folder contains all the interim work products.

You can run against any collection of seeds by creating a text file with one seed per line and adding the parameter --seedfile "/path/to/seedfile" to the command line above.

To begin contributing, look at the wiki Architecture and Roadmap docs, then look at issues list and pick something easy.  There are a number of fairly straightforward modifications that need to be made to bash or Python scripts. 
