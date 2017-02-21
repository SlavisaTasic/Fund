#!/bin/bash
#Converting Sberbank PIFs prices HTML to CSV

CurrentDate='date +%d.%m.%Y'

for i in ./Prices/`$CurrentDate`/s/*.xls;
do
	Path=$(dirname $i);
	FullName=$(basename $i);
	NameWithoutExt=$(echo "${FullName%%.*}");
	ssconvert $i $NameWithoutExt".csv";
done
