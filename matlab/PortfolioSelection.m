clc
clear

P = readtable('~/Downloads/Fund/16.01.2017/Names.csv', 'FileEncoding', 'UTF-8');
%%% Date 16.01.2017  16.01.2017  16.01.2017  16.01.2017  
%%% CurrentPrice = [ 11.61; 23.28; 20.01; 31980.38 ];
Blotter = dataset({P.Price, 'InitPrice'}, {P.CurrentPrice, 'CurrentPrice'},...
          {P.Shares, 'Shares'},'obsnames',P.Name);
InitWealth = sum(Blotter.InitPrice .* Blotter.Shares);
CurrentWealth = sum(Blotter.CurrentPrice .* Blotter.Shares);
Blotter.InitPort = (1/InitWealth)*(Blotter.InitPrice .* Blotter.Shares);
Blotter.CurrentPort = (1/CurrentWealth)*(Blotter.CurrentPrice .* Blotter.Shares);
% disp(Blotter);

Returns = readtable('~/Downloads/Fund/16.01.2017/Returns.csv', 'FileEncoding', 'UTF-8');
Returns(:, [1 18 20]) = []; % drop first colomn with dates
% Returns(1, :) = []; % drop first line with NA
MonthlyReturns = zeros(height(Returns), width(Returns));
for i = 1:width(Returns)
    MonthlyReturns(: ,i) =  table2array( Returns(:, i) );
end

MonthlyReturns = MonthlyReturns(end-24:end, :);

AssetList = P.Name;
AssetMean = geomean( 1 + MonthlyReturns ).^12-1; % Year return
% AssetMean = AssetMean.*(1-PIFs.Sell')./(1+PIFs.Buy'); % With Buy and Sell discounts
AssetCovar = cov(MonthlyReturns)*12;
RiskFreeRate = 0.100;

% RiskFreeRate was changed from .1 to .1/12 , and it changed EVERYTHING!!!
% p = Portfolio('Name', 'PIFs', 'AssetList', AssetList, 'RiskFreeRate', RiskFreeRate,...
%     'InitPort', Blotter.CurrentPort);
% p = setAssetMoments(p, AssetMean, AssetCovar);
% p = setDefaultConstraints(p);
% p = setGroups(p, [ones(1, 17) zeros(1, 16)],...
%     sum(Blotter.CurrentPort(1:17)), sum(Blotter.CurrentPort(1:17)) );
% p = addGroups(p, [zeros(1, 17) ones(1, 16)],...
%     sum(Blotter.CurrentPort(18:33)), sum(Blotter.CurrentPort(18:33)) );
% Frontier = estimateFrontier(p, 50);
% [PortfolioStd, PortfolioReturn] = estimatePortMoments(p, Frontier);
% SharpeFrontier = estimateMaxSharpeRatio(p);
% [SharpeStd, SharpeReturn] = estimatePortMoments(p, SharpeFrontier);
% Blotter = dataset({SharpeFrontier(SharpeFrontier > 0), 'w'},...
%           'obsnames', AssetList(SharpeFrontier > 0) );
% fprintf('Portfolio with Maximum Sharpe Ratio\n');
% disp(Blotter);
% disp([SharpeStd, SharpeReturn])

pCVaR = PortfolioCVaR('Name', 'PIFs CVaR', 'AssetList', AssetList,...
                      'RiskFreeRate', RiskFreeRate, 'InitPort', Blotter.CurrentPort);
pCVaR = setDefaultConstraints(pCVaR);

pCVaR = setGroups(pCVaR, [ones(1, 17) zeros(1, 16)],...
              sum(Blotter.CurrentPort(1:17)), sum(Blotter.CurrentPort(1:17)) );
pCVaR = addGroups(pCVaR, [zeros(1, 17) ones(1, 16)],...
              sum(Blotter.CurrentPort(18:33)), sum(Blotter.CurrentPort(18:33)) );

AssetScenarios = mvnrnd(AssetMean, AssetCovar, 1000);
pCVaR = setScenarios(pCVaR, AssetScenarios);
pCVaR = setProbabilityLevel(pCVaR, 0.99);

ReturnLevels = estimatePortReturn(pCVaR, pCVaR.estimateFrontierLimits);

PortfolioCVaR = estimateFrontierByReturn(pCVaR, ReturnLevels(1):0.05:ReturnLevels(2));
% PortfolioCVaR = estimateFrontierByReturn(pCVaR, ReturnLevels);
ReturnsOfCVaR = estimatePortReturn(pCVaR, PortfolioCVaR);
StdDevOfCVaR = estimatePortStd(pCVaR, PortfolioCVaR);
RiskOfCVaR = estimatePortRisk(pCVaR, PortfolioCVaR);
for i=1:length(ReturnsOfCVaR)
    Portfolio = PortfolioCVaR(:, i);
    BlotterCVaR = dataset({Portfolio(Portfolio > 0.000001), 'w'},...
                  'obsnames', AssetList(Portfolio > 0.000001) );
    fprintf('Portfolio with Return %.4f, StdDev %.4f, Risk %.4f\n',...
            ReturnsOfCVaR(i), StdDevOfCVaR(i), RiskOfCVaR(i));
    disp(BlotterCVaR);
end


%%
%figure('position', [0, 0, 1200, 400])
hold on
set(gcf, 'Color', 'w');
plot(PortfolioStd, PortfolioReturn)
xlabel('Standart deviaton of returns');
ylabel('Expected yearly return');
scatter(SharpeStd, SharpeReturn, 20, 'r', 'filled')
text(SharpeStd+0.001, SharpeReturn-0.001, 'Sharpe', 'FontSize', 6);
%%% Colorized dots, Sharpe ratio, [smallest, biggest] -> [green?, red]
c = (p.AssetMean-RiskFreeRate)./diag(p.AssetCovar).^.5;
c = (c - min(c))./(max(c) - min(c));
scatter(diag(p.AssetCovar).^.5, p.AssetMean, 20, c, 'filled')
text(diag(p.AssetCovar).^.5+0.001, p.AssetMean-0.001, AssetList, 'FontSize', 6);
hold off

% portfolioexamples_plot('Efficient Frontier with Targeted Portfolios', ...
% 	{'line', PortfolioStd/12^.5, PortfolioReturn/12}, ...
%    {'scatter', SharpeStd/12^.5, SharpeReturn/12, {'Sharpe'}}, ...
% 	{'scatter', sqrt(diag(p.AssetCovar))/12^.5, p.AssetMean/12, p.AssetList, '.r'});

% figure;
% set(gcf, 'Color', 'w');
% plotFrontier(pCVaR);

% plot(PortfolioReturn, normcdf(-PortfolioReturn./PortfolioStd))
% xlabel('Expected return of portfolio');
% ylabel('Probability of negative return');
 	


% % Check return for distribution
% hold on
% for i=1:length(Return(1, :))
%     histogram(Return(:, i), 200, 'BinLimits', [0.8 1.2], 'Normalization','probability');
% end
%%
% % Plot normal distribution
x = [-1:.01:1];
plot(x,normpdf(x, 0.2900, 0.1251))