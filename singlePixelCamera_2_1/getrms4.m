%function [RMS]=getrms(pixelx, pixely)
clear all,
close all,
%%%%%truth image%%%%%

S=imread('Ghost15x15.png');
T=imresize(S,[15,15]);
% imshow(T)
%%%%% reconstructions %%%%%%%%
dirInfo = dir('C:\Users\Cameron\Documents\MATLAB\singlePixelCamera\MATLAB figures converted to bitmap\L2\*.jpg');
%adjustpath to folder with images
%can use fig to jpg converter if not in correct format
l=length(dirInfo); 

figure;
hold on;
subplot(4,ceil(l/2),floor(l/4));
imshow(T);


for ii =1:l

out=regexp(dirInfo(ii).name, '\d+', 'match');
D(ii)=str2double(cat(1,out(2)));    
    
    
A{ii}=imread(dirInfo(ii).name);
B{ii}=imcrop(A{ii},[86,31,294,294]);
% figure;
% imshow(A{ii})
% hold on
%  imshow(B{ii})
% hold off
C{ii}=imresize(B{ii},[15,15]);

aii=subplot(4,ceil(l/2),ii+ceil(l/2));
imshow(C{ii}); 
title(D(ii));
F=C{ii}(:,:,1);
T=(T(:,:,1));
% size(F(:))
% size(T(:))
R(ii)=sqrt(mean(F(:)-T(:).^2));

xlabel(R(ii));
disp(['RMS value for ' num2str(D(ii)) ' measurements is ' num2str(R(ii))]); 
end

hold off;

figure;
plot(D,R,'r*-');
ylabel('RMS value')
xlabel('Number of Measurements') %need to read this from filename

