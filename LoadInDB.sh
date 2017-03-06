#!/bin/bash

CurrentDate='date +%d.%m.%Y'

# psql \
# 	-h securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com \
# 	-p 5432 \
# 	-U master \
# 	-w \
# 	-d Securities \
# 	-c "DROP TABLE pif_quotes" \
# 	-c "CREATE TABLE pif_quotes (
# 			quote_id SERIAL,
# 			symbol	 varchar(6) REFERENCES PIFs,
# 			dt 	 	 date,
# 			price  	 NUMERIC(19, 2) CHECK (price > 0),
# 			NAV    	 NUMERIC(19, 2) CHECK (NAV > 0),
# 			UNIQUE (symbol, dt)
# 		);"

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
