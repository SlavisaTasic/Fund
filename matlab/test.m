clear
clc
fig = figure;
bar([1 10 7 8 2 2 9 3 6])
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

ax.Position = [0.00 0.10 0.90 0.85];

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