#!/usr/bin/Rscript

remove(list = ls())

source('Load.R')
source('Plotly.R')

con <- ConnectToSecurities()
symbols <- LoadSymbols(con)
all.xts <- LoadFromDB(12)
# p <- MakePlotply(symbols$symbol, all.xts[1:2]+1)
# show(p)

dbDisconnect(con)

R <- all.xts[1:2]
Names <- colnames(R)
target.return <- mean(mean.geometric(R))
print(target.return)

init <- portfolio.spec(assets = Names)
init <- add.constraint(portfolio = init, type = "full_investment")
init <- add.constraint(portfolio = init, type = "long_only")
# init <- add.constraint(portfolio = init, type = "return", return_target = target.return)
init <- add.objective(portfolio = init, type = "return", name = "mean",
                      return_target = target.return)
init <- add.objective(portfolio = init, type = "risk", name = "var")
opt <- optimize.portfolio(R = R, portfolio = init, optimize_method = "ROI")

Risk <- sqrt(t(opt$weights) %*% cov(R) %*% opt$weights)
Return <- opt$weights %*% colMeans(R)
print(c(Risk, Return))

# WReturns <- all.xts[1:2]
# meanReturns <- exp( colMeans( log(1 + WReturns) ) )^12-1 # geometric mean, cheak
# covMat <- var(WReturns)*12 # was cov, not var
#
# pspec <- portfolio.spec(assets=names(WReturns))
# pspec <- add.constraint(pspec, type="weight_sum", min_sum=0.99, max_sum=1.01)
# pspec <- add.constraint(pspec, type="box", min=0.0, max=1.0)
# pspec <- add.constraint(pspec, type = "return", name = "mean", return_target = 0.15)
# pspec <- add.objective(pspec, type="risk", name="var")
