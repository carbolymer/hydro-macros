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

function ellipsoidal = getEllipsoidalConfig(directory)
  ellipsoidal.c_e = str2num(readFromIniFile('ellipsoidal', 'c_e', [directory '/config.cfg']));
  ellipsoidal.c_n = str2num(readFromIniFile('ellipsoidal', 'c_n', [directory '/config.cfg']));
  ellipsoidal.t0 = str2num(readFromIniFile('ellipsoidal', 't0', [directory '/config.cfg']));
  ellipsoidal.t1 = str2num(readFromIniFile('ellipsoidal', 't1', [directory '/config.cfg']));
  ellipsoidal.t2 = str2num(readFromIniFile('ellipsoidal', 't2', [directory '/config.cfg']));
  ellipsoidal.t3 = str2num(readFromIniFile('ellipsoidal', 't3', [directory '/config.cfg']));
  ellipsoidal.b_e = str2num(readFromIniFile('ellipsoidal', 'b_e', [directory '/config.cfg']));
  ellipsoidal.b_n = str2num(readFromIniFile('ellipsoidal', 'b_n', [directory '/config.cfg']));
  ellipsoidal.p_0 = str2num(readFromIniFile('ellipsoidal', 'p_0', [directory '/config.cfg']));
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

function [e,v] = calculateEllipsoidalTheory(X, t, ellipsoidal)
  t = t + ellipsoidal.t0;
  timePart = (t + ellipsoidal.t1).*(t + ellipsoidal.t2).*(t + ellipsoidal.t3);
  tau_tilda2 = t.*t.*(1-X.*X./pow2(t - ellipsoidal.t1)); %!!!
  e = -ellipsoidal.p_0 + ellipsoidal.c_e./timePart.*exp(-pow2(ellipsoidal.b_e)./tau_tilda2);
  v = abs(X./(t+ellipsoidal.t1));

  e = e .* (tau_tilda2 >= 0);
  v = v .* (tau_tilda2 >= 0);
  % v = v.* 1.1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                  %
%                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% <-- begin of config -->
 
% 
% available flow types:
%   ellipsoidal
%   hubble
% 
flowType = 'ellipsoidal';
% flowType = 'hubble';
timeIntervals = {
    % '0.004'
    % '0.006',
    % '0.008',
    % '0.01',
    % '0.02'
    '0.04'
    % '0.06'
    % '0.08'
};

simCnt = 1;
offset = 65;
initialConditionsTimeOffset.('hubble') = 3.9;
initialConditionsTimeOffset.('ellipsoidal') = 0.72;
timeMultiplier.('hubble') = 1;
timeMultiplier.('ellipsoidal') = 0.6;

for k = 1:length(timeIntervals)
  for j = 0:(simCnt-1)
    % !!!! SCIEZKA Z WYNIKAMI SYMULACJI !!!!
    directory{(k-1)*simCnt + j+1} = ['/mnt/tesla/' flowType num2str(j+offset) 't' timeIntervals{k}];
    fileNames{(k-1)*simCnt + j+1} = [flowType(1) num2str(j+offset)];
  end
end
fileNamePrefix = '';
topTitle = 'Hubble flow - ';
topTitle2 = ' distribution';
plotLetters = 'ev';

global figureCounter = 1; % do not change
global imagesDirectory = '../images';

simulations = length(directory);
for iSimulation = 1:simulations
  theoryDirectory = [directory{iSimulation} '/theory'];
% <-- end of config -->

  [xDim, yDim, zDim] = getDimensions(directory{iSimulation});
  [dx, dy, dz, dt] = getDeltas(directory{iSimulation});
  tPoints = getNSteps(directory{iSimulation});
  plotTPoint = tPoints;
  % ['dx: ' num2str(dx)]
  % ['dt: ' num2str(dt)]

  X = ((1:xDim) - xDim./2 - 1/2).*dx; % centering
  if(strcmp(flowType, 'hubble'))
    hubble = getHubbleConfig(directory{iSimulation});
    [he, hv] = calculateHubbleTheory(X, (plotTPoint.*timeMultiplier.(flowType))*dt + initialConditionsTimeOffset.('hubble') , hubble);
    [hie, hiv] = calculateHubbleTheory(X, initialConditionsTimeOffset.('hubble')  + dt, hubble); % initial
  elseif (strcmp(flowType, 'ellipsoidal'))
    ellipsoidal = getEllipsoidalConfig(directory{iSimulation});
    [ee, ev] = calculateEllipsoidalTheory(X, initialConditionsTimeOffset.('ellipsoidal') + (plotTPoint.*timeMultiplier.(flowType))*dt , ellipsoidal);
    [eie, eiv] = calculateEllipsoidalTheory(X, initialConditionsTimeOffset.('ellipsoidal'), ellipsoidal); % initial
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

    if(strcmp(flowType, 'hubble'))
      if(varName == 'e')
        plot(X,evolution.(varName)(plotTPoint,:),'x',X,he,'-',X,evolutionInitial.(varName)(1,:),'x',X,hie,'-')
        legend('simulation', 'theory', 'simulation - after 1st step', 'theory - after 1st step')
      elseif (varName == 'v')
        plot(X,evolution.(varName)(plotTPoint,:),'x',X,hv,'-',X,evolutionInitial.(varName)(1,:),'x',X,hiv,'-')
        legend('simulation', 'theory', 'simulation - after 1st step', 'theory - after 1st step')
      else
        plot(X,evolution.(varName)(plotTPoint,:),'x')
      end
    elseif(strcmp(flowType, 'ellipsoidal'))
      if(varName == 'e')
        plot(X,evolution.(varName)(plotTPoint,:),'x', X,ee, '-', X,evolution.(varName)(1,:),'x', X, eie, '-')
        legend('simulation', 'theory', 'simulation - after 1st step', 'theory - after 1st step')
      elseif (varName == 'v')
        plot(X,evolution.(varName)(plotTPoint,:),'x', X, ev, '-', X,evolution.(varName)(1,:),'x', X, eiv, '-')
        legend('simulation', 'theory', 'simulation - after 1st step', 'theory - after 1st step')
      else
        plot(X,evolution.(varName)(plotTPoint,:),'x')
      end
    else
      plot(X,evolution.(varName)(plotTPoint,:),'x')
    end
    title([fileNames{iSimulation} ' ' topTitle varName topTitle2 ' t=' num2str((plotTPoint.*timeMultiplier.(flowType))*dt+initialConditionsTimeOffset.(flowType)) 'fm - width=' num2str(xDim) ', dt=' num2str(dt)]);
    ylabel(varName);
    xlabel('x');
    print([ imagesDirectory '/' fileNames{iSimulation} '_' fileNamePrefix '_' varName '_x' num2str(xDim) 'dt' num2str(dt) '.png'],'-S800,400');
    % close;
  end
end
