graphics_toolkit('gnuplot');

tPoints = 300;
xPoints = 120;
X = 1:xPoints;
meshThe = loadTheoreticalEvolution('e', tPoints, xPoints);
meshe = loadVariableEvolution('e', tPoints, xPoints);

meshThBigE = loadTheoreticalEvolution('E', tPoints, xPoints);
meshBigE = loadVariableEvolution('E', tPoints, xPoints);

meshThv = loadTheoreticalEvolution('v', tPoints, xPoints);
meshv = loadVariableEvolution('v', tPoints, xPoints);

%%%%

fileNamePrefix = 'rel';
topTitle = 'Relativistic 1D Sod shock problem - ';
topTitle2 = ' distribution';
figureCounter = 1;
plotTPoint = 300;

%%%% 

varName = 'e';
figure(figureCounter++);
plot(X(:),meshe(plotTPoint,:),'x',X(:),meshThe(plotTPoint,:),'-')
legend('simulation','theory')
title([topTitle varName topTitle2]);
ylabel(varName);
xlabel('x');
print(['../images/' fileNamePrefix '_' varName '.png'],'-S800,400');

varName = 'E';
figure(figureCounter++);
plot(X(:),meshBigE(plotTPoint,:),'x',X(:),meshThBigE(plotTPoint,:),'-')
legend('simulation','theory')
title([topTitle varName topTitle2]);
ylabel(varName);
xlabel('x');
print(['../images/' fileNamePrefix '_' varName '.png'],'-S800,400');

varName = 'v';
figure(figureCounter++);
plot(X(:),meshv(plotTPoint,:),'x',X(:),meshThv(plotTPoint,:),'-')
legend('simulation','theory')
title([topTitle varName topTitle2]);
ylabel(varName);
xlabel('x');
print(['../images/' fileNamePrefix '_' varName '.png'],'-S800,400');
