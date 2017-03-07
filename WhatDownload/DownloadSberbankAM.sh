#!/bin/bash
# Sberbank AM

while getopts f:d: option
do
        case "${option}"
        in
                f) From=${OPTARG};; # f as First date
                d) To=${OPTARG};; # d as Last date
        esac
done

if [ -z "$From" ]; then From='01.01.2013'; fi
if [ -z "$To" ]; then To=`date +%d.%m.%Y`; fi

Path=$HOME/Fund/Prices/$To/
URL='https://www.sberbank-am.ru/individuals/fund/'

if [ ! -d $Path/s ]; then mkdir -p $Path/s; fi

curl \
	--url $URL'opif-obligatsiy-sberbank-fond-obligatsiy-ilya-muro/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/01_SBERIM.html' \
	--url $URL'opif-obligatsiy-sberbank-fond-riskovannykh-obligats/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/02_SBERRB.html' \
	--url $URL'opif-obligatsiy-sberbank-evroobligatsii/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/03_SBEREB.html' \
	--url $URL'opif-aktsiy-sberbank-fond-aktsiy-dobrynya-nikitich/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/04_SBERDN.html' \
	--url $URL'opif-aktsiy-sberbank-fond-aktsiy-kompaniy-maloy-ka/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/05_SBERPT.html' \
	--url $URL'opif-aktsiy-sberbank-prirodnye-resursy/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/06_SBERMT.html' \
	--url $URL'opif-aktsiy-sberbank-telekommunikatsii-i-tekhnolog/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/07_SBERTC.html' \
	--url $URL'opif-aktsiy-sberbank-elektroenergetika/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/08_SBEREN.html' \
	--url $URL'opif-aktsiy-sberbank-potrebitelskiy-sektor/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/09_SBERCS.html' \
	--url $URL'opif-aktsiy-sberbank-finansovyy-sektor/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/10_SBERFS.html' \
	--url $URL'opif-aktsiy-sberbank-fond-aktivnogo-upravleniya/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/11_SBERAM.html' \
	--url $URL'opif-aktsiy-sberbank-globalnyy-internet/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/12_SBERGI.html' \
	--url $URL'opif-smeshannykh-investitsiy-sberbank-fond-sbalans/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/13_SBERDR.html' \
	--url $URL'opif-fondov-sberbank-amerika/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/14_SBERFD.html' \
	--url $URL'opif-fondov-sberbank-razvivayushchiesya-rynki/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/15_SBEREM.html' \
	--url $URL'opif-fondov-sberbank-evropa/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/16_SBEREU.html' \
	--url $URL'opif-fondov-sberbank-globalnyy-dolgovoy-rynok/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/17_SBERDM.html' \
	--url $URL'opif-fondov-sberbank-zoloto/?ACTION=export&date_from=01.01.2013&date_to='$To \
	--output $Path'/s/18_SBERGD.html' \
	--url $URL'opif-fondov-sberbank-biotekhnologii/?ACTION=export&date_from=25.05.2015&date_to='$To \
	--output $Path'/s/19_SBERBT.html'
