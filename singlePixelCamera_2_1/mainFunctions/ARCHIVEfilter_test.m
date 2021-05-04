
img=imread('mandrill.png');
vSize = 32;
hSize = 32;
h = fspecial('average', [vSize,hSize]);
filterImg=filter2(h, img(:,:,1));