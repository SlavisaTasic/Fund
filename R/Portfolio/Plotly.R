remove(list=ls())

library(PortfolioAnalytics)
library(quantmod)
library(PerformanceAnalytics)
library(zoo)
library(plotly)

library(ROI)
require(ROI.plugin.glpk)
require(ROI.plugin.quadprog)

# Get data
getSymbols(c("MSFT", "SBUX", "IBM", "AAPL", "^GSPC", "AMZN"))

# Get adjusted prices
prices.data <- merge.zoo(MSFT[,6], SBUX[,6], IBM[,6], AAPL[,6], GSPC[,6], AMZN[,6])

# Calculate returns
returns.data <- CalculateReturns(prices.data)
returns.data <- na.omit(returns.data)

# Set names
colnames(returns.data) <- c("MSFT", "SBUX", "IBM", "AAPL", "GSPC", "AMZN")

# Load data
returns.fund <- read.csv.zoo('~/Fund/Returns.csv', format='%b %Y')

# Save mean return vector and sample covariance matrix
meanReturns <- colMeans(returns.data)
covMat <- cov(returns.data)

# Start Portfolio with the names of the assets
port <- portfolio.spec(assets = c("MSFT", "SBUX", "IBM", "AAPL", "GSPC", "AMZN"))

# Box and Leverage
port <- add.constraint(port, type = "box", min = 0.00, max = 1.00)
port <- add.constraint(port, type = "full_investment")

# Generate random portfolios
rportfolios <- random_portfolios(port, permutations = 500, rp_method = "sample")

# Get minimum variance portfolio
minvar.port <- add.objective(port, type = "risk", name = "var")

# Optimize
minvar.opt <- optimize.portfolio(returns.data,
                                 minvar.port,
                                 optimize_method = "random", 
                                 rp = rportfolios)

# Generate maximum return portfolio
maxret.port <- add.objective(port, type = "return", name = "mean")

# Optimize
maxret.opt <- optimize.portfolio(returns.data,
                                 maxret.port,
                                 optimize_method = "random", 
                                 rp = rportfolios)

# Generate vector of returns
minret <- 0.06/100
maxret <- maxret.opt$weights %*% meanReturns
vec <- seq(minret, maxret, length.out = 100)
eff.frontier <- data.frame(Risk = rep(NA, length(vec)),
                           Return = rep(NA, length(vec)), 
                           SharpeRatio = rep(NA, length(vec)))
frontier.weights <- mat.or.vec(nr = length(vec), nc = ncol(returns.data))
colnames(frontier.weights) <- colnames(returns.data)
for (i in 1:length(vec)) {
  eff.port <- add.constraint(port, type = "return", name = "mean", return_target = vec[i])
  eff.port <- add.objective(eff.port, type = "risk", name = "var")
  # eff.port <- add.objective(eff.port, type = "weight_concentration", name = "HHI",
  #                            conc_aversion = 0.001)
  eff.port <- optimize.portfolio(returns.data, eff.port, optimize_method = "ROI")
  eff.frontier$Risk[i] <- sqrt(t(eff.port$weights) %*% covMat %*% eff.port$weights)
  eff.frontier$Return[i] <- eff.port$weights %*% meanReturns
  eff.frontier$SharpeRatio[i] <- eff.frontier$Return[i] / eff.frontier$Risk[i]
  frontier.weights[i,] = eff.port$weights
  print(paste(round(i/length(vec) * 100, 0), "% done..."))
}

FeasiblePortfolios <- data.frame(Risk = rep(NA, length(rportfolios)/6),
                                 Return = rep(NA, length(rportfolios)/6),
                                 SharpeRatio = rep(NA, length(rportfolios)/6) )

FeasiblePortfolios$Risk <- apply(rportfolios, 1, function(x){
  return(sqrt(matrix(x, nrow = 1) %*% covMat %*% matrix(x, ncol = 1)))
}
)
FeasiblePortfolios$Return <- apply(rportfolios, 1, function(x){
  return(x %*% meanReturns)
}
)
FeasiblePortfolios$SharpeRatio <- FeasiblePortfolios$Return/FeasiblePortfolios$Risk

p <- plot_ly(data = FeasiblePortfolios, x = ~Risk, y = ~Return,
             color = ~SharpeRatio,
             name = "Feasible Portfolios",
             mode = "markers", type = "scatter",
             showlegend = F,
             marker = list(size = 3, opacity = 0.5,
                           colorbar = list(title = "Sharpe Ratio") ),
             hoverinfo = 'text',
             text = ~paste('Feasible Portfolios',
                           '</br>St.dev: ', format(100*Risk, digits=2), '%',
                           '</br>Return: ', format(100*Return, digits=2), '%', #sep=''
                           '</br>Return: ', round(100*Return, 2), '%', sep='' )
) %>%
  
  add_trace(data = eff.frontier, x = ~Risk, y = ~Return,
            name = "Efficient Frontier",
            mode = "markers", type = "scatter",
            showlegend = F,
            marker = list(color = "#F7C873",
                          size = 2),
            hoverinfo = 'text',
            text = ~paste('Efficient Frontier',
                          '</br>St.dev: ', format(100*Risk, digits=2), '%',
                          '</br>Return: ', format(100*Return, digits=2), '%', #sep=''
                          '</br>Return: ', round(100*Return, 2), '%', sep='' )
  ) %>%
  
  layout(title = "Random Portfolios with Plotly",
         yaxis = list(title = "Mean Returns", showgrid = F, tickformat = ".2%"),
         xaxis = list(title = "Standard Deviation", showgrid = F, tickformat = ".1%")
         # annotations = list(list(x = 0.4, y = 0.75,
         #                         ax = -30, ay = -30,
         #                         text = "Efficient frontier",
         #                         font = list(color = "#F6E7C1",
         #                                     size = 15),
         #                         arrowcolor = "white")
         #                    )
  )
