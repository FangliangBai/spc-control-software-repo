function reconstruction = CS_reconstruction(data_matrix,basis,imageH,imageV,...
    recoveryMethod,colorMode,epsilon,removeDC,sparcity,calibrationMatrix)

%Funciton to reconstruct the original image using CS algorithms

%data_matrix - matrix that holds the random sampling patterns (columns 1 to end-1)
% and the luminosity samples (last column)
%basis - a basis of a N vector space, where N is the size of the image
%imageH - number of horizontal pixels in the image
%imageH - number of vertical pixels in the image
%recoveryMethod - Which type of recovering algorithm to be used
%colorMode - 1 for gray scale images 3 for RGB images
%episilon - error parameter for some of the reconstructing algorithms
%removeDC - Remove DC term of the measurements ( subtract dark frame)
%sparcity - sparcity parameter for the BP algorithm

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
%default padding mode for wavelet decomposition
dwtmode('per')

PSI = basis;
%l-2 reconstruction
for nn = 1:colorMode
    
    if removeDC
        PHI = data_matrix(1:end-2,1:end-colorMode);
        y = data_matrix(1:end-2,end-colorMode+nn);
        % normalizing the values of the measurements
        y = y - data_matrix(end,end); %DC Ofsset
    else
        PHI = data_matrix(1:end,1:end-colorMode);
        y = data_matrix(1:end,end-colorMode+nn);
    end
    
    
    A = PHI*PSI;
    
    % initial solution
    x0=pinv(A)*y; % min L2 norm
    %     x0 = A\c; %min L0 norm computational expensive)
    %     x0 = A'*c % No special propertie. Fastest to calculate
    
    switch recoveryMethod % from l1magic toolbox
        
        case 'l1MinEquality'
            xp = l1eq_pd(x0, A, [], y, 1e-3);
            
        case 'l1MinQuadratic'
            
            xp = l1qc_logbarrier(x0, A, [], y, epsilon, 1e-3);
            
        case 'l1MinDantzig'
            xp = l1dantzig_pd(x0, A, [], y, epsilon, 5e-2);
            
        case 'tvMinEquality'
            
            xp =  tveq_logbarrier(x0, A, [], y, 1e-3, 5, 1e-8, 200,imageH,imageV);
            
        case 'tvMinQuadratic'
            
            xp =  tvqc_logbarrier(imageH,imageV, x0, A, [], y, epsilon, 1e-4, 2);
            
        case 'tvMinDantzig'
            
            xp =  tvdantzig_logbarrier(x0, A, [],y, epsilon, 1e-3, 5, 1e-8, 1500,imageH,imageV);
            
        case 'BP'
            xp = OMP(A,y,sparcity);
            
        case 'l2Min'
            xp = x0;
            
    end
    %estimated image
    estIm = PSI*xp;
    
    % Normalisation
    estIm = (estIm-min(min(estIm))) / (max(max(estIm))-min(min(estIm)));
    
    reconstruction(:,:,nn) = reshape(estIm,imageV,imageH);
    % Making the image bigger
    reconstructionBig(:,:,nn) = imresize(reconstruction(:,:,nn),[300,300],'nearest');
end

if ~isempty(calibrationMatrix)
    %as just light calibration data
    calibrationMatrix = imresize(calibrationMatrix,[300,300],'nearest');
    blocks=blkproc(calibrationMatrix,[150 150],@CS_estibackground);
    background=imresize(blocks,[300 300],'bicubic');
    
    background = 0.4.*background;
    calibrated=imsubtract(reconstructionBig,background./(background+reconstructionBig));
    reconstructionBig=imadjust(calibrated,[0 max(max(calibrated))],[0 1]);
    
end
%show results
figure
imshow(reconstructionBig)


% sparsity test
% name = ['200_225_Canonical/200_225_',int2str(sparcity),'.mat'];
% save(name,'reconstructionBig');
end
