% Script to determine detector linearity
% Triggered detector
% Dave & Stu
% v2 05/7/15
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.

% Declare some variables
clear, close all
n = 32; % image dimension (assume square image)
N = 32; % number of iterations
data = []; % somewhere to store the data
testImage = zeros(n);

%try connected port
path = pwd;
try
    portStruc = load([path,'\portName.mat']);
    name = portStruc.portName;
    obj1 = serial(name,'BaudRate', 115200);
    fopen(obj1);
    pause(2); % this pause is necessary to allow time for communication with the Arduino to be established
    identity = fscanf(obj1, '%s');
catch
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

% Communicating with instrument object, obj1.
% Collect some data
close all
figure
tic
% Communicating with instrument object, obj1.
whitePixelArray = zeros(1,N+1);
 for ii = 1:N+1
     zeroIndex = find(testImage==0);
     imshow(imresize(testImage,50,'nearest'))
     whitePixelArray(ii) = 1-length(zeroIndex)/n^2;
     title(['iteration ',num2str(ii),'. White pixels = ',num2str(whitePixelArray(ii)), '%']);
     drawnow
     pause(.25)
     fprintf(obj1,'trig'); % Trigger the read on the arduino by sending some shit (default format is %s\n)
     data(ii)=str2double(fscanf(obj1, '%s')); % maybe use string to double instead
     pause(.25)
     if ii<(N+1)
        testImage(zeroIndex(randperm(length(zeroIndex),(n^2)/N)))=1;
     end
 end
toc

% some old 
% fprintf(obj1,'shit'); % Trigger the read on the arduino by sending some shit (default format is %s\n)
% data1 = fscanf(obj1, '%s');
% display(data1);

% Disconnect from instrument object, obj1.
     fclose(obj1);
     delete(obj1);

% Plot the data and fit line
     p = polyfit([1:(N+1)],data,1); % fit straight line
     fit = polyval(p,[1:(N+1)]);
     plot([1:(N+1)], data,'*', [1:(N+1)], fit, 'r' );
     set(gca,'XTick',1:3:N+1);
     set(gca,'XTickLabel',round(100*whitePixelArray(1:3:N+1)));
     xlabel('Percentage of white pixels','FontSize',17);
     ylabel('Light intensity','FontSize',17);
     title('Saturation check for photodetector','FontSize',22);
     
     