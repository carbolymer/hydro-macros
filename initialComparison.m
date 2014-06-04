graphics_toolkit('gnuplot');
clear all;

function [e,v] = calculateHubbleTheory(X, t, hubble)
  e = hubble.e0 .* power(hubble.tau0./sqrt(t.*t-X.*X),3.*(1+hubble.cs2)) .* ( abs(X) <= t);
  v = abs(X)./t .* ( abs(X)<=t );
  % too large values are not necessary
  oneone = (e >= 12).*12;
  e = e .* (e <= 12) + oneone;
end

hubble.e0 = 1;
hubble.tau0 = 4;
hubble.cs2 = 0.3333333;

initialE = load('/d/initialE.dat');
X = (1:rows(initialE)) - rows(initialE)./2;
X = X.*0.06;

[e,v] = calculateHubbleTheory(X,4,hubble);

plot(X,initialE,X,e)

