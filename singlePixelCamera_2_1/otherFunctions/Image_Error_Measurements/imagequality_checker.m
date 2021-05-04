function imagequality_checker

%% Preset
% get imageV and imageH
try
    gui_backup = load('GUI_backup.mat');
    imageV = gui_backup.imageV;
    imageH = gui_backup.imageH;
catch
    disp('can not find GUI_ backup file, please initialize measurement value from toolbox');
    return;
end
% load original image
disp('Please load original image');
[FileName,PathName] = uigetfile('*.*','Select original image');
addpath(PathName);
image1 = imread(FileName);
% trim original image
try
    img1 = imresize(image1,[imageV,imageH]); 
catch
end
try
    img1 = rgb2gray(img1);
catch
end
try
    img1 = im2double(img1); 
catch
end
% load reconstructed rmage
disp('Please load reconstructed image');
[FileName,PathName] = uigetfile('*.*','Select original image');
addpath(PathName);
image2 = imread(FileName);
% trim reconstructed image
try
    img2 = imresize(image2,[imageV,imageH]); 
catch
end
try
    img2 = rgb2gray(img2);
catch
end
try
    img2 = im2double(img2); 
catch
end

%% Process
%calculate image quality index
index = imageQualityIndex(img1,img2);
index = index*100;
index =num2str(index);

%show two figures
imagePlot(image1,1,2,1,'Original Image');
imagePlot(image2,1,2,2,['Reconstructed Image (Quality:',index,'%)']);








end