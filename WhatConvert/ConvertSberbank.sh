#!/bin/bash
#Converting Sberbank PIFs prices HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in ./Prices/`$CurrentDate`/s/*.xls;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
 	echo $Path/$NameWithoutExt
#  	sed '/^.*<table border="1"><tr><td>/!d' "$i" > $NameWithoutExt".csv"; # all strings before last
#  	sed -i 's/^.*<table border="1"><tr><td>//g' $NameWithoutExt".csv"; # insert ,
#  	sed -i 's/<\/td><td>/,/g' $NameWithoutExt".csv"; # insert ,
#  	sed -i 's/<\/td><\/tr><tr><td align="left" valign="middle">/\
# /g' $NameWithoutExt".csv"; # insert \n
#  	sed -i 's/<\/td><td align="right" valign="middle" style="mso-number-format:0\\.00">/,/g' $NameWithoutExt".csv"; # insert ,
#  	sed -i 's/<\/td><\/tr><\/table><\/body><\/html>//g' $NameWithoutExt".csv"; # all text in line after table
done
