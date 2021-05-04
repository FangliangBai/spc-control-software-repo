imageH = 16;
imageV = 16;
originalImageSize = 512;
aux = originalImageSize/imageH;
waveletType = 'db3';
decomposition = 3;

waveletBasis = create_dictionary('wavelet',imageH,imageV,...
    waveletType,decomposition);

dctBasis = create_dictionary('DCT',imageH,imageV,...
    waveletType,decomposition);

%% Original
testImage = imread('mandrill.png');
testImage = rgb2gray(testImage);
testImage = double(testImage);
%% Pixel Lines
linesImage = testImage;
for ii=1:originalImageSize
    if mod(ii,aux) == 0
        linesImage(ii,:) = 0;
        linesImage(:,ii) = 0;
    end
end
%% Pixel Lines
linesPixelImage = pixelImageBig;
for ii=1:originalImageSize
    if mod(ii,aux) == 0
        linesPixelImage(ii,:) = 0;
        linesPixelImage(:,ii) = 0;
    end
end

%% Raster Scan
for ii = 1 : 5
    rasterImageAux = zeros(originalImageSize,originalImageSize);
    rasterImageAux(1:aux,(ii-1)*aux+1:aux*ii) = 1;
    rasterImage{ii} = rasterImageAux .* testImage;
end

%% Pixelated Image

pixelImage = imresize(testImage,[imageV imageH],'cubic');
pixelImage1D = pixelImage(:);
pixelImageBig = imresize(pixelImage,[originalImageSize originalImageSize],'nearest');
pixelImage1DBig = imresize(pixelImage1D,[imageV*originalImageSize imageV],'nearest');


%% Random Measurements

for kk = 1:5
    randomMeasures = rand(imageV);
    randomMeasures(randomMeasures < 0.5) = 0;
    randomMeasures(randomMeasures > 0.5) = 1;
    randomMeasuresImageAux = zeros(originalImageSize,originalImageSize);
    for ii = 1:imageV
        for jj = 1:imageV
            if randomMeasures(ii,jj) == 1
                randomMeasuresImageAux((ii-1)*aux+1:aux*ii,(jj-1)*aux+1:aux*jj)=1;
            end
        end
    end
    
    randomMeasuresImage{kk} = randomMeasuresImageAux .* testImage;
end

%% DCT and wavelet Coefficients
canonicalCoeficients = pixelImage(:);
waveletCoeficients = waveletBasis' * canonicalCoeficients(:);
waveletCoeficients = abs(waveletCoeficients);

DCTCoeficients = dctBasis' * canonicalCoeficients(:);
DCTCoeficients = abs(DCTCoeficients);
%% Plot coefficients
canonicalPlot=semilogy(sort(canonicalCoeficients,'descend'));
hold on
waveletPlot=semilogy(sort(waveletCoeficients,'descend'));

set(waveletPlot , ...
  'LineWidth'       , 3 , ... 
  'Color' , [.6 .2 .2]);

set(canonicalPlot , ...
  'LineWidth'       ,3 , ... 
  'Color' , [.1 .3 .6]);

hXLabel = xlabel('Coefficient indice' );
hYLabel = ylabel('Magnitude' );

hLegend = legend( ...
  [canonicalPlot, waveletPlot(1)], ...
  'Canonical Basis' , ...
  'Wavelet Basis' );

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');
set([hLegend, gca]             , ...
    'FontSize'   , 10           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );


%%
imagesc(randomMeasuresImage{1})
set(findobj(gcf, 'type','axes'), 'Visible','off')
axis square
colormap('gray')

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 finalPlot1.pdf
close;