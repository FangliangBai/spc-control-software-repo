% Random Patterns with Lookup Table.
% Adam Luck, 15/08/14
% Editted and working 26/8/14

clear all; clc; close all;

%---SET PARAMETERS---
greyRGB = 1; % grey scale = 1, RGB = 3.
numSamp = 100; % Number of samples per pattern
brightScale = .9;
imDim = 18;
numPat = imDim^2 + 100 ; % Number of random patterns
scrnSize = get(0,'ScreenSize');
imSize = [.52*scrnSize(4) .51*scrnSize(4)];%50; %110;% Size of display image
M = round(3/4*(imDim^2))-1;

%---READ CALIBRATION MATRIX---
%load(['E:\ghostCalibrationData',num2str(imDim),'x',num2str(imDim)],'pixCal')

% Read calibration file
% load('E:\ghostCalibrationData','pixCal')
% calib = dlmread('calib.txt')';
% calibm = reshape(calib,imDim,imDim);
% Matrix Size = n
% A = (-1+(2)*rand(4))>0;

a = arduino('COM5');
tic
for ii = 1:numPat+2
    %---GENERATE RANDOM PATTERN---
    A = ones(imDim,imDim);
%     A(A<0.5)=0;
%     A(A>0.5)=1;
%      A(ii)=1;
%     for jj=1:imDim
%         A(jj,jj)=1
%         A(jj,imDim-(jj-1))=1;
%     end
    position = ceil(imDim^2*rand(1));
    for kk = 1:(imDim^2)/2
        A(position) = 0;
        allPosition = find(A(:)>0);
        position = allPosition(ceil((imDim^2-kk)*rand(1)));
    end
    
    if ii==numPat+1
        A=ones(imDim,imDim);
    elseif ii==numPat+2;
        A=zeros(imDim,imDim);
    end
        
    %---DISPLAY PATTERN---
    for nn = 1:greyRGB
        B = zeros(imDim,imDim,greyRGB);
        B(:,:,nn) = A;
        C = zeros(scrnSize(4),scrnSize(3),greyRGB);
        hSpace = floor((scrnSize(4)-imSize(1))/2);
        wSpace = floor((scrnSize(3)-imSize(2))/2);
        C([hSpace:(hSpace+imSize(1)-1)],[wSpace:(wSpace+imSize(2)-1)],:) = imresize(B.*brightScale,imSize,'nearest');
        fullscreen(C,1); %Third party code for full screen display
        %---RECORD AVERAGE REFLECTED LIGHT INTENSITY---
        id = ii;
        for jj = 1:numSamp
            Intensity(jj,nn) = analogRead(a,0);
        end
        pause(.1)
        %closescreen();% Uncomment to for CTRL+C loop break
    end %kk
    
    average = median(Intensity);
    data(ii,:) = [id A(:)' average];% Each row = random pattern and photodiode reading
    datashort(ii,:) = [id average];
    
end
closescreen();% Third party code for full screen display


delete(instrfind({'Port'},{'COM5'}));
delete(instrfind('Type', 'serial'));
toc
%---LOOK-UP TABLE---
% luptab = dlmread('C:\Users\admin\Desktop\University of Kent\University of Kent\MATLAB\Gray Scale\lookup.txt', '\t');
% xdata = luptab(:,2);
% ydata = luptab(:,1);
% datashort(:,2) = interp1(xdata,ydata,datashort(:,2),'spline')
% data(:,end) = datashort(:,2)

%---DATA VALIDATION TEST---
% I = [0 0 1 1 0 0 1 1 1 1 0 0 1 1 0 0]'; % Input image
% %I = ones(1,16)
% innerProds = data(:,[2:end-1])*I;
% figure
% plot(innerProds,datashort(:,2),'b.')

%---DEBUG---
% temp = data(:,[2:end-1]);
% disp('Press any key to run error check')
% pause
% for ii = 1:numPat
%     figure
%     AtimesI = [temp(ii,:)'].*I;
%     AtimesI = reshape(AtimesI,4,4)
%     B = imresize(AtimesI,imSize,'nearest');
%     imshow(B,[])
%     set(gcf,'name',['Pattern No = ',num2str(ii),', Voltage = ',num2str(datashort(ii,end))])
%     pause
% end

%---TEST RECONSTRUCTION---

pause(1)
% figHndl_2 = figure
% I_recon = zeros(imDim,imDim)
% for ii = 1:numPat
%     c = data(ii,end);
%     A = reshape(data(ii,[2:end-1])',imDim,imDim);
%     I_recon = I_recon + c.*A%./calibm;
%     B = imresize(I_recon,imSize,'nearest');
%     imshow(B,[])
%     set(figHndl_2,'name',num2str(ii))
%     pause(.01)
% end

%%
%---DCT BASIS TEST---
figure
clear PSI
psi = NpntDCT(imDim)';
count = 0;
m = size(psi,2);
for ii = 1:m
    for jj = 1:m
        count = count+1;
%         subplot(m,m,count),xlabel(num2str(count))
        basisIm = psi(:,ii)*psi(:,jj)';
%         imshow(imresize(basisIm,[20 20],'nearest'),[])
        PSI(:,count) = basisIm(:);
    end
end

% %---LEAST SQUARES IMAGE RECONSTRUCTION---
%Note: SJG to simplify code by removing if statement.
figHndl_3 = figure;
set(figHndl_3,'name','Least squares reconstruction')
Itest = zeros(imDim,imDim,greyRGB);
for nn = 1:greyRGB
    %R = data(:,[2:end-greyRGB])';
    %c = data(:,end-greyRGB+nn);
    R = data(1:end-2,[2:end-greyRGB])';
    c = data(1:end-2,end-greyRGB+nn);
 
    A=R';
    s2=pinv(A)*c;
    I = s2;
    Itest(:,:,nn)=reshape(I',imDim,imDim);
end
figure
imshow(imresize(Itest,imSize,'nearest'),[])


for nn = 1:greyRGB
    %R = data(:,[2:end-greyRGB])';
    %c = data(:,end-greyRGB+nn);
    R = data(1:M,[2:end-greyRGB])';
    c = data(1:M,end-greyRGB+nn);
    A=R'*PSI;
    s2=pinv(A)*c;
    I = PSI*s2;
    Itest(:,:,nn)=reshape(I',imDim,imDim);
end

%---SPARSE SOLUTION---
figHndl_4 = figure;
set(figHndl_4,'name','Sparse solution')
Itest = zeros(imDim,imDim,greyRGB);
%k = 64; %Sparsity
    %M = round(numPat); %Number of measurements


figHndl_4=figure;
for kk = M:1:M
    for nn = 1:greyRGB
        R = data(1:M,[2:end-greyRGB])';
        c = data(1:M,end-greyRGB+nn);
        A = R';
        s = OMP(A,c,kk);
        I = s;
        %I = ((inv(R*R'))*R*c);
        Itest(:,:,nn)=reshape(I,imDim,imDim);
    end
    error = sum((c-A*s).^2) 
    subplot(1,2,1),imshow(imresize(Itest,imSize,'nearest'),[])
    subplot(1,2,2),plot(s),
    if kk==1
        xlabel('Dictionary atom'),ylabel('coefficient')
    end
    set(figHndl_4,'name',['Sparse solution, k = ',num2str(kk)])
    pause(0.1)
end

%%%%L1 magic solution
sigma = 0.6;
epsilon =  sigma*sqrt(M)*sqrt(1 + 2*sqrt(2)/sqrt(M));
epsilon = 0.0001;
figure
for nn = 1:greyRGB
    R = data(1:M,[2:end-greyRGB])';
    c = data(1:M,end-greyRGB+nn);
    c = c - data(end,end);
    c = c/data(end-1,end);
    A = R';
    s_l1qc = l1qc_logbarrier(s2, A, [], c,epsilon, 1e-3);
    s_tveq =  tvdantzig_logbarrier(s2, A, [], c,epsilon, 1e-3, 5, 1e-8, 1500);
    I_l1qc = s_l1qc;
    I_tveq = s_tveq;
    Itest_l1qc(:,:,nn)=reshape(I_l1qc,imDim,imDim);
    Itest_tveq(:,:,nn)=reshape(I_tveq,imDim,imDim);
end
% I_l1qc = reshape(Itest_l1qc,imDim,[]);
% I_tveq = reshape(Itest_tveq,imDim,[]);
subplot(1,2,1),imshow(imresize(Itest_l1qc(:,:,2),imSize,'nearest'),[]), xlabel('L1 with quad const')
subplot(1,2,2),imshow(imresize(Itest_tveq.^2/max(max(max(Itest_tveq.^2))),imSize,'nearest'),[]), xlabel('L1 TV const')



% I = PSI* s_tveq;
% I_l1tveq = reshape(I,imDim,[]);
% figure
% imshow(imresize(I_l1tveq,imSize,'nearest'),[])

% s_l1tvqc =  tvqc_logbarrier(s2, A, [], c, 1, 1e-3, 5, 1e-8, 200);
% I = PSI* s_l1tvqc;
% I_l1tvqc = reshape(I,imDim,[]);
% figure
% imshow(imresize(I_l1tvqc,imSize,'nearest'),[])
% 
% 
