#!/bin/bash
# add issuer, full_name, symbol

CurrentDate='date +%d.%m.%Y'

for i in $HOME/Fund/Prices/`$CurrentDate`/*/*.csv;
do
	Path=$(dirname $i);
	FullName=$(basename $i);
	Symbol=$(echo "${FullName%%.*}" | cut -c 4-);
	awk -v S="$Symbol" \
		'{print S,$1,$2,$3}' FS=, OFS=, F='NULL' $i > $Path/$Symbol".quote";
done