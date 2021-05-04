function projection = matrix2projection(screenH,screenV,calibrationMatrix,color)

%Function that output a matrix that is going to projected
%screenH - Percentage of the horizontal part of the screen to be used
%screenV - Percentage of the vertical part of the screen to be used
%calibrationMatrix - image that you want to project (e.g. measuringMatrix)

%Author: Pedro Dreyer University of Kent 22/11/14
%Modified: Stuart Gibson, University of Kent 28/05/15
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
screenSize = get(0,'ScreenSize');

    %disp('DEBUG')% S Gibson 28 May 2015
    device_number = 1;
    ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
    gds = ge.getScreenDevices();
    height = gds(device_number).getDisplayMode().getHeight();
    width = gds(device_number).getDisplayMode().getWidth();

    %screenSize
    
    if screenSize(3)>width
        screenSize(3) = width;
    end
    if screenSize(4)>height
        screenSize(4) = height;
    end

projectionSize = round([screenV*screenSize(4) screenH*screenSize(3)]);
hSpace = floor((screenSize(4)-projectionSize(1))/2);
wSpace = floor((screenSize(3)-projectionSize(2))/2);
projection = zeros(screenSize(4),screenSize(3),3);
if color ~= 0 
    projection(hSpace:(hSpace+projectionSize(1)-1),wSpace:(wSpace+projectionSize(2)-1),color) =...
        imresize(calibrationMatrix,projectionSize,'nearest');
else
    projection(hSpace:(hSpace+projectionSize(1)-1),wSpace:(wSpace+projectionSize(2)-1),1) =...
        imresize(calibrationMatrix,projectionSize,'nearest');
    projection(:,:,2) = projection(:,:,1);
    projection(:,:,3) = projection(:,:,1);
end
