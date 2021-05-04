% serial analogue read from arduino with no avergering
% v1 1/9/2014
clear all; clc; close all;
numMeas = 20; % Numer of measurements
a = arduino('COM7'); % open port
tic
for i = 1:1:numMeas
data(i) = analogRead(a,0);
%pause(0.1);
end
toc
% close port
delete(instrfind({'Port'},{'COM7'}));
delete(instrfind('Type', 'serial'));
% calculate mean and sdev
average = mean(data);
med = median(data);
stdev=std(data);
upper=average+stdev; % calculate upper limit for good data
good=find(data<upper); % find good data
bad=find(data>upper); % find bad data
data_good=data(good); % extract good data
new_mean=mean(data_good); % new average
new_sd=std(data_good); % new sd
% display outputs
display(data);
display(average);
display(med);
display(stdev);
display(new_mean);
display(new_sd);
display(length(bad));

