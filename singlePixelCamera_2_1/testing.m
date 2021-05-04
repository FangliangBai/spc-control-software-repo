delete(instrfindall);

%s = serial('com5')

%set(s, 'InputBufferSize', 1024);
%set(s, 'FlowControl', 'none');
%set(s, 'BaudRate', 9600);
%set(s, 'Parity', 'none');
%set(s, 'StopBit', 1);
%set(s, 'Timeout', 4);

%fopen(s)
%s.Status
try
    %a = serial('COM6');
    a = arduino('COM3');
    arduinoFound = 1;
    
catch
    arduinoFound = 0;
end

%datalist = zeros(1,100);

  if  arduinoFound == 1
            %b == 'open'
            %pause(.1)
            intensity = zeros(1,100);
            %temp = 0;
            %tic 
            for jj = 1:100
                %temp = fscanf(a, '%e');
                %if temp(1) > 0;
                %intensity(jj) = temp(1);
                intensity(jj) = analogRead(a,0);
                end


%start = fscanf(s, '%e');

%for i = 1:length(datalist)
 %   temp = fscanf(s, '%e');
 %   if temp > 0 
 %      datalist(i) = temp(1);
 %   end
end

%fclose(a);