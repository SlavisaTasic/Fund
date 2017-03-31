clear
clc

ibm = ascii2fts('ibm9599.dat', 1, 3, 2);
ibm = fillts(ibm);
ibm = tomonthly(ibm);
ibm = tick2ret(ibm.CLOSE);


fig = figure;
plot(ibm);
ytickformat('%,.2f');
datetick('x', 'mm.yyyy');


fig.PaperUnits = 'points';
fig.PaperPosition = [0 0 600 300];


ax = fig.CurrentAxes;

% Appearance
ax.Box = 'off';

% Individual Axis Appearance and Scale
ax.XLim = [min(ibm.dates) max(ibm.dates)];

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