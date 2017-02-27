#!/bin/bash
#Converting Alfa PIFs prices from XLS to CSV

CurrentDate='date +%d.%m.%Y'

for i in $HOME/Fund/Prices/`$CurrentDate`/a/*.xls;
do
	Path=$(dirname $i);
	FullName=$(basename $i);
	NameWithoutExt=$(echo "${FullName%%.*}");
	ssconvert $i $Path/$NameWithoutExt".csv";
	tail -n +2 $Path/$NameWithoutExt".csv" > $Path/$NameWithoutExt".tmp";
	mv $Path/$NameWithoutExt".tmp" $Path/$NameWithoutExt".csv";
done
