measurements = measurements - measurements(end);
% measurements = measurements(1:end-2);
measurements(end-1:end)=3;
teste = reshape(measurements,16,16);

CT=cbrewer('div', 'RdBu', 11);

colormap(CT)

axis square