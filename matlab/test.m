clear
clc

ibm = ascii2fts('ibm9599.dat', 1, 3, 2);
ibm = fillts(ibm);
ibm = tomonthly(ibm);
ibm = tick2ret(ibm.CLOSE);
ibm_se = std(ibm);
ibm_se = ibm_se.CLOSE;
X = ibm.dates;
Y = fts2mat(ibm);


fig = figure;
plot(X, Y);
ytickformat('%,.2f');
datetick('x', 'mm.yyyy');
hold on
plot(X, [-1.96*ibm_se+Y, 1.96*ibm_se+Y]);
hold off

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



clc;
clear all;
fig = figure;

a= random('normal',10,4,1,100); % Generate a normally distributed random numbers 
pd = fitdist(a','normal'); % Creates a ProbDistUnivParam object by fitting the data to a normal distribution. For details look at Documentation
ci = paramci(pd); % This function calculates the  values of the parameters based on a certain confidence interval. Here the by default the confidence interval is 95 percent
probplot(a);
h=probplot(gca,@(a,x,y)normcdf(a,x,y),[ci(1,1),ci(1,2)]); 
set(h,'color','r','linestyle','-')
t= probplot(gca,@(a,x,y)normcdf(a,x,y),[ci(2,1),ci(2,2)]);
set(t,'color','g','linestyle','-.')


tic
print(fig, '-r150', '-dsvg', 'png/print.svg');
toc
display('print done');


tic
saveas(fig, 'png/saveas.svg');
toc
display('saveas done');

close(fig);