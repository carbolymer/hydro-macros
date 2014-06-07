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

hubble.e0 = 1;
hubble.tau0 = 4;
hubble.cs2 = 0.3333333;

initialE = load('../E2.dat');
X = (1:rows(initialE)) - rows(initialE)./2;
X = X.*0.06;

[e,v] = calculateHubbleTheory(X,4,hubble);

plot(X,initialE,X,e)

