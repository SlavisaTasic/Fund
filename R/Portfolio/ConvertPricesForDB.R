remove(list=ls())

library(XML)

GetFileList <- function(){
  Current.folder <- getwd()
  Folder <- paste('~/Fund/Prices/',
                  format(Sys.Date( ), format='%d.%m.%Y'),
                  # '/v',
                  sep='')
  setwd(Folder)
  List.of.files <- list.files(pattern = '*.xls',
                              recursive = TRUE)
  for ( file in List.of.files){
    file.full <- paste('~/Fund/Prices/',
                       format(Sys.Date( ), format='%d.%m.%Y'),
                       '/', file, sep=''
                       )
    # print(file.full)
    GetQuotes(file.full)
  }
}

GetQuotes <- function(file.full){
  # file.full <- '~/Fund/Prices/23.02.2017/s/01_SBERIM.xls'
  # get $LastChar from file path
  file.path <- dirname(file.full)
  last.char.in.path <- substr(file.path, nchar(file.path), nchar(file.path))
  # get $SYMBOL from file name
  file.name.without.ext <- tools::file_path_sans_ext(basename(file.full))
  file.symbol <- substring(file.name.without.ext, 4)
  
  if (last.char.in.path == 'ss') {
    # get list of quotes from file
    quotes.list <- readHTMLTable(file.full,
                                 header = c("dt", "prices", "NAV"))
    quotes <- GetQuotesFromFile(file.full, quotes.list,
                      dt.column=1, prices.column=2, NAV.column=3)
    SaveQuotes(quotes, file.path, file.symbol)
  }
  if (last.char.in.path == 'vv') {
    # get list of quotes from file
    quotes.list <- readHTMLTable(file.full, 
                                 header = c("dt", "prices", "NAV"))
    quotes <- GetQuotesFromFile(file.full, quotes.list,
                      dt.column=1, prices.column=2, NAV.column=3)
    SaveQuotes(quotes, file.path, file.symbol)
    show(head(quotes))
  }
  if (last.char.in.path == 'r') {
    # get list of quotes from file
    quotes.list <- readHTMLTable(file.full, 
                                 header = c("dt", "prices", "NAV"))
    show(quotes.list)
    # quotes <- GetQuotesFromFile(file.full, quotes.list,
    #                             dt.column=1, prices.column=2, NAV.column=3)
    # SaveQuotes(quotes, file.path, file.symbol)
    # show(head(quotes))
  }
  
}
GetQuotesFromFile <- function(file.full, quotes.list,
                              dt.column, prices.column, NAV.column){
  # get $SYMBOL from file name
  file.name.without.ext <- tools::file_path_sans_ext(basename(file.full))
  file.symbol <- substring(file.name.without.ext, 4)
  # get dates, prices and net asset values from list
  dates <- as.Date(quotes.list[[1]][[dt.column]], format = '%d.%m.%Y')
  prices <- data.matrix(quotes.list[[1]][[prices.column]])
  prices <- as.numeric(prices)
  NAV <- data.matrix(quotes.list[[1]][[NAV.column]])
  NAV <- as.numeric(NAV)
  # make symbol's character vector
  symbol <- rep(file.symbol, times=length(dates))
  # constract dataframe
  quotes <- data.frame(symbol, dates, prices, NAV)
  return(quotes)
}

# save quotes to file ~/Fund/Prices/$Cyrrentdate/{a,r,s,v}/$SYMBOL.quotes
SaveQuotes <- function(quotes, file.path, file.symbol){
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
# file.full <- '~/Fund/Prices/23.02.2017/s/01_SBERIM.xls'
# file.path <- dirname(file.full)
# file.name.without.ext <- tools::file_path_sans_ext(basename(file.full))
# file.symbol <- substring(file.name.without.ext, 4)
# quotes.list <- readHTMLTable(file.full,
#                              header = c("dt", "prices", "NAV"),
#                              col.names = c("dt", "prices", "NAV"),
#                              skip.rows = 1)
# dates <- as.Date(quotes.list[[1]][[1]], format = '%d.%m.%Y')
# show(head(dates))
