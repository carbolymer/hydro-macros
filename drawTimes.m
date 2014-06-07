graphics_toolkit('gnuplot');
clear all;


dataCnt = 1;
simNumber = 69;
simulationsPath = '/mnt/tesla';

% TODO replace with loop
legendLabels{dataCnt} = '0.004';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.004'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
  dimx(dataCnt,j) = simulationTimes(2);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.006';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.006'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.008';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.008'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.01';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.01'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.02';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.02'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.04';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.04'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.06';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.06'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.08';
for j = 1:simNumber
  directory = [simulationsPath '/hubble' num2str(j-1) 't0.08'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5) + simulationTimes(6);
end
++dataCnt;
%%

plot(dimx, time);
legend(legendLabels);
xlabel('x dim');
ylabel('time [s]');
title('Simulation time (100 iterations) versus cube size');
print('../images/times.png','-S800,800');
