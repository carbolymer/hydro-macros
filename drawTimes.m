graphics_toolkit('gnuplot');
clear all;


dataCnt = 1;
simNumber = 69;
simulationsPath = '/mnt/tesla';

timeIntevals = { 
    % '0.004',
    % '0.006',
    % '0.008',
    % '0.01',
    '0.02',
    '0.04',
    '0.06',
    '0.08',
};


for k = 1:length(timeIntevals)
  for j = 1:simNumber
    directory = [simulationsPath '/hubble' num2str(j-1) 't' timeIntevals{k}];
    simulationTimes = load([directory '/time.dat']);
    time(k,j) = simulationTimes(5) + simulationTimes(6);
    if (k == 1)
      dimx(k,j) = simulationTimes(2);
    end
  end
end


plot(dimx, time);
legend(timeIntevals);
xlabel('x dim');
ylabel('time [s]');
title('Simulation time (100 iterations) versus cube size');
print('../images/times.png','-S800,800');
