clear
clc

ibm = ascii2fts('ibm9599.dat', 1, 3, 2);
ibm = fillts(ibm);
ibm = tomonthly(ibm);
ibm = tick2ret(ibm.CLOSE);
ibm_se = std(ibm);
ibm_se = ibm_se.CLOSE;
X = ibm.dates';
Y = fts2mat(ibm)';
lower = -1.96*ibm_se+Y;
upper = 1.96*ibm_se+Y;

fig = figure;
plot(X, Y);
ytickformat('%,.2f');
datetick('x', 'mm.yyyy');
hold on
%plot(X, [-1.96*ibm_se+Y, 1.96*ibm_se+Y]);
p = patch([X flip(X)], [upper flip(lower)], [0 191 255]/255);
p.FaceAlpha = 0.3;
p.EdgeColor = [1 1 1];
hold off

fig.PaperUnits = 'points';
fig.PaperPosition = [0 0 600 300];


ax = fig.CurrentAxes;

% Appearance
ax.Box = 'off';

% Individual Axis Appearance and Scale
ax.XLim = [min(ibm.dates)-2 max(ibm.dates)+5];

% Tick Values and Labels
ax.TickLength = [0.005 0.025];
ax.TickDir = 'out';

% Location and Size
ax.Position = [0.07 0.10 0.90 0.85];


tic
print(fig, '-r150', '-dsvg', 'png/print.svg');
toc
display('print done');


tic
saveas(fig, 'png/saveas.svg');
toc
display('saveas done');

close(fig);