graphics_toolkit('gnuplot');
clear all;

function variableEvolution = loadVariableEvolution(directory, varName, tPoints, xPoints)
  variableEvolution = zeros(tPoints,xPoints);
  % temporary hack
  for i = [1,tPoints]
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
  % temporary hack
  for i = [1,tPoints]
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

function hubble = getHubbleConfig(directory)
  hubble.e0 = str2num(readFromIniFile('hubble', 'e0', [directory '/config.cfg']));
  hubble.cs2 = str2num(readFromIniFile('hubble', 'cs2', [directory '/config.cfg']));
  hubble.tau0 = str2num(readFromIniFile('hubble', 'tau0', [directory '/config.cfg']));
end

function nsteps = getNSteps(directory)
  nsteps = str2num(readFromIniFile('main', 'steps', [directory '/musta.cfg']));
end

function [e,v] = calculateHubbleTheory(X, t, hubble)
  functionLimit = 3;
  R0 = t-0.5;
  e = hubble.e0 .* power(hubble.tau0./sqrt(t.*t-X.*X),3.*(1+hubble.cs2));
  e = e .* ( abs(X) <= R0);
  v = abs(X)./t .* ( abs(X)<=R0 );
  % too large values are not necessary
  oneone = (e >= functionLimit).*functionLimit;
  e = e .* (e <= functionLimit) + oneone;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                  %
%                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flowType = 'hubble';
timeIntevals = {'0.004', '0.006', '0.008', '0.01', '0.02', '0.04', '0.06', '0.08'};
simCnt = 70;
offset = 0;
initialConditionsTimeOffset = 4;

for k = 1:length(timeIntevals)
  for j = 0:(simCnt-1)
    % !!!! SCIEZKA Z WYNIKAMI SYMULACJI !!!!
    directory{(k-1)*simCnt + j+1} = ['/mnt/tesla/hubble' num2str(j+offset) 't' timeIntevals{k}];
    fileNames{(k-1)*simCnt + j+1} = ['h' num2str(j+offset)];
  end
end
fileNamePrefix = '';
topTitle = 'Hubble flow - ';
topTitle2 = ' distribution';
plotLetters = 'ev';

global figureCounter = 1;
global imagesDirectory = '../images';

simulations = length(directory);
for iSimulation = 1:simulations
  theoryDirectory = [directory{iSimulation} '/theory'];

  [xDim, yDim, zDim] = getDimensions(directory{iSimulation});
  [dx, dy, dz, dt] = getDeltas(directory{iSimulation});
  tPoints = getNSteps(directory{iSimulation});
  plotTPoint = tPoints;
  % ['dx: ' num2str(dx)]
  % ['dt: ' num2str(dt)]

  X = ((1:xDim) - xDim./2).*dx; % centering
  if(flowType == 'hubble')
    hubble = getHubbleConfig(directory{iSimulation});
    [he, hv] = calculateHubbleTheory(X, (plotTPoint)*dt + initialConditionsTimeOffset , hubble);
    [hie, hiv] = calculateHubbleTheory(X, initialConditionsTimeOffset + dt, hubble); % initial
  end

  for i = 1:size(plotLetters)(2)
    varName = plotLetters(i);
    % evolutionTh.(varName) = zeros(simulations,tPoints,xDim);
    % evolution.(varName) = zeros(simulations,tPoints,xDim);

    evolutionInitialTh.(varName) = loadTheoreticalEvolution(theoryDirectory, varName, tPoints, xDim);
    evolutionInitial.(varName) = loadVariableEvolution(directory{iSimulation}, varName, tPoints, xDim);
    
    evolutionTh.(varName) = loadTheoreticalEvolution(theoryDirectory, varName, tPoints, xDim);
    evolution.(varName) = loadVariableEvolution(directory{iSimulation}, varName, tPoints, xDim);

    varName = plotLetters(i);
    figure(figureCounter++);

    if(flowType == 'hubble')
      if(varName == 'e')
        plot(X,evolution.(varName)(plotTPoint,:),'x',X,he,'-',X,evolutionInitial.(varName)(1,:),'x',X,hie,'-')
        legend('simulation', 'theory', 'simulation - after 1st step', 'theory - after 1st step')
      elseif (varName == 'v')
        plot(X,evolution.(varName)(plotTPoint,:),'x',X,hv,'-',X,evolutionInitial.(varName)(1,:),'x',X,hiv,'-')
        legend('simulation', 'theory', 'simulation - after 1st step', 'theory - after 1st step')
      else
        plot(X,evolution.(varName)(plotTPoint,:),'x')
      end
    elseif(flowType == 'elliptic')
      plot(X,evolution.(varName)(plotTPoint,:),'x')
    else
      plot(X,evolution.(varName)(plotTPoint,:),'x')
    end
    title([fileNames{iSimulation} ' ' topTitle varName topTitle2 ' t=' num2str((plotTPoint)*dt+initialConditionsTimeOffset) 'fm - width=' num2str(xDim) ', dt=' num2str(dt)]);
    ylabel(varName);
    xlabel('x');
    print([ imagesDirectory '/' fileNames{iSimulation} '_' fileNamePrefix '_' varName '_x' num2str(xDim) 'dt' num2str(dt) '.png'],'-S800,400');
    close;
  end
end
