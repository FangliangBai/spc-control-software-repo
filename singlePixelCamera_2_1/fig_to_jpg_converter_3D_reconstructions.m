%%Matlab program - fig2jpg
figdirectory = 'C:\Users\admin\My documents\MATLAB\3D_Recontructions\Scissors\Grayscale\Blocked shiny part'

fullpath = sprintf('%s/*.fig',figdirectory)
d = dir(fullpath);
length_d = length(d)
if(length_d == 0)
disp('couldnt read the directory details\n');
disp('check if your files are in correct directory\n');
end

startfig = 1
endfig = length_d

for i = startfig:endfig
fname = d(i).name;
fname_input = sprintf('%s/%s',figdirectory,fname)
fname_output = sprintf('%s/%s.jpg',figdirectory,fname)
saveas(openfig(fname_input),fname_output,'jpg');
end 