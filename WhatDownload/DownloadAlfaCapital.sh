#!/bin/bash
# Alfa Capital

while getopts f:t: option
do
        case "${option}"
        in
                f) From=${OPTARG};;
                l) To=${OPTARG};;
        esac
done

if [ -z "$From"]; then From='01.01.2013'; fi
if [-z "$To"]; then To='date +%d.%m.%Y'

Path=$HOME/Fund/Prices/`$To`/
URL='https://www.alfacapital.ru/individual/pifs/'

if [ ! -d $Path/a ]; then mkdir -p $Path/a; fi

curl \
	--url $URL'ipifa_akar/history-ipifa_akar.xls' \
	--output $Path'/a/01_ALFSGR.xls' \
	--url $URL'oipif_ak_mmvb/history-oipif_ak_mmvb.xls' \
	--output $Path'/a/02_ALFMVB.xls' \
	--url $URL'opif_aks/history-opif_aks.xls' \
	--output $Path'/a/03_ALFBLN.xls' \
	--url $URL'opif_akop/history-opif_akop.xls' \
	--output $Path'/a/04_ALFBPL.xls' \
	--url $URL'opif_akr/history-opif_akr.xls' \
	--output $Path'/a/05_ALFRSR.xls' \
	--url $URL'opifa_akliq/history-opifa_akliq.xls' \
	--output $Path'/a/06_ALFLQS.xls' \
	--url $URL'opifo_akbond/history-opifo_akbond.xls' \
	--output $Path'/a/07_ALFEUR.xls' \
	--url $URL'opifa_akn/history-opifa_akn.xls' \
	--output $Path'/a/08_ALFRES.xls' \
	--url $URL'opifa_akps/history-opifa_akps.xls' \
	--output $Path'/a/09_ALRTRD.xls' \
	--url $URL'opifa_akt/history-opifa_akt.xls' \
	--output $Path'/a/10_ALFTCH.xls' \
	--url $URL'opifa_akf/history-opifa_akf.xls' \
	--output $Path'/a/11_ALFBRN.xls' \
	--url $URL'opifa_ake/history-opifa_ake.xls' \
	--output $Path'/a/12_ALFINF.xls' \
	--url $URL'opifa_akg/history-opifa_akg.xls' \
	--output $Path'/a/13_ALFGLD.xls' \
	--url $URL'ipifsi_ak/history-ipifsi_ak.xls' \
	--output $Path'/a/14_ALFCPT.xls'
