#!/usr/bin/Rscript
# Converting Alfa PIFs prices from XLS to CSV

remove(list=ls())

library(readxl)

GetFileList <- function(){
  Current.folder <- getwd()
  Folder <- paste('~/Fund/Prices/',
                  Sys.Date( ),
                  '/a',
                  sep='')
  setwd(Folder)
  List.of.files <- list.files(pattern = '*.xls', recursive = TRUE)
  for ( file in List.of.files){
    file.full <- paste('~/Fund/Prices/',
                       Sys.Date( ),
                       '/a/', file, sep='')
    GetQuotes(file.full)
  }
}

GetQuotes <- function(file.full){
  file.path <- dirname(file.full)
  # get $SYMBOL from file name
  file.name.without.ext <- tools::file_path_sans_ext(basename(file.full))
  file.symbol <- substring(file.name.without.ext, 4)
  # get list of quotes from file
  # I need to do this because of the crappy `DEFINEDNAME` output
  capture.output(quotes.list <- read_excel(file.full,
                                           sheet = 1,
                                           col_names = TRUE,
                                           skip = 1),
                 file = "/dev/null")
  dates <- as.Date(quotes.list[[1]])
  prices <- data.matrix(quotes.list[[2]])
  NAV <- data.matrix(quotes.list[[3]])
  NAV <- as.numeric(NAV)
  # make symbol's character vector
  symbol <- rep(file.symbol, times=length(dates))
  # make dataframe
  quotes <- data.frame(symbol, dates, prices, NAV)
  # delete rows with NA
  quotes <- quotes[rowSums(is.na(quotes)) == 0,]
  quotes <- unique(quotes)
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
