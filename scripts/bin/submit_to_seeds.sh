#!/bin/bash

cd /opt/bitnami/apps/magento/htdocs/media/webforms/xml
files=(*) newest=${files[0]}
for f in "${files[@]}"; do
  if [[ $f -nt $newest ]]; then
    newest=$f
  fi
done

echo "found the newest file in xml , it is " $newest

submitted_seed=$(cat $newest | grep  '<field_38>' | sed "s/<field_38>//;s/<\/field_38>//")  
echo "submitted seed is " $submitted_seed

echo $submitted_seed > /opt/bitnami/apache2/htdocs/sfb/scripts/seeds/current-seeds

echo "wrote submitted_seed to replace  current-seed"

$scriptpath$SFBversion
 
cd $USER_HOME
exit
0
