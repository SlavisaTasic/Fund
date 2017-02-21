#!/bin/bash
# Raiffeisen Capital

# 01.01.2013
From='01.01.2013'
# current date
To='date +%d.%m.%Y'
Path=$HOME/Fund/Prices/`$To`/

if [ ! -d $Path/r ]; then mkdir -p $Path/r; fi

curl \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=1&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/01_RFSTCK.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=2&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/02_RFBOND.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=3&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/03_RFBLNC.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=4&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/04_RFUSA.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=5&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/05_RFCNSM.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=7&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/06_RFSRCS.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=9&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/07_RFIT.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=10&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/08_RFENRG.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=11&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/09_RFMMVB.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=12&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/10_RFINDS.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=21&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/11_RFASIA.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=22&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/12_RFBRIK.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=50&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/13_RFGOLD.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=70&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/14_RFTRSR.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=71&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/15_RFACT.xls' \
	--url 'http://www.raiffeisen-capital.ru/common/funds/get.php?fund_id=110&BeginDate=01.01.2013&EndDate=${To}' \
	--output $Path'/r/16_RFEURO.xls'
