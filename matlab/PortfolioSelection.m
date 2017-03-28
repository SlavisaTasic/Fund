clc
clear

monthlyReturns = loadMonthlyReturns;
[AssetMean, AssetCov] = computeMeanCov(monthlyReturns);

RiskFreeRate = 0.100;

[AssetMean, AssetCov] = computeMeanCov(A)

AssetList = P.Name;
pCVaR = PortfolioCVaR('Name', 'PIFs CVaR', 'AssetList', AssetList,...
                      'RiskFreeRate', RiskFreeRate, 'InitPort', Blotter.CurrentPort);
pCVaR = setDefaultConstraints(pCVaR);
[groups, groupMatrix] = loadConstraints;
pCVaR.GroupMatrix = groupMatrix;
pCVaR.LowerGroup = groups;
pCVaR.UpperGroup = groups;
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



function [AssetMean, AssetCov] = computeMeanCov(A)
	AssetMean = exp(mean(log(1 + A), 'omitnan')).^12-1; % year return
	AssetCov = cov(A, 'partialrows')*12; % year covarience
end
