function variableEvolution = loadVariableEvolution(varName, tPoints, xPoints)
  variableEvolution = zeros(tPoints,xPoints);
  for i = 1:tPoints
    variableEvolution(i,:) = load(['./../output/data_' varName '_section_x_' int2str(i-1) '.dat']);
  end
end