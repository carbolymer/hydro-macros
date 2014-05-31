graphics_toolkit('gnuplot');

function variableEvolution = loadVariableEvolution(directory, varName, tPoints, xPoints)
  variableEvolution = zeros(tPoints,xPoints);
  for i = 1:tPoints
    fileName = [directory '/data_' varName '_section_x_' int2str(i-1) '.dat'];
    if( exist(fileName) != 2 )
      % ['FILE DOES NOT EXIST ' fileName ]
      break;
    end
    a = load(fileName);
    variableEvolution(i,:) = a;
  end
end

function variableEvolution = loadTheoreticalEvolution(directory, varName, tPoints, xPoints)
  variableEvolution = zeros(tPoints,xPoints);
  for i = 1:tPoints
    fileName = [directory '/theory_' varName '_' int2str(i-1) '.dat'];
    if( exist(fileName) != 2 )
      % ['FILE DOES NOT EXIST ' fileName ]
      break;
    end
    a = load(fileName);
    variableEvolution(i,:) = a;
  end
end

function [xDim, yDim, zDim] = getDimensions(directory)
  xDim = str2num(readFromIniFile('fluid', 'xDim', [directory '/musta.cfg']));
  yDim = str2num(readFromIniFile('fluid', 'yDim', [directory '/musta.cfg']));
  zDim = str2num(readFromIniFile('fluid', 'zDim', [directory '/musta.cfg']));
end

function [dx, dy, dz, dt] = getDeltas(directory)
  dx = str2num(readFromIniFile('fluid', 'dx', [directory '/musta.cfg']));
  dy = str2num(readFromIniFile('fluid', 'dy', [directory '/musta.cfg']));
  dz = str2num(readFromIniFile('fluid', 'dz', [directory '/musta.cfg']));
  dt = str2num(readFromIniFile('fluid', 'dt', [directory '/musta.cfg']));
end

function nsteps = getNSteps(directory)
  nsteps = str2num(readFromIniFile('main', 'steps', [directory '/musta.cfg']));
end

function oneDimPlot()
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                  %
%                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

directory = [
  '/mnt/tesla/hubble0' ;
  '/mnt/tesla/hubble1' ;
  '/mnt/tesla/hubble2'
];

fileNamePrefix = 'rel';
topTitle = 'Relativistic 1D Sod shock problem - ';
topTitle2 = ' distribution';
plotLetters = 'neEv';
legends = {'h0','h1','h2'};

global figureCounter = 1;
global imagesDirectory = '../images';

simulations = rows(directory);
for iSimulation = 1:simulations
  theoryDirectory = [directory(iSimulation,:) '/theory'];

  [xDim, yDim, zDim] = getDimensions(directory(iSimulation,:));
  [dx, dy, dz, dt] = getDeltas(directory(iSimulation,:));
  tPoints = getNSteps(directory(iSimulation,:));


  for i = 1:size(plotLetters)(2)
    varName = plotLetters(i);
    evolutionTh.(varName) = zeros(simulations,tPoints,xDim);
    evolution.(varName) = zeros(simulations,tPoints,xDim);

    evolutionTh.(varName)(iSimulation,:,:) = loadTheoreticalEvolution(theoryDirectory, varName, tPoints, xDim);
    evolution.(varName)(iSimulation,:,:) = loadVariableEvolution(directory(iSimulation,:), varName, tPoints, xDim)
  end


end

X = 1:xDim;
for i = 1:size(plotLetters)(2)
  varName = plotLetters(i);
  figure(figureCounter++);
  data = reshape(evolution.(varName)(:,tPoints,:),simulations, xDim);
  data(1,:);
  % plot(X(:),evolution.(varName)(tPoints,:),'x',X(:),evolutionTh.(varName)(tPoints,:),'-')
  plot(data(2,:));
  legend(legends)
  title([topTitle varName topTitle2]);
  ylabel(varName);
  xlabel('x');
  print([ imagesDirectory '/' fileNamePrefix '_' varName '.png'],'-S800,400');
end