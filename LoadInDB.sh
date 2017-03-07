#!/bin/bash

while getopts d: option
do
        case "${option}"
        in
                d) Date=${OPTARG};; # d as Date
        esac
done

if [ -z "$Date" ]; then Date=`date +%d.%m.%Y`; fi

for i in $HOME/Fund/Prices/$Date/*/*.quote;
do
	echo "$i"
  	psql \
	    -h securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com \
		-p 5432 \
		-U master \
		-w \
		-d Securities \
		-c "CREATE TEMP TABLE tmp (
				symbol	 varchar(6),
				dt 	 	 date,
				price  	 NUMERIC(19, 2),
				NAV    	 NUMERIC(19, 2)
			)" \
		-c "\copy tmp (symbol, dt, price, NAV) FROM $i CSV HEADER" \
		-c "INSERT INTO PIF_quotes (symbol, dt, price, NAV)
			SELECT *
			  FROM tmp
			    ON CONFLICT DO NOTHING" \
		-c "DROP TABLE tmp"
done
