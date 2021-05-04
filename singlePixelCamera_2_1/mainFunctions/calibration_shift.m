function [projectionOut, offsetOut] = calibration_shift(projectionIn,par,val,offset)

%Function that is called by the calibration GUI to move the pattern on the
%screen

%projectionIn - input image to be projected
%par - shift parameter (up,down,left,right)
%value - value of the shift
%offset - absolute shift value

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.

offsetOut = offset;

switch par
    case 'up'
        projectionOut = circshift(projectionIn,-val);
        offsetOut = offsetOut - [0 val];
    case 'down'
        projectionOut = circshift(projectionIn,val);
        offsetOut = offsetOut + [0 val];
    case 'left'
        projectionOut = circshift(projectionIn,[0,-val]);
        offsetOut = offsetOut - [val 0];
    case 'right'
        projectionOut = circshift(projectionIn,[0,val]);
        offsetOut = offsetOut + [val 0];
end
