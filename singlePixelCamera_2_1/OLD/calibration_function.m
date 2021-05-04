function [projectionOut, offsetOut] = calibration_function(projectionIn,par,val,offset)

offsetOut = offset;

switch par
    case 'up'
        projectionOut = circshift(projectionIn,-val);
        offsetOut = offsetOut - [0 val];
    case 'down'
        projectionOut = circshift(projectionIn,val);
        offsetOut = offsetOut + [0 val];
    case 'left'
        projectionOut = circshift(projectionIn,-val,2);
        offsetOut = offsetOut - [val 0];
    case 'right'
        projectionOut = circshift(projectionIn,val,2);
        offsetOut = offsetOut + [val 0];
end