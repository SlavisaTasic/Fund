#!/usr/bin/Rscript
# Converting VTB PIFs prices HTML to CSV

remove(list=ls())

library(XML)

GetFileList <- function(){
  Current.folder <- getwd()
  Folder <- paste('~/Fund/Prices/',
                  format(Sys.Date( ), format='%d.%m.%Y'),
                  '/v',
                  sep='')
  setwd(Folder)
  List.of.files <- list.files(pattern = '*.html', recursive = TRUE)
  for ( file in List.of.files){
    file.full <- paste('~/Fund/Prices/',
                       format(Sys.Date( ), format='%d.%m.%Y'),
                       '/v/', file, sep=''
    )
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
                               header = c("dt", "prices", "NAV"))
  # show(head(quotes.list[[1]][[2]], -10))
  # get dates, prices and net asset values from list
  dates <- as.Date(quotes.list[[1]][[1]], format = '%d.%m.%Y')
  prices <- data.matrix(quotes.list[[1]][[2]])
  prices <- as.numeric(sub(",", ".", prices, fixed = TRUE))
  NAV <- data.matrix(quotes.list[[1]][[3]])
  NAV <- as.numeric(sub(",", ".", NAV, fixed = TRUE))
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
