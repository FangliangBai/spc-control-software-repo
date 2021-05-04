
imageH = 16;
imageV = 16;
waveletType = 'db3';
decomposition = 3;

waveletBasis = create_dictionary('wavelet',imageH,imageV,...
    waveletType,decomposition);

dctBasis = create_dictionary('DCT',imageH,imageV,...
    waveletType,decomposition);

testImage = imread('C:\Users\admin\Desktop\CS_GUI\index.jpeg');
testImage = rgb2gray(testImage);
testImage = double(testImage);

imageResize = imresize(testImage,[imageV imageH],'cubic');
canonicalCoeficients = imageResize(:);

waveletCoeficients = waveletBasis' * canonicalCoeficients(:);
waveletCoeficients = abs(waveletCoeficients);

DCTCoeficients = dctBasis' * canonicalCoeficients(:);
DCTCoeficients = abs(DCTCoeficients);

semilogy(sort(canonicalCoeficients,'descend'))
hold on
semilogy(sort(DCTCoeficients,'descend'),'r')
semilogy(sort(waveletCoeficients,'descend'),'g')

% plot(sort(canonicalCoeficients,'descend'))
% hold on
% plot(sort(DCTCoeficients,'descend'),'r')
% plot(sort(waveletCoeficients,'descend'),'g')