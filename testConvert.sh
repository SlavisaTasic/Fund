#!/bin/bash

cat $1 | \
 grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' | \
 sed 's/^[\ \t]*//g' | \
 tr -d '\n' | \
 sed 's/<\/TR[^>]*>/\n/Ig'  | \
 sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' | \
 sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' | \
 sed 's/<\/T[DH][^>]*><T[DH][^>]*>/,/Ig'
