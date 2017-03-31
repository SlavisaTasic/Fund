clear
clc

ibm = ascii2fts('ibm9599.dat', 1, 3, 2);
ibm = fillts(ibm);
ibm = tick2ret(ibm.CLOSE);

fig = figure;
plot(ibm);
datetick('x', 'mm.yyyy');


fig.PaperUnits = 'points';
fig.PaperPosition = [0 0 600 300];
ax = fig.CurrentAxes;
ax.Box = 'off';
ax.TickLength = [0.005 0.025];
ax.TickDir = 'out';
%ax.Units = 'pixels';
%ax.OuterPosition 	% red
%ax.Position			% blue
%ax.TightInset		% magenta

ax.Position = [0.05 0.10 0.90 0.85];

% 432*216
%		 /[6 3]
% 72*72


tic
print(fig, '-r150', '-dsvg', 'png/print.svg');
toc
display('print done');


tic
saveas(fig, 'png/saveas.svg');
toc
display('saveas done');

close(fig);