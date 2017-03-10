#!/bin/bash

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


for i in $InstDir/WhatConvert/*.sh;
do
	"$i"
done
