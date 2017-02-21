#!/bin/bash
# Sberbank AM

# 01.01.2013
From='01.01.2013'
# current date
To='date +%d.%m.%Y'
Path=$HOME/Fund/Prices/`$To`/

if [ ! -d $Path/s ]; then mkdir -p $Path/s; fi

curl \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-obligatsiy-sberbank-fond-obligatsiy-ilya-muro/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/01_SBERIM.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-obligatsiy-sberbank-fond-riskovannykh-obligats/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/02_SBERRB.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-obligatsiy-sberbank-evroobligatsii/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/03_SBEREB.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-fond-aktsiy-dobrynya-nikitich/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/04_SBERDN.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-fond-aktsiy-kompaniy-maloy-ka/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/05_SBERPT.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-prirodnye-resursy/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/06_SBERMT.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-telekommunikatsii-i-tekhnolog/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/07_SBERTC.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-elektroenergetika/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/08_SBEREN.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-potrebitelskiy-sektor/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/09_SBERCS.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-finansovyy-sektor/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/10_SBERFS.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-fond-aktivnogo-upravleniya/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/11_SBERAM.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-aktsiy-sberbank-globalnyy-internet/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/12_SBERAM.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-smeshannykh-investitsiy-sberbank-fond-sbalans/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/13_SBERDR.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-fondov-sberbank-amerika/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/14_SBERFD.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-fondov-sberbank-razvivayushchiesya-rynki/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/15_SBEREM.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-fondov-sberbank-evropa/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/16_SBEREU.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-fondov-sberbank-globalnyy-dolgovoy-rynok/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/17_SBERDM.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-fondov-sberbank-zoloto/?ACTION=export&date_from=01.01.2013&date_to=${To}' \
	--output $Path'/s/18_SBERGD.xls' \
	--url 'https://www.sberbank-am.ru/individuals/fund/opif-fondov-sberbank-biotekhnologii/?ACTION=export&date_from=25.05.2015&date_to=${To}' \
	--output $Path'/s/19_SBERBT.xls' \
