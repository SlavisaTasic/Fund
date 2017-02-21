#!/usr/bin/Rscript

remove(list=ls())

require(xlsx)
require(xts)
require(quantmod)
require(zoo)

SberbankGetOne <- function(file){
  Data <- read.csv(file, skip=1, header=F)
  Dates <- as.Date(Data[[1]], format = '%d.%m.%Y') #make data format
  #	Prices <- data.matrix(Data[[2]]) # make matrix format
  Prices <- as.numeric(Data[[2]]) # make numbers format (looks better?)
  Returns <- xts(Prices, Dates) # make xts object
  Returns <- monthlyReturn(Returns) # compute monthy returns
  Returns <- to.monthly(Returns, OHLC=F) # make data format 'monthly'
  return( Returns )
}

SberbankGetReturns <- function(){
  Current.folder <- getwd()
  Path.to.folder <- paste('~/Fund/Prices/',
                          format(Sys.Date( ), format='%d.%m.%Y'),
                          '/s',
                          sep='')
  setwd(Path.to.folder)
  List.of.prices <- list.files(pattern = '*.csv')
  cat(List.of.prices)
  i <- 1
  for ( file in List.of.prices){
    if ( !exists('Returns') ){
      Returns <- SberbankGetOne(file)
      cat('done', i, 'of', length(List.of.prices), 'Sberbank\n')
      i <- i+1
    } else {
      Returns <- merge( Returns, SberbankGetOne(file) )
      cat('done', i, 'of', length(List.of.prices), 'Sberbank\n')
      i <- i+1
    }
    
  }
  setwd(Current.folder)
  # SberbankAMames <- read.csv('~/Fund/Names/Names_SberbankAM.csv', header=F)
  # SberbankAMames <- lapply(SberbankAMames, as.character)
  # colnames(Returns) <- SberbankAMames$V1
  colnames(Returns) <- c(1:length(Returns[1,]))
  # write.zoo(Returns, file='~/Fund/SberbankMonthly.returns.csv', sep=',')
  return( Returns )
}

VTBGetOne <- function(file, column, row){
  Data <- read.csv(file, skip=1, header=F)
  Dates <- as.Date(Data[[1]], format = '%d.%m.%Y') # make data format
  Prices <- data.matrix(Data[[2]]) # make matrix format
  Prices <- as.numeric(Prices) # make numbers format
  Returns <- xts(Prices, Dates) # make xts object
  Returns <- monthlyReturn(Returns) # compute monthy returns
  Returns <- to.monthly(Returns, OHLC=F) # make data format 'monthly'
  return( Returns )
}

VTBGetReturns <- function(){
  Current.folder <- getwd()
  Folder <- paste('~/Fund/Prices/',
                  format(Sys.Date( ), format='%d.%m.%Y'),
                  '/v',
                  sep='')
  setwd(Folder)
  List.of.prices <- list.files(pattern = '*.csv')
  i = 1
  for ( file in List.of.prices){
    if ( !exists('Returns') ){
      Returns <- VTBGetOne( file, 1, 2)
      cat('done', i, 'of', length(List.of.prices), 'VTB\n')
      i <- i+1
    } else {
      Returns <- merge( Returns, VTBGetOne( file, 1, 2) )
      cat('done', i, 'of', length(List.of.prices), 'VTB\n')
      i <- i+1
    }
  }
  setwd(Current.folder)
  VTBNames <- read.csv('~/Fund/Names/Names_VTB.csv', header=F)
  VTBNames <- lapply(VTBNames, as.character)
  colnames(Returns) <- VTBNames$V1
  # colnames(Returns) <- c(1:length(Returns[1,]))
  # write.zoo(Returns, file='~/Fund/VTBMonthly.returns.csv', sep=',')
  return( Returns )
}

RaiffeisenGetOne <- function(file){
  Data <- 	Data <- read.csv(file, skip=0, header=F)
  Dates <- data.matrix(Data[[1]])
  Dates <- as.Date(Dates, format = '%d.%m.%Y')
  Prices <- data.matrix(Data[[3]])
  Returns <- xts(Prices, Dates)
  Returns <- monthlyReturn(Returns) # compute monthy returns
  Returns <- to.monthly(Returns, OHLC=F) # make data format 'monthly'
  return( Returns )
}

RaiffeisenGetReturns <- function(){
  Current.folder <- getwd()
  Path.to.folder <- paste('~/Fund/Prices/',
                          format(Sys.Date( ), format='%d.%m.%Y'),
                          '/r',
                          sep='')
  setwd(Path.to.folder)
  List.of.prices <- list.files(pattern = '*.csv')
  i = 1
  for ( file in List.of.prices){
    if ( !exists('Returns') ){
      Returns <- RaiffeisenGetOne(file)
      cat('done', i, 'of', length(List.of.prices), 'Raiffeisen\n')
      i <- i+1
    } else {
      Returns <- merge( Returns, RaiffeisenGetOne(file) )
      cat('done', i, 'of', length(List.of.prices), 'Raiffeisen\n')
      i <- i+1
    }
  }
  setwd(Current.folder)
  Raiffeisen.names <- read.csv('~/Fund/Names/Names_RaiffeisenAM.csv', header=F)
  Raiffeisen.names <- lapply(Raiffeisen.names, as.character)
  colnames(Returns) <- Raiffeisen.names$V1
  # colnames(Returns) <- c(1:length(Returns[1,]))
  # write.zoo(Returns, file='~/Fund/RaiffeisenMonthly.returns.csv', sep=',')
  return( Returns )
}

AlfaGetOne <- function(file){
  Data <- read.xlsx(file,
                    sheetIndex=1,
                    colIndex=c(2,3),
                    startRow=3,
                    header=F)
  Dates <- data.matrix(Data[[1]])
  Dates <- as.Date(Dates, origin = '1899-12-30')
  Prices <- data.matrix(Data[[2]])
  Returns <- xts(Prices, Dates)
  Returns <- monthlyReturn(Returns) # compute monthy returns
  Returns <- to.monthly(Returns, OHLC=F) # make data format 'monthly'
  return( Returns )
}

AlfaGetReturns <- function(){
  Current.folder <- getwd()
  Path.to.folder <- paste('~/Fund/Prices/',
                          format(Sys.Date( ), format='%d.%m.%Y'),
                          '/a',
                          sep='')
  setwd(Path.to.folder)
  List.of.prices <- list.files(pattern = '*.xls')
  head(List.of.prices)
  i <- 1
  for ( file in List.of.prices){
    if ( !exists('Returns') ){
      Returns <- AlfaGetOne(file)
      cat('done', i, 'of', length(List.of.prices), 'Alfa\n')
      i <- i+1
    } else {
      Returns <- merge( Returns, AlfaGetOne(file) )
      cat('done', i, 'of', length(List.of.prices), 'Alfa\n')
      i <- i+1
    }
  }
  setwd(Current.folder)
  # AlfaNames <- read.csv('~/Fund/Names/Names_AlfaCapital.csv', header=F)
  # AlfaNames <- lapply(AlfaNames, as.character)
  # colnames(Returns) <- AlfaNames$V1
  colnames(Returns) <- c(1:length(Returns[1,]))
  # write.zoo(Returns, file='~/Fund/AlfaMonthly.returns.csv', sep=',')
  return( Returns )
}

GetReturns <- function(){
  Monthly.returns <- merge(AlfaGetReturns(),
                          RaiffeisenGetReturns(),
                          SberbankGetReturns(),
                          VTBGetReturns() )
  # Monthly.returns <- merge( VTBGetReturns(),
  #                          RaiffeisenGetReturns() )
  #	AssetList <- read.csv('~/Fund/data/AssetList 68.csv', header=F)
  #	AssetList <- lapply(AssetList, as.character)
  #    colnames(Monthly.returns) <- AssetList$V1
  return(Monthly.returns)
}

Returns <- GetReturns()

Path.to.file <- paste('~/Fund/Prices/',
                      format(Sys.Date( ), format='%d.%m.%Y'),
                      '/Returns.csv',
                      sep='')
write.zoo(tail(Returns, 38), file=Path.to.file, sep=',')
