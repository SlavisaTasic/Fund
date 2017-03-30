clear
clc
f = figure;
plot([1:5, [5:-1:1]]);
print(f, '-r100', '-dpng', 'print.png');
display('print done');
saveas(f, 'saveas.png');
display('saveas done');
close(f);