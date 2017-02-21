#!/bin/bash
# Alfa Capital

# 01.01.2013
From='01.01.2013'
# current date
To='date +%d.%m.%Y'
Path=$HOME/Fund/Prices/`$To`/

if [ ! -d $Path/a ]; then mkdir -p $Path/a; fi

curl \
	--url 'https://www.alfacapital.ru/individual/pifs/ipifa_akar/history-ipifa_akar.xls' \
	--output $Path'/a/01_ALFSGR.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/oipif_ak_mmvb/history-oipif_ak_mmvb.xls' \
	--output $Path'/a/02_ALFMVB.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opif_aks/history-opif_aks.xls' \
	--output $Path'/a/03_ALFBLN.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opif_akop/history-opif_akop.xls' \
	--output $Path'/a/04_ALFBPL.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opif_akr/history-opif_akr.xls' \
	--output $Path'/a/05_ALFRSR.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_akliq/history-opifa_akliq.xls' \
	--output $Path'/a/06_ALFLQS.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifo_akbond/history-opifo_akbond.xls' \
	--output $Path'/a/07_ALFEUR.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_akn/history-opifa_akn.xls' \
	--output $Path'/a/08_ALFRES.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_akps/history-opifa_akps.xls' \
	--output $Path'/a/09_ALRTRD.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_akt/history-opifa_akt.xls' \
	--output $Path'/a/10_ALFTCH.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_akf/history-opifa_akf.xls' \
	--output $Path'/a/11_ALFBRN.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_ake/history-opifa_ake.xls' \
	--output $Path'/a/12_ALFINF.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/opifa_akg/history-opifa_akg.xls' \
	--output $Path'/a/13_ALFGLD.xls' \
	--url 'https://www.alfacapital.ru/individual/pifs/ipifsi_ak/history-ipifsi_ak.xls' \
	--output $Path'/a/14_ALFCPT.xls'
