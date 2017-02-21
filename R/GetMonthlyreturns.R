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
     CurrentFolder <- getwd()
     setwd('~/Fund/Prices/s')
     ListOfPrices <- list.files(pattern = '*.csv')
     cat(ListOfPrices)
     i <- 1
     for ( file in ListOfPrices){
          if ( !exists('Returns') ){
               Returns <- SberbankGetOne(file)
               cat('done', i, 'of', length(ListOfPrices), 'Sberbank\n')
               i <- i+1
          } else {
               Returns <- merge( Returns, SberbankGetOne(file) )
               cat('done', i, 'of', length(ListOfPrices), 'Sberbank\n')
               i <- i+1
          }
          
     }
     setwd(CurrentFolder)
     # SberbankAMames <- read.csv('~/Fund/Names/Names_SberbankAM.csv', header=F)
     # SberbankAMames <- lapply(SberbankAMames, as.character)
     # colnames(Returns) <- SberbankAMames$V1
     colnames(Returns) <- c(1:length(Returns[1,]))
     # write.zoo(Returns, file='~/Fund/SberbankMonthlyReturns.csv', sep=',')
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
     CurrentFolder <- getwd()
     setwd('~/Fund/Prices/v')
     ListOfPrices <- list.files(pattern = '*.csv')
     i = 1
     for ( file in ListOfPrices){
          if ( !exists('Returns') ){
               Returns <- VTBGetOne( file, 1, 2)
               cat('done', i, 'of', length(ListOfPrices), 'VTB\n')
               i <- i+1
          } else {
               Returns <- merge( Returns, VTBGetOne( file, 1, 2) )
               cat('done', i, 'of', length(ListOfPrices), 'VTB\n')
               i <- i+1
          }
     }
     setwd(CurrentFolder)
     VTBNames <- read.csv('~/Fund/Names/Names_VTB.csv', header=F)
     VTBNames <- lapply(VTBNames, as.character)
     colnames(Returns) <- VTBNames$V1
     # colnames(Returns) <- c(1:length(Returns[1,]))
     # write.zoo(Returns, file='~/Fund/VTBMonthlyReturns.csv', sep=',')
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
     CurrentFolder <- getwd()
     setwd('~/Fund/Prices/r')
     ListOfPrices <- list.files(pattern = '*.csv')
     i = 1
     for ( file in ListOfPrices){
          if ( !exists('Returns') ){
               Returns <- RaiffeisenGetOne(file)
               cat('done', i, 'of', length(ListOfPrices), 'Raiffeisen\n')
               i <- i+1
          } else {
               Returns <- merge( Returns, RaiffeisenGetOne(file) )
               cat('done', i, 'of', length(ListOfPrices), 'Raiffeisen\n')
               i <- i+1
          }
     }
     setwd(CurrentFolder)
     RaiffeisenNames <- read.csv('~/Fund/Names/Names_RaiffeisenAM.csv', header=F)
     RaiffeisenNames <- lapply(RaiffeisenNames, as.character)
     colnames(Returns) <- RaiffeisenNames$V1
     # colnames(Returns) <- c(1:length(Returns[1,]))
     # write.zoo(Returns, file='~/Fund/RaiffeisenMonthlyReturns.csv', sep=',')
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
     CurrentFolder <- getwd()
     setwd('~/Fund/Prices/a')
     ListOfPrices <- list.files(pattern = '*.xls')
     i <- 1
     for ( file in ListOfPrices){
          if ( !exists('Returns') ){
               Returns <- AlfaGetOne(file)
               cat('done', i, 'of', length(ListOfPrices), 'Alfa\n')
               i <- i+1
          } else {
               Returns <- merge( Returns, AlfaGetOne(file) )
               cat('done', i, 'of', length(ListOfPrices), 'Alfa\n')
               i <- i+1
          }
     }
     setwd(CurrentFolder)
     # AlfaNames <- read.csv('~/Fund/Names/Names_AlfaCapital.csv', header=F)
     # AlfaNames <- lapply(AlfaNames, as.character)
     # colnames(Returns) <- AlfaNames$V1
     colnames(Returns) <- c(1:length(Returns[1,]))
     # write.zoo(Returns, file='~/Fund/AlfaMonthlyReturns.csv', sep=',')
     return( Returns )
}

GetReturns <- function(){
     # MonthlyReturns <- merge( AlfaGetReturns(),
     # RaiffeisenGetReturns(),
     # SberbankGetReturns(),
     # VTBGetReturns() )
     MonthlyReturns <- merge( VTBGetReturns(),
                              RaiffeisenGetReturns() )
     #	AssetList <- read.csv('~/Fund/data/AssetList 68.csv', header=F)
     #	AssetList <- lapply(AssetList, as.character)
     #    colnames(MonthlyReturns) <- AssetList$V1
     return( MonthlyReturns )
}

Returns <- GetReturns()

write.zoo(tail(Returns, 38), file='~/Fund/Returns.csv', sep=',')
