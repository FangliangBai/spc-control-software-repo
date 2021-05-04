% Read in the reconstruction
% recon=openfig('L2 Recreation.fig');
file=input('Enter filename of image to be tested  ', 's'); 
recon=imread(file);
np=15; % number of pixels
% Crop the border
 crop=imcrop(recon);
% determine image size
[hite,width,depf]=size(crop);
% determine boarder size
wp=width/np; % width of each pixel
hp=hite/np; % width of each pixel
% determmine pixel values
pixels=zeros(np,np);
for row=1:np
    for col=1:np
        y=round((hp/2)+(hp*(row-1)));
        x=round(((wp/2)+(wp*(col-1))));
        pixels(row,col)=crop(y,x);
    end
end
% Plot pixel values
imshow(pixels/255, 'InitialMagnification', 2000);
pause(2);
% Read in the ideal image
ideal = dlmread('brightenedghosttext.txt', '\t'); % **CHANGE for different images**
% % Dummy image - cos' I dont have the real one
% dummy=ones(15,15)*125;
imshow(ideal/255, 'InitialMagnification', 2000);
% workout deviation from ideal x
x=(pixels-ideal).^2; % difference for the squares
X=sum(x(:));
Xn=X/np^2;
r=x./pixels.^2; % R-factor - same as Artemis
R=sum(r(:)); 
display(['Absolute squared-deviation from ideal = ', num2str(X)]); 
display(['Normalised deviation = ', num2str(Xn)]);
display(['R-factor = ', num2str(R)]);


