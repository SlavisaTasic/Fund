#!/bin/bash
#Converting Alfa PIFs prices from XLS to CSV

CurrentDate='date +%d.%m.%Y'

for i in ./Prices/`$CurrentDate`/a/*.xls;
do
	Path=$(dirname $i);
	FullName=$(basename $i);
	NameWithoutExt=$(echo "${FullName%%.*}");
	ssconvert $i $NameWithoutExt".csv";
	tail -n +2 $NameWithoutExt".csv" > $NameWithoutExt".tmp";
	mv $NameWithoutExt".tmp" $NameWithoutExt".csv";
done
