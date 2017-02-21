#!/bin/bash
#Converting Raiffeisen PIFs prices from HTML to CSV

CurrentDate='date +%d.%m.%Y'


for i in ./Prices/`$CurrentDate`/r/*.xls;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
 	grep -i -e '<content>' "$i" > $NameWithoutExt".csv";
 	sed -i 's/^.*<content>//g' $NameWithoutExt".csv";
 	sed -i 's/<\/content>//g' $NameWithoutExt".csv";
#	sed 's/(?<=\d)/\n/g' "$i" > $NameWithoutExt".csv";
 	awk -f ./WhatConvert/command.awk $NameWithoutExt".csv" > $NameWithoutExt".csv2";
 	mv $NameWithoutExt".csv2" $NameWithoutExt".csv";
done
