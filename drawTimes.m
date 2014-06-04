graphics_toolkit('gnuplot');
clear all;


dataCnt = 1;
simNumber = 69;

legendLabels{dataCnt} = '0.02';
for j = 1:simNumber
  directory = ['/mnt/tesla/hubble' num2str(j-1) 't0.02'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5);
  dimx(j) = simulationTimes(2);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.04';
for j = 1:simNumber
  directory = ['/mnt/tesla/hubble' num2str(j-1) 't0.04'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.06';
for j = 1:simNumber
  directory = ['/mnt/tesla/hubble' num2str(j-1) 't0.06'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5);
end
++dataCnt;
%%

legendLabels{dataCnt} = '0.08';
for j = 1:simNumber
  directory = ['/mnt/tesla/hubble' num2str(j-1) 't0.08'];
  simulationTimes = load([directory '/time.dat']);
  time(dataCnt,j) = simulationTimes(5);
end
++dataCnt;
%%

plot(dimx, time);
legend(legendLabels);
xlabel('x dim');
ylabel('time');