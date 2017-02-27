#!/bin/bash
#Converting Sberbank PIFs prices HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in $HOME/Fund/Prices/`$CurrentDate`/s/*.html;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
	sed '/^.*<table border="1"><tr><td>/!d' "$i" > $Path/$NameWithoutExt".csv"; # all strings before last
	sed -i 's/^.*<table border="1"><tr><td>//g' $Path/$NameWithoutExt".csv"; # insert ,
	sed -i 's/<\/td><td>/,/g' $Path/$NameWithoutExt".csv"; # insert ,
	sed -i 's/<\/td><\/tr><tr><td align="left" valign="middle">/\
/g' $Path/$NameWithoutExt".csv"; # insert \n
	sed -i 's/<\/td><td align="right" valign="middle" style="mso-number-format:0\\.00">/,/g' $Path/$NameWithoutExt".csv"; # insert ,
	sed -i 's/<\/td><\/tr><\/table><\/body><\/html>//g' $Path/$NameWithoutExt".csv"; # all text in line after table
done
