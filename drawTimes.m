graphics_toolkit('gnuplot');
clear all;


simNumber = 69;
simulationsPath = '/mnt/tesla';

timeIntervals = { 
    '0.004',
    '0.006',
    '0.008',
    '0.01',
    '0.02',
    '0.04',
    '0.06',
    '0.08',
};

timeIntervalsLength = length(timeIntervals);

for k = 1:timeIntervalsLength
  for j = 1:simNumber
    directory = [simulationsPath '/hubble' num2str(j-1) 't' timeIntervals{k}];
    simulationTimes = load([directory '/time.dat']);
    hubbleTime(k,j) = simulationTimes(5) + simulationTimes(6);
    if (k == 1)
      dimx(k,j) = simulationTimes(2);
    end
  end
end

for k = 1:timeIntervalsLength
  for j = 1:simNumber
    directory = [simulationsPath '/ellipsoidal' num2str(j-1) 't' timeIntervals{k}];
    simulationTimes = load([directory '/time.dat']);
    ellipsoidalTime(k,j) = simulationTimes(5) + simulationTimes(6);
  end
end

for k = 1:(2*timeIntervalsLength)
    prefix = '';
    if(floor(k/timeIntervalsLength) < 1)
        prefix = 'hub';
    else
        prefix = 'ell';
    end

    legends{k} = [prefix ' ' timeIntervals{mod(k-1,timeIntervalsLength)+1}];
    k
    mod(k,timeIntervalsLength)
    floor(k/timeIntervalsLength)

end


plot(dimx, hubbleTime, '-.', dimx, ellipsoidalTime, '-');
legend(legends);
xlabel('x dim');
ylabel('time [s]');
title('Simulation time (100 iterations) versus cube size');
print('../images/times.png','-S800,800');
