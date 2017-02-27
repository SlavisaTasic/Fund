#!/bin/bash
#Converting Raiffeisen PIFs prices from HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in $HOME/Fund/Prices/`$CurrentDate`/r/*.html;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
 	grep -i -e '<content>' "$i" > $Path/$NameWithoutExt".csv";
 	sed -i 's/^.*<content>//g' $Path/$NameWithoutExt".csv";
 	sed -i 's/<\/content>//g' $Path/$NameWithoutExt".csv";
#	sed 's/(?<=\d)/\n/g' "$i" > $Path/$NameWithoutExt".csv";
 	awk -f $HOME/Fund/WhatConvert/command.awk $Path/$NameWithoutExt".csv" > $Path/$NameWithoutExt".tmp";
 	mv $Path/$NameWithoutExt".tmp" $Path/$NameWithoutExt".csv";
done
