#!/bin/bash
#Converting VTB PIFs prices HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in ./Prices/`$CurrentDate`/v/*.xls;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
	ssconvert $i $NameWithoutExt".csv";
done


# for i in ./Prices/`$CurrentDate`/v/*.xls;
# do
# 	Path=$(dirname $i);
# 	FullName=$(basename $i);
# 	NameWithoutExt=$(echo "${FullName%%.*}");
# #	grep -i -e '</\?td\|</\?tr' "$i" > $NameWithoutExt".csv";
# 	sed '/<tr><th>Дата/,$!d' "$i" > $NameWithoutExt".csv";
# 	sed -i 's/^[ 	]*//g' $NameWithoutExt".csv"; # delete spaces and tabs; works
# 	tr -d '\n\r' < $NameWithoutExt".csv" > "$i.csv.temp" && mv "$i.csv.temp" $NameWithoutExt".csv"; # delete all newlines; works
# 	sed -i 's/,/;/g' $NameWithoutExt".csv"; # replace , with ; ;works
# 	sed -i 's/<tr><th>//g' $NameWithoutExt".csv"; # delete <tr><th> at the bebining of first string, works
# 	sed -i 's/<\/th><th>/,/g' $NameWithoutExt".csv"; # replace </th><th> witn , at first string, works
# 	sed -i 's/<\/th><\/tr><\/thead><tbody><tr>/\
# /g' $NameWithoutExt".csv"; # replace </th></tr></thead><tbody><tr> witn \n at first string, works
# 	sed -i 's/<\/td><\/tr><tr>/\
# /g' $NameWithoutExt".csv"; # make all strings, starting from the second, works
# 	sed -i 's/<td[^>]*>//g' $NameWithoutExt".csv"; # begin of strings with numbers; works
# 	sed -i 's/<\/td>/,/g' $NameWithoutExt".csv"; # replace </td> with , ;works
# 	sed -i 's/,<\/tr><\/tbody><\/table><\/body><\/html>//g' $NameWithoutExt".csv"; # delete ,</tr></tbody></table></body></html> at last string, works
# done
