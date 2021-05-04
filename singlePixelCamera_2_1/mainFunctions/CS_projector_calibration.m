function CS_projector_calibration(imageH,imageV,screenH,screenV,offsetH,offsetV)

%Function that start the calibration process

%imageH - number of horizontal pixels in the image 
%imageH - number of vertical pixels in the image 
%screenH - Percentage of the horizontal part of the screen to be used
%screenV - Percentage of the vertical part of the screen to be used
%OffsetH - horizontal offset
%OffsetV - vertical offset

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
%% Create the calibration matrix

%main diagonal elements equal to 1
calibrationMatrix = eye(imageV,imageH);
%secondary diagonal elements equal to 1
for ii = 1:min(imageV,imageH)
    for jj = 1:min(imageV,imageH)
        if ii + jj == min(imageV,imageH) +1
            calibrationMatrix(ii,jj) = 1;
        end
    end
end

%Outer elements equal to 1
calibrationMatrix(1,:) = 1;
calibrationMatrix(:,1) = 1;
calibrationMatrix(end,:) = 1;
calibrationMatrix(:,end) = 1;

offset = [offsetH, offsetV];
screenPercentage = [screenH, screenV];
%% preparing projection matrix
projection = matrix2projection(screenH,screenV,calibrationMatrix,1);

projection = circshift(projection,offsetV);
projection = circshift(projection,[0 offsetH]);

projection = im2uint8(projection);

save('calibrationData','projection','offset','screenPercentage','calibrationMatrix');

h = calibration_GUI;
figure(h);
fullscreen(projection,1);
figure(h);
%wait for the calibration_GUI close to continue 
waitfor(h);
end
