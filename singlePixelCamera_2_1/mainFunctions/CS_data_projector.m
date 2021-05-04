function data = CS_data_projector(nSamples,nMeasures,imageH,imageV,...
    screenH,screenV,measuringMatrix,colorMode,offsetH,offsetV,averageMode)

%Funciton to display the randon patterns in fullscreen mode and then record
%the values of the sensor

%INPUTS
%nSamples - number of measures per pattern [CURRENTLY NOT USED]
%nMeasures - number of random patterns
%imageH - number of horizontal pixels in the image
%imageH - number of vertical pixels in the image
%screenH - Percentage of the horizontal part of the screen to be used
%screenV - Percentage of the vertical part of the screen to be used
%measuringMatrix - Could be either a string (see create_measuring_matrix)
%or a matrix where each line represent a linearized random patern
%colorMode - 1 for gray scale images 3 for RGB images
%averageMode - mean, meadian, mode [CURRENTLY NOT USED]

%OUTPUTS
%data = matrix containing the linearized random paterns and measurements
%It is organized in the following way:
%Grayscale - data(:,1:end-1) -> random paterns / data(:,end) -> measurements
%RGB - data(:,1:end-3) -> random paterns / data(:,end-2:end) -> measurements


%Author: P. Dreyer, D. Pickup & S. Gibson University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.

%%---- NEW ARDUINO CODE ----
% Script to determine detector linearity
% Triggered detector
% Dave
% v1 29/7/15

%try connected port
path = pwd;
try
    delete(instrfind);
    portStruc = load([path,'\portName.mat']);
    name = portStruc.portName;
    obj1 = serial(name,'BaudRate', 115200);
    fopen(obj1);
    pause(2); % this pause is necessary to allow time for communication with the Arduino to be established
    identity = fscanf(obj1, '%s');
catch
    delete(instrfind);
    %search the arduino serial port
    portList = instrhwinfo('serial');
    availablePort = cell2mat(portList.SerialPorts);
    sizeOfPorts = size(availablePort);
    numberOfPorts = sizeOfPorts(1);
    portName = '';
    for iter =1:1:numberOfPorts
        portName = availablePort(iter,:);
        disp(['try to connect',portName]);
        obj1 = serial(portName,'BaudRate', 115200);
        fopen(obj1);
        pause(2);
        identity = fscanf(obj1, '%s');
        if strcmp(identity,'SPC')
            try
                save portName portName;
            catch
            end
            break;
        else
            disp(['Port ',portName,' not authenticated']);
            fclose(obj1);
            delete(obj1);
        end
    end
end


% Create serial port object and set baud rate
% obj1 = serial('COM5','BaudRate', 115200);
% % Connect to instrument object, obj1.
% fopen(obj1);
% pause(2); % this pause is necessary to allow time for communication with the Arduino to be established


%% see if there is an arduino conected
% delete(instrfindall)
% try
%     %a = serial('COM6');
%     %a = arduino('COM5');
%     %a = arduino('COM3');
%     a = arduino('COM5');
%     arduinoFound = 1;
%
% catch
%     arduinoFound = 0;
% end

% set(a, 'inputbuffersize', 1024);
% set(a, 'BaudRate', 115200);
% set(a, 'FlowControl', 'none');
% set(a, 'parity', 'none');
% set(a, 'DataBits', 8);
% set(a, 'StopBit', 1);
% set(a, 'Timeout', 4);
% fopen(a)

% b = a.Status;

%% Random Patterns



if ischar(measuringMatrix) %Verify if the measuring matrix was already provided
    measuringMatrix = create_measuring_matrix(measuringMatrix,nMeasures,imageH,imageV);
else
    tic
    for ii=1:size(measuringMatrix,1)
        aux{ii} = reshape(measuringMatrix(ii,:),imageV,imageH);
    end
    toc
    measuringMatrix = aux;
    % --- check the code below for correctness ---
    if size(measuringMatrix,1) ~= nMeasures + 2 %add two more random pattern (all ones and all zeros)
        measuringMatrix{nSamples+1}=ones(imageV,imageH);%????
        measuringMatrix{nSamples+2}=zeros(imageV,imageH);
    end
end

%% ---- DISPLAY RANDOM PATTERNS ----
%load in the workspace the pixelized version of numbers from 0-9
pixel_numbers;
tic

for ii = 1:nMeasures + 2
    if strcmpi(get(gcf,'CurrentCharacter'),'e');
        close;
        break;
    end
    for nn = 1:colorMode
        
        if colorMode == 3
            color = nn;
        else
            color = 0;
        end
        
        %% --- MAKE RANDOM PATTERN IMAGE ---
        projection = matrix2projection(screenH,screenV,measuringMatrix{ii},color);
        
        %% ---- PUT MEASUREMENT (FRAME) NUMBER IN BOTTOM RH CORNER ----
        
        
        
        unit = mod(ii,10);
        tens = 0;
        hundreds = 0;
        thousands = 0;
        if ii > 9;
            tens = floor(ii/10);
        end
        if ii > 99
            tens = mod(tens,10);
            hundreds = floor(ii/100);
        end
        if ii > 999
            hundreds = mod(hundreds,10);
            thousands = floor(ii/1000);
        end
        
        projection = circshift(projection,offsetV);
        projection = circshift(projection,[0 offsetH]);
        
        projection(end-24:end,1:15) = pixelNumbers{thousands+1};
        projection(end-24:end,21:35) = pixelNumbers{hundreds+1};
        projection(end-24:end,41:55) = pixelNumbers{tens+1};
        projection(end-24:end,61:75) = pixelNumbers{unit+1};
        
        projection = im2uint8(projection);
        
        %% ---- PROJECT PATTERN ONTO OBJECT ----
        fullscreen(projection,1); %Third party code for full screen display
        pause(.1123046875)
        if ii==1
            pause(.2)
        end
        fprintf(obj1,'trig'); % Trigger the read on the arduino by sending some junk (default format is %s\n)
        average=str2double(fscanf(obj1, '%s')); % maybe use string to double instead (average now taken on arduino)
        %% --- New method for frame number display ---
        %         tic
        %         hndlTxt = text(10,20,num2str(ii))
        %         hndlNumber = toc
        %         disp(['Time taken to write number = ',num2str(hndlNumber)])
        
        
        
        %% ----- OLD ARDUINO ACQUISITION ----
        %         if  arduinoFound == 1
        %             %b == 'open'
        %             %pause(.1)
        %             intensity = zeros(1,nSamples);
        %             %temp = 0;
        %             %tic
        %             for jj = 1:nSamples
        %                 %temp = fscanf(a, '%e');
        %                 %if temp(1) > 0;
        %                 %intensity(jj) = temp(1);
        %                 intensity(jj) = analogRead(a,0);
        %             end
        %             %end
        %             %toc
        %             % filter parameters
        %             treshold = 3;
        %             filteredIntensity = filter_data_projector(intensity,treshold);
        %
        %             if averageMode == 'mean'
        %                 average(nn) = mean(filteredIntensity);
        %             elseif averageMode == 'median'
        %                 average(nn) = median(filteredIntensity);
        %             elseif averageMode == 'mode'
        %                 average(nn) = mode(filteredIntensity);
        %             end
        %
        %         else
        %             average(nn) = 0;
        %             pause(1)
        %         end
        %pause(.1)
    end
    
    aux = measuringMatrix{ii};
    data(ii,:) = [aux(:)' average];
    
end % Loop over measurements

% Close Java window
closescreen();

% Disconnect from instrument object, obj1.
fclose(obj1);
delete(obj1);

T = toc;
disp(['average time per measurement = ',num2str(T/(nMeasures + 2))])

% delete(instrfind({'Port'},{'COM5'}));
% delete(instrfind('Type', 'serial'));
%save the workspace automaticaly as a backup
save('GUI_backup')

end

