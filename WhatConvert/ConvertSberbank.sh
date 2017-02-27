#!/bin/bash
#Converting Sberbank PIFs prices HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in $HOME/Fund/Prices/`$CurrentDate`/s/*.xls;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
 	echo $Path/$NameWithoutExt".csv"
		sed '/^.*<table border="1"><tr><td>/!d' "$i" | \ # all strings before last
		sed 's/^.*<table border="1"><tr><td>//g' | \ # insert ,
		sed 's/<\/td><td>/,/g' | \ # insert ,
		sed 's/<\/td><\/tr><tr><td align="left" valign="middle">/\
/g' | \ # insert \n
		sed 's/<\/td><td align="right" valign="middle" style="mso-number-format:0\\.00">/,/g' | \ # insert ,
		sed 's/<\/td><\/tr><\/table><\/body><\/html>//g' $Path/$NameWithoutExt".csv"; # all text in line after table
done
