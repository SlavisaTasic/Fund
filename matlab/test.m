clear
clc
fig = figure;
bar([1 10 7 8 2 2 9 3 6])
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 3];
ax = fig.CurrentAxes;
ax.Box = 'off';



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