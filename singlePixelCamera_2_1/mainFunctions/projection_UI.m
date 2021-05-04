function varargout = projection_UI(varargin)
% PROJECTION_UI MATLAB code for projection_UI.fig
%      PROJECTION_UI, by itself, creates a new PROJECTION_UI or raises the existing
%      singleton*.
%
%      H = PROJECTION_UI returns the handle to a new PROJECTION_UI or the handle to
%      the existing singleton*.
%
%      PROJECTION_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTION_UI.M with the given input arguments.
%
%      PROJECTION_UI('Property','Value',...) creates a new PROJECTION_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projection_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projection_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projection_UI

% Last Modified by GUIDE v2.5 14-Aug-2015 12:46:37
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projection_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @projection_UI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before projection_UI is made visible.
function projection_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projection_UI (see VARARGIN)

% Choose default command line output for projection_UI
handles.output = hObject;

%load alligment parameters
calibrationData = load('calibrationData');
screenPercentage = calibrationData.screenPercentage;
screenH = screenPercentage(1);
screenV = screenPercentage(2);

%put the alligment parameters into the edit boxes
set(handles.edit_horizontal,'String',screenH)
set(handles.edit_vertical,'String',screenV)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projection_UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projection_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_up.
function push_up_Callback(hObject, eventdata, handles)
% hObject    handle to push_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calibrationData.mat');
val = str2double(get(handles.edit_value,'String'));
[projection, offset] = calibration_shift(projection,'up',val,offset);
save('calibrationData','projection','offset','screenPercentage','calibrationMatrix')
closescreen;
fullscreen(projection,1);
h=gcf;
figure(h);


% --- Executes on button press in push_left.
function push_left_Callback(hObject, eventdata, handles)
% hObject    handle to push_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calibrationData.mat');
val = str2double(get(handles.edit_value,'String'));
[projection, offset] = calibration_shift(projection,'left',val,offset);
save('calibrationData','projection','offset','screenPercentage','calibrationMatrix')
closescreen;
fullscreen(projection,1);
h=gcf;
figure(h);


% --- Executes on button press in push_right.
function push_right_Callback(hObject, eventdata, handles)
% hObject    handle to push_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calibrationData.mat');
val = str2double(get(handles.edit_value,'String'));
[projection, offset] = calibration_shift(projection,'right',val,offset);
save('calibrationData','projection','offset','screenPercentage','calibrationMatrix')
closescreen;
fullscreen(projection,1);
h=gcf;
figure(h);


% --- Executes on button press in push_down.
function push_down_Callback(hObject, eventdata, handles)
% hObject    handle to push_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calibrationData.mat');
val = str2double(get(handles.edit_value,'String'));
[projection, offset] = calibration_shift(projection,'down',val,offset);
save('calibrationData','projection','offset','screenPercentage','calibrationMatrix')
closescreen;
fullscreen(projection,1);
h=gcf;
figure(h);


function edit_value_Callback(hObject, eventdata, handles)
% hObject    handle to edit_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_value as text
%        str2double(get(hObject,'String')) returns contents of edit_value as a double


% --- Executes during object creation, after setting all properties.
function edit_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_vertical_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vertical as text
%        str2double(get(hObject,'String')) returns contents of edit_vertical as a double


% --- Executes during object creation, after setting all properties.
function edit_vertical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_horizontal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_horizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_horizontal as text
%        str2double(get(hObject,'String')) returns contents of edit_horizontal as a double


% --- Executes during object creation, after setting all properties.
function edit_horizontal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_horizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_scale.
function push_scale_Callback(hObject, eventdata, handles)
% hObject    handle to push_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('calibrationData.mat');

screenV = str2double(get(handles.edit_vertical,'String'));
screenH = str2double(get(handles.edit_horizontal,'String'));
offsetH = offset(1);
offsetV = offset(2);
colorMode = 1
screenPercentage = [screenH, screenV];

projection = matrix2projection(screenH,screenV,calibrationMatrix,colorMode);

projection = circshift(projection,offsetV);
projection = circshift(projection,[0 offsetH]);

projection = im2uint8(projection);

save('calibrationData','projection','offset','screenPercentage','calibrationMatrix')

closescreen;
fullscreen(projection,1);
% get calibration GUI handles
h=gcf;
%put figure in the first plane
figure(h);
