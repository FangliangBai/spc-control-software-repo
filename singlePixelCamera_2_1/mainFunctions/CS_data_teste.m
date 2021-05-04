function data = CS_data_teste(nMeasures,imageH,imageV,measuringMatrix,...
    colorMode,testImage,mu,sigma)

%Function for aquiring the 'luminosity' measurements analiticaly. It does that
%by multiplying element wise the measuring matrix with the image in question.
%To better simulate a real case scenario it can also add some gausian noise to
% the measurements.

%nSamples - number of random patterns
%imageH - number of horizontal pixels in the image 
%imageH - number of vertical pixels in the image 
%measuringMatrix - matrix in which every line is a linearized version of
%the random patterns to be prejected
%colorMode - 1 for gray scale images 3 for RGB images
%testimage - Image that is going to be sampled
%mu - mean of the gaussian noise
%sigma - standart deviation of the gaussian noise

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
%% Random Patterns

if ischar(measuringMatrix) %Verify if the measuring matrix was already provided
    measuringMatrix = create_measuring_matrix(measuringMatrix,nMeasures,imageH,imageV);
end



for ii = 1:nMeasures + 2 %the measuring matrix has two more added pattern(full on/full off)
    
    for nn = 1:colorMode
        
        convolutionMatrix = measuringMatrix{ii};
        convolutionMatrix = convolutionMatrix(:);
        
        convolutionImage = testImage(:,:,nn);
        convolutionImage = convolutionImage(:);
        convolutionImage = double(convolutionImage);
	%elementwise multiplication
        convolution(nn) = convolutionMatrix' * convolutionImage;
	% add random noise
        convolution(nn) = convolution(nn) + randn * sigma + mu; 
    end
    
    data(ii,:) = [convolutionMatrix' convolution];
    
end

end

