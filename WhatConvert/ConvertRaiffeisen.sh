#!/bin/bash
#Converting Raiffeisen PIFs prices from HTML to CSV

CurrentDate='date -I'

for i in $HOME/Fund/Prices/`$CurrentDate`/r/*.html;
do
 	Path=$(dirname $i);
 	FullName=$(basename $i);
 	NameWithoutExt=$(echo "${FullName%%.*}");
 	grep -i -e '<content>' "$i" > $Path/$NameWithoutExt".csv";
 	sed -i 's/^.*<content>//g' $Path/$NameWithoutExt".csv";
 	sed -i 's/<\/content>//g' $Path/$NameWithoutExt".csv";
#	sed 's/(?<=\d)/\n/g' "$i" > $Path/$NameWithoutExt".csv";
 	awk -f $HOME/Fund/WhatConvert/command.awk $Path/$NameWithoutExt".csv" > $Path/$NameWithoutExt".tmp";
 	mv $Path/$NameWithoutExt".tmp" $Path/$NameWithoutExt".csv";
done

R --vanilla <<RSCRIPT

remove(list=ls())

GetFileList <- function(){
  Current.folder <- getwd()
  Folder <- paste('~/Fund/Prices/',
                  Sys.Date( ),
                  '/r',
                  sep='')
  setwd(Folder)
  List.of.files <- list.files(pattern = '*.csv', recursive = TRUE)
  for ( file in List.of.files){
    file.full <- paste('~/Fund/Prices/',
                       Sys.Date( ),
                       '/r/', file, sep='')
    GetQuotes(file.full)
  }
}

GetQuotes <- function(file.full){
  file.path <- dirname(file.full)
  # get $SYMBOL from file name
  file.name.without.ext <- tools::file_path_sans_ext(basename(file.full))
  file.symbol <- substring(file.name.without.ext, 4)
  # get list of quotes from file
  quotes.list <- read.csv(file.full, skip = 1, header = F)
  # get dates, prices and net asset values from list
  dates <- as.Date(quotes.list[[1]], format = '%d.%m.%Y') #make data format
  prices <- as.numeric(quotes.list[[2]]) # make numbers format (looks better?)
  NAV <- data.matrix(quotes.list[[3]])
  NAV <- as.numeric(NAV)
  # make symbol's character vector
  symbol <- rep(file.symbol, times=length(dates))
  # make dataframe
  quotes <- data.frame(symbol, dates, prices, NAV)
  # delete rows with NA
  quotes <- quotes[rowSums(is.na(quotes)) == 0,]
  quotes <- unique(quotes)
  write.table(quotes[order(-as.numeric(dates)),],
              file = paste(file.path,
                           '/',
                           file.symbol,
                           '.quote',
                           sep = ''),
              sep = ',',
              row.names = FALSE)
}

GetFileList()

RSCRIPT

