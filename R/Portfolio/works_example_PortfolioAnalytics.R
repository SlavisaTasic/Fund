#!/usr/bin/Rscript
# 20.02.2017 it works!

remove(list=ls())

library(PortfolioAnalytics)
data(edhec)
R <- edhec[, 1:4]
colnames(R) <- c("CA", "CTAG", "DS", "EM")
funds <- colnames(R)

init <- portfolio.spec(assets = funds)
init <- add.constraint(portfolio = init, type = "full_investment")
init <- add.constraint(portfolio = init, type = "long_only")
init <- add.constraint(portfolio = init, type = "return", return_target = 0.008)
init <- add.objective(portfolio = init, type = "risk", name = "var")
opt <- optimize.portfolio(R = R, portfolio = init, optimize_method = "ROI")

Risk <- sqrt(t(opt$weights) %*% cov(R) %*% opt$weights)
Return <- opt$weights %*% colMeans(R)
print(c(Risk, Return))

