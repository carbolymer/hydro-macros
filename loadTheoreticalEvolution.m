function variableEvolution = loadTheoreticalEvolution(varName, tPoints, xPoints)
  variableEvolution = zeros(tPoints,xPoints);
  for i = 1:tPoints
    a = load(['./../output/theory_' varName '_' int2str(i-1) '.dat']);
    variableEvolution(i,:) = a;
  end
end