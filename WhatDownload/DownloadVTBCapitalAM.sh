#!/bin/bash
# VTB Capital AM

# 01.01.2013
From='01.01.2013'
# current date
To='date +%d.%m.%Y'
Path=$HOME/Fund/Prices/`$To`/

if [ ! -d $Path/v ]; then mkdir -p $Path/v; fi

curl \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30147' \
	--output $Path'/v/01_VTBTRE.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30156' \
	--output $Path'/v/02_VTBEUR.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30150' \
	--output $Path'/v/03_VTBBLN.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30148' \
	--output $Path'/v/04_VTBSTK.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30149' \
	--output $Path'/v/05_VTBLTI.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30153' \
	--output $Path'/v/06_VTBMVB.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30161' \
	--output $Path'/v/07_VTBGD.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30155' \
	--output $Path'/v/08_VTBONG.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30152' \
	--output $Path'/v/09_VTBBPL.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30159' \
	--output $Path'/v/10_VTBCS.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30154' \
	--output $Path'/v/11_VTBGOS.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30160' \
	--output $Path'/v/12_VTBTLC.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30157' \
	--output $Path'/v/13_VTBENG.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30158' \
	--output $Path'/v/14_VTBMTL.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30151' \
	--output $Path'/v/15_VTBBRC.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30190' \
	--output $Path'/v/16_VTBMM.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30176' \
	--output $Path'/v/17_VTBPM.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30188' \
	--output $Path'/v/18_VTBPP.xls' \
	--url 'https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&from=01.01.2013&to=${To}&FOND_ID=30177' \
	--output $Path'/v/19_VTBKM.xls' 
