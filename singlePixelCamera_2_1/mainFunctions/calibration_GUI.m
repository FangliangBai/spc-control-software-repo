function varargout = calibration_GUI(varargin)
% CALIBRATION_GUI MATLAB code for calibration_GUI.fig
%      CALIBRATION_GUI, by itself, creates a new CALIBRATION_GUI or raises the existing
%      singleton*.
%
%      H = CALIBRATION_GUI returns the handle to a new CALIBRATION_GUI or the handle to
%      the existing singleton*.
%
%      CALIBRATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION_GUI.M with the given input arguments.
%
%      CALIBRATION_GUI('Property','Value',...) creates a new CALIBRATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibration_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibration_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibration_GUI

% Last Modified by GUIDE v2.5 28-Jan-2016 17:51:07
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @calibration_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @calibration_GUI_OutputFcn, ...
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


% --- Executes just before calibration_GUI is made visible.
function calibration_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibration_GUI (see VARARGIN)

% Choose default command line output for calibration_GUI
handles.output = hObject;

%load alligment parameters
calibrationData = load('calibrationData');
screenPercentage = calibrationData.screenPercentage;
screenH = screenPercentage(1);
screenV = screenPercentage(2);

%put the alligment parameters into the slider

set(handles.horizontal_slider,'Value',screenH);
set(handles.vertical_slider,'Value',screenV);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibration_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibration_GUI_OutputFcn(hObject, eventdata, handles)
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
% closescreen;
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
% closescreen;
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
% closescreen;
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
% closescreen;
fullscreen(projection,1);
h=gcf;
figure(h);

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

% --- Executes on slider movement.
function horizontal_slider_Callback(hObject, eventdata, handles)
% hObject    handle to horizontal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
load('calibrationData.mat');
screenV = get(handles.vertical_slider,'Value');
screenH = get(handles.horizontal_slider,'Value');
offsetH = offset(1);
offsetV = offset(2);
colorMode = 1;
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


% --- Executes on slider movement.
function vertical_slider_Callback(hObject, eventdata, handles)
% hObject    handle to horizontal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
load('calibrationData.mat');
screenV = get(handles.vertical_slider,'Value');
screenH = get(handles.horizontal_slider,'Value');
offsetH = offset(1);
offsetV = offset(2);
colorMode = 1;
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


% --- Executes during object creation, after setting all properties.
function horizontal_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizontal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function vertical_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizontal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closescreen;
close(gcf);
