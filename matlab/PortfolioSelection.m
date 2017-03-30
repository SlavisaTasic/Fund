clc
clear

monthlyReturns = loadMonthlyReturns;
A = monthlyReturns.Variables;
A = A(:,[13:28 48:64]);
[AssetMean, AssetCov] = computeMeanCov(A);

RiskFreeRate = 0.100;

AssetList = loadSymbols;
AssetList = AssetList([13:28 48:64]);
pCVaR = PortfolioCVaR('Name', 'PIFs CVaR', 'AssetList', AssetList,...
                      'RiskFreeRate', RiskFreeRate ...%, 'InitPort', Blotter.CurrentPort
                      );
pCVaR = setDefaultConstraints(pCVaR);
[groups, groupMatrix] = loadConstraints;
pCVaR.GroupMatrix = groupMatrix([2 4], [13:28 48:64]);
pCVaR.LowerGroup = groups([2 4]);
pCVaR.UpperGroup = groups([2 4]);



AssetScenarios = mvnrnd(AssetMean, AssetCov, 1000);
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
    Portfolio;
	BlotterCVaR = table(AssetList(Portfolio > 0.000001), Portfolio(Portfolio > 0.000001), ...
						'VariableNames', {'symbol', 'weights'} );
	fprintf('Portfolio with Return %.4f, StdDev %.4f, Risk %.4f\n',...
           ReturnsOfCVaR(i), StdDevOfCVaR(i), RiskOfCVaR(i));
	disp(BlotterCVaR);
end

function [AssetMean, AssetCov] = computeMeanCov(A)
	AssetMean = exp(mean(log(1 + A), 'omitnan')).^12-1; % year return
	AssetCov = cov(A, 'partialrows')*12; % year covarience
end
