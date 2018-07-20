# Customizing PageKicker

PageKicker accomplishes customization through a hierarchy of default values and configuration files.  All variables and configuration values are set to "sensible" defaults that can if desired be overridden.  The priority order is as follows.

The logic in builder.sh beginning

`if shopt -q login_shell
...
fi`

detects whether the user is a login shell or nonlogin shell and whether there is a valid configuration file associated with the current process user; if not it creates one from the default.  You may need to create a nonlogin shell config file if you are running the script from a daemon or cron job.

~/.pagekicker/config.txt sets global environment values and the top section of the file MUST BE CUSTOMIZED to provide accurate paths for your particular environment.

scripts/includes/set-variables.sh then reads in default values for all pagekicker-specific system variable and sets up some logging information. Log paths are specified in config.txt.

The values for config.txt and set-variables can then be overridden by command line parameters provided in the subsequent while : loop which is constructed without getopts (see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash).

Some command line parameters can specify values directly, such as --byline "Fred Zimmerman", --booktitle "Test Book", --coverfront "Arial", --imprintname "Nimble Books", and so on.

Some command line parameters specify text or binary files.  For example, --seedfile provides a list of "seeds" (key phrases) that the system will loop over to construct a book.

Alternately, some command line parameters can specify configuration files that set a variety of additional variables all at once.  The --jobprofile parameter specifies a "jobprofile" that corresponds to a single robot authorial personality.  The default set of jobprofiles are provided in conf/jobprofiles.  Subdirectories in jobprofiles/ contain various types of metadata pertaining to the robot author. The file in jobprofiles/robots/ are the "top level" and contain both variable values and pointers to other metadata files.

For example, here is default.jobprofile:

```
firstname=""
middlename=""
lastname="Phil73"
editedby=$firstname" "$middlename" "$lastname
authorbio=$SFB_HOME"conf/jobprofiles/authorbios/default.html"
fortunedb="literature"
LSI_import="no"
BISAC_code="none"
rows="99"
fetched_document_format="html"
mylibrary="yes"
sigfile="default.jpg"
add_imprint_biblio="no" #data too messy for right now
robot_location="Ann Arbor, Michigan, USA"
```

The authorbio variable points to an html file containing a brief description of the robot author "Phil 73."

```
This book was assembled with pride by PageKicker robot <b>Phil 73</b>.  Phil was born in the year 3019 of the Third Age and  lives in Hobbiton, the Shire.  His hobbies include rock climbing, listening to jazz, and tagging crowd-sourced images.<p>
```

Imprint files, stored in jobprofiles/imprints, contain basic info about each imprint, including the imprint's mission statement, copyright declaration, stylistic defaults (in .imprint), and logo.  The imprint can be specified at the command line via the --imprint parameter or in the jobprofile for the particular author.

```
rw-r--r--   1 fzimmerman  CORP\Domain Users  52360 May  1  2017 pklogo.png
-rw-r--r--   1 fzimmerman  CORP\Domain Users    132 May  1  2017 pkcopyrightpage.md
-rw-r--r--   1 fzimmerman  CORP\Domain Users    185 May  1  2017 pagekicker_mission.md
-rw-r--r--   1 fzimmerman  CORP\Domain Users    222 May  1  2017 pagekicker.imprint
drwxr-xr-x   7 fzimmerman  CORP\Domain Users    238 May  1  2017 .
```

Roadmap includes a "$publisher" variable with associated config files that would "own" multiple imprints.
