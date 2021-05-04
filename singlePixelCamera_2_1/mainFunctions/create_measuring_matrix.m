function measuringMatrix = create_measuring_matrix(type,nMeasures,imageH,imageV)

%Funciton to create the measuring matrix to be used with compressing
%sensing

%INPUT
%type - type of measuring matrices ('bernoulli,fixedBernoulli,rasterScan')
%imageH - number of horizontal pixels in the image
%imageH - number of vertical pixels in the image

%OUTPUT
%measuringMatrix - cell that has as each element a sampling matrix
%of size imageV X imageH

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
for ii=1:nMeasures +2 %two last patterns are a all one's all zero matrix
    
    if ii <= nMeasures
        
        switch type
            
            case 'bernoulli'
                  A = rand(imageV,imageH);
                  A(A<0.5)=0;
                  A(A>0.5)=1; 
% Generate Gaussian measurement matrix
% A = round(randn(imageV,imageH).*45+127);
% A(A<0)=0; A(A>255)=255; % Ensure pixel values are within 8 bit range
% A = A./255; % Scale data in range 0,1

% Generate uniform distribution measurement matrix
% a = 0; b = 255;
% A = round(a + (b-a).*rand(imageV,imageH));
% A = A./255;


                
            case 'bernoulliFixed'
                A = rand(imageV,imageH);
                aux = A(:);
                aux = sort(aux);
                treshold = aux(ceil(length(aux)/2));
                A(A>treshold)=1;
                A(A<=treshold)=0;
                
            case 'rasterScan'
                A = zeros(imageV,imageH);
                A(ii) = 1;
                
            case 'Haar' %future releases
                
        end
        
    elseif ii == nMeasures + 1
        A = ones(imageV,imageH);
    elseif ii == nMeasures + 2
        A = zeros(imageV,imageH);
    end
    
    measuringMatrix{ii} = A;
end

end
