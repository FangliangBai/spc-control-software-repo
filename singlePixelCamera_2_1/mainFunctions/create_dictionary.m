function basis = create_dictionary(dictionaryType,imageH,imageV,...
    waveletType,decomposition)

%Funciton to create dctionaries to be used with CS

%dictionaryType - type of dictionary to be used (canonical, DCT, wavelet)
%imageH - number of horizontal pixels in the image 
%imageH - number of vertical pixels in the image 
%waveletType - String with the name of the wavelet to be used
%Decomposition - Level of wavelet decomposition

%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.

switch dictionaryType
    
    case 'canonical'
        
        basis = eye(imageV*imageH);
        
    case 'DCT'
        
        % For M-point transformation.
        M = imageV;
        N = imageH;
        
        j = [0:M-1]'*ones(1,M);
        alpha = sqrt(2/M).*ones(M,M);
        alpha(1,:) = alpha(1,:)./sqrt(2);
        m = j';
        D_transpose = cos(((2.*m+ones(M,M)).*j).*pi./(2*M)).*alpha;
        Dm = D_transpose';
        
        % For N-point transformation.
        k = [0:N-1]'*ones(1,N);
        beta = sqrt(2/N).*ones(N,N);
        beta(1,:) = beta(1,:)./sqrt(2);
        n = k';
        D_transpose = cos(((2.*n+ones(N,N)).*k).*pi./(2*N)).*beta;
        Dn = D_transpose';
        count = 0;
        
        for mm = 1:M
            for nn = 1:N
                count = count+1;
                aux = Dm(:,mm)*(Dn(:,nn))';
                basis(:,count) = aux(:);
            end
        end
        
        
    case 'wavelet'
        
        for ii = 1:imageH * imageV
            aux = zeros(imageV,imageH);
            aux(ii) = 1;
            [basis(:,ii),s] = wavedec2(aux,decomposition,waveletType);          
        end
        basis = basis';
        
% Proof that this dictionary perform a wavelet decomposition
%         
%                signal = rand(imageV,imageH);
%         
%                a = wavedec2(signal,decomposition,waveletType);
%                b = basis * signal(:);
%         
%                maxError = max(abs(a-b));
%         
%Plot of the wavelet Basis        
%         count = 1;        
%         for ii=1:imageH
%             for jj = 1: imageV
%                 
%             teste = basis(:,count);
%             teste = reshape(teste,imageV,imageH);
%             subplot(imageV,imageH,count)
%             imshow(teste,[])
%             count = count + 1;
%             end
%         end
%         
        
end
