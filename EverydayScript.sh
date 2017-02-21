#!/bin/bash

$HOME/Fund/DownloadPrices.sh
$HOME/Fund/ConvertAll.sh
$HOME/Fund/R/Portfolio/GetMonthlyReturns.R
