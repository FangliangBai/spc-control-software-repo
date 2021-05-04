%% Bit Numbers
for ii=1:10
    pixelNumbers{ii}=ones(5,3);
end
pixelNumbers{1}([7:9])=0;
pixelNumbers{2}([1:5,11:15])=0;
pixelNumbers{3}([2 7 9 14])=0;
pixelNumbers{4}([2 4 7 9])=0;
pixelNumbers{5}([4 5 6 7 9 10])=0;
pixelNumbers{6}([4 7 9 12])=0;
pixelNumbers{7}([6 7 9 11 12])=0;
pixelNumbers{8}([2 3 4 5 7 8 9 10])=0;
pixelNumbers{9}([7 9])=0;
pixelNumbers{10}([4 5 7 9 10])=0;

for ii=1:10
    pixelNumbers{ii}=imresize(pixelNumbers{ii},5,'nearest');
end