#!/bin/bash

CurrentDate='date +%d.%m.%Y'

for i in ./Prices/`$CurrentDate`/s/*.csv;
do
	psql \
	    -h securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com \
		-p 5432 \
		-U master \
		-w \
		-d Securities \
		-c "SET datestyle = German;" \
		-c "\copy PIF(dt, price, net_asset_value) FROM '$i' DELIMITER ',' CSV HEADER"
done

 
