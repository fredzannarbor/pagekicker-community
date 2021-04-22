#!/bin/bash

rm out.txt
for file in *
do
/opt/bitnami/java/bin/java -jar /opt/bitnami/apache2/htdocs/pk-new/development/scripts/lib/CmdFlesh.jar $file  | sed -n '/Flesh-/p' >> out.txt
echo -n $file ","  >> out.txt
done

exit 0

