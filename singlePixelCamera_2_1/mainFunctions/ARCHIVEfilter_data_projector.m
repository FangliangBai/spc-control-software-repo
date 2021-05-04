function filteredIntensity = filter_data_projector(intensity,treshold)

%Function used to filter the arduino output. 

%intensity - vector contaning the intensity measures
%treshold - treshold value for the second derivative.
%the first data point that pass this value is consider
%the new treshold for the intensity measure.

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
sortIntensity = sort(intensity);
% secondDerivative = diff(sortIntensity,2);
% [~,locs] = findpeaks(secondDerivative,'MINPEAKHEIGHT',treshold);
% tresholdLocation = locs(1);
% tresholdIntensity = sortIntensity(tresholdLocation);
% intensity(intensity > tresholdIntensity)=[];
% 
% filteredIntensity = intensity;

%---PEAK DETECTION NOT WORKING - RESORT TO MEDIAN---
filteredIntensity = median(sortIntensity);
            
end
