graphics_toolkit('gnuplot');
clear all;

function [e,v] = calculateHubbleTheory(X, t, hubble)
  R0 = t - 0.5;
  e = hubble.e0 .* power(hubble.tau0./sqrt(t.*t-X.*X),3.*(1+hubble.cs2)) .* ( abs(X) <= R0);
  v = abs(X)./t .* ( abs(X)<= R0 );
  % too large values are not necessary
  oneone = (e >= 12).*12;
  e = e .* (e <= 12) + oneone;
end

function [e,v] = calculateEllipsoidalTheory(X, t, ellipsoidal)
  % X = X.* 2;
  t = t + ellipsoidal.t0;
  timePart = (t + ellipsoidal.t1).*(t + ellipsoidal.t2).*(t + ellipsoidal.t3);
  tau_tilda2 = t.*t.*(1-X.*X./pow2(t - ellipsoidal.t1)); %!!!
  e = -ellipsoidal.p_0 + ellipsoidal.c_e./timePart.*exp(-pow2(ellipsoidal.b_e)./tau_tilda2);
  v = abs(X./(t+ellipsoidal.t1));

  e = e .* (tau_tilda2 >= 0);
  v = v .* (tau_tilda2 >= 0);

  % e = e.* 3.25;
end

hubble.e0 = 1;
hubble.tau0 = 4;
hubble.cs2 = 0.3333333;

ellipsoidal.c_e =  2;
ellipsoidal.c_n =  0.75000;
ellipsoidal.t0 =  2;
ellipsoidal.t1 =  0.40000;
ellipsoidal.t2 =  0.60000;
ellipsoidal.t3 =  0.80000;
ellipsoidal.b_e =  1;
ellipsoidal.b_n =  1;
ellipsoidal.p_0 =  0;


% initialE = load('../hubbleE2.dat');
initialE = load('../e65_e.dat');
X = (1:rows(initialE)) - rows(initialE)./2;
X = X.*0.06; % hubble

% [e,v] = calculateHubbleTheory(X,4,hubble);
[e,v] = calculateEllipsoidalTheory(X,0.7,ellipsoidal);

plot(X,initialE,X,e)
legend('initial','theory');

