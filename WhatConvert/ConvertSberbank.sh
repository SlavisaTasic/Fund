#!/usr/bin/Rscript
# Converting Sberbank PIFs prices HTML to CSV

remove(list=ls())

library(XML)

GetFileList <- function(){
  Current.folder <- getwd()
  Folder <- paste('~/Fund/Prices/',
                  format(Sys.Date( ), format='%d.%m.%Y'),
                  '/s',
                  sep='')
  setwd(Folder)
  List.of.files <- list.files(pattern = '*.html', recursive = TRUE)
  for ( file in List.of.files){
    file.full <- paste('~/Fund/Prices/',
                       format(Sys.Date( ), format='%d.%m.%Y'),
                       '/s/', file, sep='')
    GetQuotes(file.full)
  }
}

GetQuotes <- function(file.full){
  file.path <- dirname(file.full)
  # get $SYMBOL from file name
  file.name.without.ext <- tools::file_path_sans_ext(basename(file.full))
  file.symbol <- substring(file.name.without.ext, 4)
  # get list of quotes from file
  quotes.list <- readHTMLTable(file.full,
                               header = c("dt", "prices", "NAV"),
                               skip.rows = 1)
  # get dates, prices and net asset values from list
  dates <- as.Date(quotes.list[[1]][[1]], format = '%d.%m.%Y')
  prices <- data.matrix(quotes.list[[1]][[2]])
  prices <- as.numeric(prices)
  NAV <- data.matrix(quotes.list[[1]][[3]])
  NAV <- as.numeric(NAV)
  # make symbol's character vector
  symbol <- rep(file.symbol, times=length(dates))
  # make dataframe
  quotes <- data.frame(symbol, dates, prices, NAV)
  # delete rows with NA
  quotes <- quotes[rowSums(is.na(quotes)) == 0,]
  write.table(quotes,
              file = paste(file.path,
                           '/',
                           file.symbol,
                           '.quote',
                           sep = ''),
              sep = ',',
              row.names = FALSE)
}

GetFileList()
