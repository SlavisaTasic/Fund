#!/bin/bash
# Raiffeisen Capital

while getopts b:e: option
do
        case "${option}"
        in
                b) BeginDate=${OPTARG};;
                e) EndDate=${OPTARG};;
        esac
done

if [ -z "$BeginDate" ]; then BeginDate='01.01.2013'; fi
if [ -z "$EndDate" ]
then
	EndDate=`date -I` # folder name
	To=`date +%d.%m.%Y` # date for URL
else
	To=`date +%d.%m.%Y --date="$EndDate"` # convert date for URL
fi

InstDir=$HOME/Fund/
Path=$InstDir/Prices/$EndDate/
URL='http://www.raiffeisen-capital.ru/common/funds/get.php?'

if [ ! -d $Path/r ]; then mkdir -p $Path/r; fi

curl \
	--url $URL'fund_id=1&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/01_RFSTCK.html' \
	--url $URL'fund_id=2&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/02_RFBOND.html' \
	--url $URL'fund_id=3&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/03_RFBLNC.html' \
	--url $URL'fund_id=4&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/04_RFUSA.html' \
	--url $URL'fund_id=5&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/05_RFCNSM.html' \
	--url $URL'fund_id=7&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/06_RFSRCS.html' \
	--url $URL'fund_id=9&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/07_RFIT.html' \
	--url $URL'fund_id=10&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/08_RFENRG.html' \
	--url $URL'fund_id=11&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/09_RFMMVB.html' \
	--url $URL'fund_id=12&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/10_RFINDS.html' \
	--url $URL'fund_id=21&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/11_RFASIA.html' \
	--url $URL'fund_id=22&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/12_RFBRIK.html' \
	--url $URL'fund_id=50&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/13_RFGOLD.html' \
	--url $URL'fund_id=70&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/14_RFTRSR.html' \
	--url $URL'fund_id=71&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/15_RFACT.html' \
	--url $URL'fund_id=110&BeginDate=01.01.2013&EndDate='$To \
	--output $Path'/r/16_RFEURO.html'
