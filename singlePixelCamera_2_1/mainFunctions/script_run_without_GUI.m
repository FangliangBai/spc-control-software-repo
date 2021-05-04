%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
imageV = 8;
imageH = 8;
screenH = .3;
screenV = .5;
offsetH = 0;
offsetV = 0;
dictionaryType = 'canonical';
waveletType = [];
decomposition = [];
measuringMatrix = 'bernoulli';
colorMode = 1;

basis = create_dictionary(dictionaryType,imageH,imageV,waveletType,decomposition);
data = CS_data_projector(nMeasures,nSamples,imageH,imageV,screenH,screenV,measuringMatrix,colorMode,offsetH,offsetV);
reconstruction = CS_reconstruction(data,basis,imageH,imageV,recoveryMethod,colorMode,epsilon,removeDC,sparcity);