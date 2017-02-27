#!/bin/bash
#Converting VTB PIFs prices HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in .$HOME/Fund/Prices/`$CurrentDate`/v/*.xls;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
#	grep -i -e '</\?td\|</\?tr' "$i" > $NameWithoutExt".csv";
 	sed '/<tr><th>Дата/,$!d' "$i" > $Path/$NameWithoutExt".csv";
 	sed -i 's/^[ 	]*//g' $Path/$NameWithoutExt".csv"; # delete spaces and tabs; works
 	tr -d '\n\r' < $Path/$NameWithoutExt".csv" > $Path/$NameWithoutExt".tmp"
 	mv $Path/$NameWithoutExt".tmp" $Path/$NameWithoutExt".csv"; # delete all newlines; works
 	sed -i 's/,/;/g' $Path/$NameWithoutExt".csv"; # replace , with ; ;works
 	sed -i 's/<tr><th>//g' $Path/$NameWithoutExt".csv"; # delete <tr><th> at the bebining of first string, works
 	sed -i 's/<\/th><th>/,/g' $Path/$NameWithoutExt".csv"; # replace </th><th> witn , at first string, works
 	sed -i 's/<\/th><\/tr><\/thead><tbody><tr>/\
/g' $Path/$NameWithoutExt".csv"; # replace </th></tr></thead><tbody><tr> witn \n at first string, works
 	sed -i 's/<\/td><\/tr><tr>/\
/g' $Path/$NameWithoutExt".csv"; # make all strings, starting from the second, works
 	sed -i 's/<td[^>]*>//g' $Path/$NameWithoutExt".csv"; # begin of strings with numbers; works
 	sed -i 's/<\/td>/,/g' $Path/$NameWithoutExt".csv"; # replace </td> with , ;works
 	sed -i 's/,<\/tr><\/tbody><\/table><\/body><\/html>//g' $Path/$NameWithoutExt".csv"; # delete ,</tr></tbody></table></body></html> at last string, works
done
