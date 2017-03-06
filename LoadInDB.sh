#!/bin/bash

CurrentDate='date +%d.%m.%Y'

for i in $HOME/Fund/Prices/`$CurrentDate`/*/*.quote;
do
	echo "$i"
  	psql \
	    -h securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com \
		-p 5432 \
		-U master \
		-w \
		-d Securities \
		-c "\copy pif_quotes(symbol, dt, price, NAV) FROM $i CSV HEADER"
done
