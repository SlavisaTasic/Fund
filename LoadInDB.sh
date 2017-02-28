#!/bin/bash

CurrentDate='date +%d.%m.%Y'

for i in $Home/Fund/Prices/`$CurrentDate`/*/*.quote;
do
	psql \
	    -h securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com \
		-p 5432 \
		-U master \
		-w \
		-d Securities \
		-c "\copy pif_quotes(symbol, dt, price, NAV) FROM $i CSV HEADER"
		
done


# 		CREATE TEMP TABLE tmp_x (id int, apple text, banana text); -- but see below
# 		COPY tmp_x FROM '/absolute/path/to/file' (FORMAT csv);
# 		UPDATE tbl
# 		SET    banana = tmp_x.banana
# 		FROM   tmp_x
# 		WHERE  tbl.id = tmp_x.id;
# 		DROP TABLE tmp_x; -- else it is dropped at end of session automatically
# 
# 		-c "SET datestyle = German;" \
# 		-c "\copy PIF(dt, price, net_asset_value) FROM '$i' CSV HEADER"


#psql_exit_status = $?

#if [ $psql_exit_status != 0 ]; then
#    echo "psql failed while trying to run this sql script" 1>&2
#    exit $psql_exit_status
#fi

#echo "sql script successful"
#exit 0

