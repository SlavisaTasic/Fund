clear
clc
f = figure;
plot([1:5, [5:-1:1]]);
print(f, '-r150', '-dpng', 'png/print.png');
display('print done');
saveas(f, 'png/saveas.png');
display('saveas done');
close(f);