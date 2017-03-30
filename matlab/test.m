clear
clc
f = figure;
plot([1:5, [5:-1:1]]);
print(f, '-r150', '-dsvg', 'png/print.svg');
display('print done');
saveas(f, 'png/saveas.svg');
display('saveas done');
close(f);