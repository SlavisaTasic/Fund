#!/bin/bash
# VTB Capital AM

# 01.01.2013
From='01.01.2013'
# current date
To='date +%d.%m.%Y'
Path=$HOME/Fund/Prices/`$To`/
URL='https://www.vtbcapital-am.ru/bitrix/components/articul/quotes/templates/.default/download.php?SHOWALL_1=1&'

if [ ! -d $Path/v ]; then mkdir -p $Path/v; fi

curl \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30147' \
	--output $Path'/v/01_VTBTRE.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30156' \
	--output $Path'/v/02_VTBEUR.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30150' \
	--output $Path'/v/03_VTBBLN.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30148' \
	--output $Path'/v/04_VTBSTK.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30149' \
	--output $Path'/v/05_VTBLTI.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30153' \
	--output $Path'/v/06_VTBMVB.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30161' \
	--output $Path'/v/07_VTBGD.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30155' \
	--output $Path'/v/08_VTBONG.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30152' \
	--output $Path'/v/09_VTBBPL.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30159' \
	--output $Path'/v/10_VTBCS.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30154' \
	--output $Path'/v/11_VTBGOS.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30160' \
	--output $Path'/v/12_VTBTLC.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30157' \
	--output $Path'/v/13_VTBENG.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30158' \
	--output $Path'/v/14_VTBMTL.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30151' \
	--output $Path'/v/15_VTBBRC.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30190' \
	--output $Path'/v/16_VTBMM.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30176' \
	--output $Path'/v/17_VTBPM.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30188' \
	--output $Path'/v/18_VTBPP.html' \
	--url $URL'from=01.01.2013&to=${To}&FOND_ID=30177' \
	--output $Path'/v/19_VTBKM.html' 
