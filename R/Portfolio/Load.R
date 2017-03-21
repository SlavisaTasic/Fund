#!/usr/bin/Rscript

library(dplyr)
library(RPostgreSQL)
library(xts)
library(zoo)

# connects to PostgreSQL database "Securities"
ConnectToSecurities <- function(){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, dbname = "Securities",
                   host = "securities.cmcdafitdhnz.us-west-2.rds.amazonaws.com",
                   port = "5432", user = "master", password = "RDS.1DB.1SQL")
  return(con)
}

# loads list of symbols
LoadSymbols <- function(con){
  query <- "SELECT DISTINCT symbol FROM PIFs WHERE type='open-end' ORDER BY symbol"
  request <- dbSendQuery(con, query)
  df = fetch(request)
  return(df)
}


# loads one symbol's monthly returns from table "PIF_Monthly",
# saves it to XTS object
# (all monthes by default)
LoadOne <- function(con, smbl,
                      min.month = '1991-01-01', max.month = Sys.Date()){
  query <- paste("SELECT mnth, return FROM PIF_Monthly WHERE symbol='", smbl,
                 "' AND mnth BETWEEN '", min.month, "' AND '", max.month,
                 "' ORDER BY mnth",
                 sep = '')
  request <- dbSendQuery(con, query)
  df = fetch(request)
  one.xts <- xts(df$return, order.by = df$mnth)
  colnames(one.xts) <- smbl
  return(one.xts)
}

# takes list of symbols as parameter,
# loads one by one with function "LoadOne",
# merges them together to one XTS onject
LoadList <- function(con, list){
  for (string in list) {
    if ( !exists('list.xts') ) {
      list.xts <- LoadOne(con, string)
    } else {
      list.xts <- merge(list.xts, LoadOne(con, string))
    }
  }
  return(list.xts)
}

LoadFromDB <- function(tail){
  con <- ConnectToSecurities()
  symbols <- LoadSymbols(con)
  list.xts <- LoadList(con, symbols$symbol)
  list.xts <- tail(list.xts, tail)
  list.xts <- data.frame(list.xts)
  dbDisconnect(con)
  return(list.xts)
}
