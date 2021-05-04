function varargout = single_pixel_camera(varargin)
%Version 1.0
%Author: Pedro Dreyer University of Kent 22/11/14
%Copyright (C) 2016  Stuart Gibson. Please find detail of license in root folder.
%SINGLE_PIXEL_CAMERA M-file for single_pixel_camera.fig
%      SINGLE_PIXEL_CAMERA, by itself, creates a new SINGLE_PIXEL_CAMERA or raises the existing
%      singleton*.
%
%      H = SINGLE_PIXEL_CAMERA returns the handle to a new SINGLE_PIXEL_CAMERA or the handle to
%      the existing singleton*.
%
%      SINGLE_PIXEL_CAMERA('Property','Value',...) creates a new SINGLE_PIXEL_CAMERA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to single_pixel_camera_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SINGLE_PIXEL_CAMERA('CALLBACK') and SINGLE_PIXEL_CAMERA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SINGLE_PIXEL_CAMERA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to push_projection (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help single_pixel_camera

% Last Modified by GUIDE v2.5 29-Jan-2016 17:27:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @single_pixel_camera_OpeningFcn, ...
    'gui_OutputFcn',  @single_pixel_camera_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before single_pixel_camera is made visible.
function single_pixel_camera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for single_pixel_camera
handles.output = hObject;

%load up allignment settings 
calibrationData = load('calibrationData');
offset = calibrationData.offset;
offsetH = offset(1);
offsetV = offset(2);
screenPercentage = calibrationData.screenPercentage;
screenH = screenPercentage(1);
screenV = screenPercentage(2);
%set values in the edit box
set(handles.edit_offset_h,'String',offsetH)
set(handles.edit_offset_v,'String',offsetV)
set(handles.edit_projection_h,'String',screenH)
set(handles.edit_projection_v,'String',screenV)

handles.screenPercentage = calibrationData.screenPercentage;

%load default settings 
handles.averageMode = 'mean';
handles.colorMode = 1;
handles.removeDC = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_pixel_camera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = single_pixel_camera_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_basis_wavelet_type_Callback(hObject, eventdata, handles)
% hObject    handle to edit_basis_wavelet_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_basis_wavelet_type as text
%        str2double(get(hObject,'String')) returns contents of edit_basis_wavelet_type as a double


% --- Executes during object creation, after setting all properties.
function edit_basis_wavelet_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_basis_wavelet_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_basis_wavelet_decomposition_Callback(hObject, eventdata, handles)
% hObject    handle to edit_basis_wavelet_decomposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_basis_wavelet_decomposition as text
%        str2double(get(hObject,'String')) returns contents of edit_basis_wavelet_decomposition as a double


% --- Executes during object creation, after setting all properties.
function edit_basis_wavelet_decomposition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_basis_wavelet_decomposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_basis_load.
function push_basis_load_Callback(hObject, eventdata, handles)
% hObject    handle to push_basis_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName] = uigetfile;

if ~isequal(fileName,0) || ~isequal(pathName,0)
    
    struct = load(fullfile(pathName, fileName));
    field = fieldnames(struct);
    basis = getfield(struct,field{1});
    
    set(handles.text_basis_load,'String','Dictionary Selected')
    set(handles.text_basis_load,'ForegroundColor',[0 0.5 0])
    
    handles.basis = basis;
    
    guidata(hObject,handles);
    
end


% --- Executes on button press in push_load_measuring_matrix.
function push_load_measuring_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to push_load_measuring_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName] = uigetfile;

if ~isequal(fileName,0) || ~isequal(pathName,0)
    
    struct = load(fullfile(pathName, fileName));
    field = fieldnames(struct);
    measuringMatrix = getfield(struct,field{1});
    
    set(handles.text_measure_load,'String','Matrix Selected')
    set(handles.text_measure_load,'ForegroundColor',[0 0.5 0])
    
    handles.measuringMatrix = measuringMatrix;
    
    guidata(hObject,handles);
    
end

function edit_epsilon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epsilon as text
%        str2double(get(hObject,'String')) returns contents of edit_epsilon as a double


% --- Executes during object creation, after setting all properties.
function edit_epsilon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_noise_magnitude_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise_magnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise_magnitude as text
%        str2double(get(hObject,'String')) returns contents of edit_noise_magnitude as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_magnitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise_magnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_noise_type.
function pop_noise_type_Callback(hObject, eventdata, handles)
% hObject    handle to pop_noise_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_noise_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_noise_type


% --- Executes during object creation, after setting all properties.
function pop_noise_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_noise_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_flat_field.
function push_flat_field_Callback(hObject, eventdata, handles)
% hObject    handle to push_flat_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load values 
averageMode = handles.averageMode;
imageH = str2double(get(handles.edit_image_size_h,'String'));
imageV = str2double(get(handles.edit_image_size_v,'String'));
screenH = str2double(get(handles.edit_projection_h,'String'));
screenV = str2double(get(handles.edit_projection_v,'String'));
offsetH = str2double(get(handles.edit_offset_h,'String'));
offsetV = str2double(get(handles.edit_offset_v,'String'));
colorMode = str2double(get(handles.edit_offset_v,'String'));
nSamples = str2double(get(handles.edit_experiment_samples,'String'));
measuringMatrix ='rasterScan';
nMeasures = imageH * imageV;
calibrationMatrix = ones(imageV,imageH);

data = CS_data_projector(nSamples,nMeasures,imageH,imageV,screenH,screenV,...
    measuringMatrix,colorMode,offsetH,offsetV,calibrationMatrix,averageMode);

for nn = 1:colorMode
    aux = data(:,end-colorMode+nn);
    groundValue = median(aux); %median
    calibration = groundValue./aux;
    calibrationMatrix(:,:,nn) = reshape(calibration,imageV,imageH);
end
uisave('calibrationMatrix')



% --- Executes on button press in push_adjust.
function push_adjust_Callback(hObject, eventdata, handles)
% hObject    handle to push_adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageH = str2double(get(handles.edit_image_size_h,'String'));
imageV = str2double(get(handles.edit_image_size_v,'String'));
screenH = str2double(get(handles.edit_projection_h,'String'));
screenV = str2double(get(handles.edit_projection_v,'String'));
offsetH = str2double(get(handles.edit_offset_h,'String'));
offsetV = str2double(get(handles.edit_offset_v,'String'));

CS_projector_calibration(imageH,imageV,screenH,screenV,offsetH,offsetV)

calibrationData = load('calibrationData.mat');
projection = calibrationData.projection;
offset = calibrationData.offset;
screenPercentage = calibrationData.screenPercentage;

set(handles.edit_projection_h,'String',num2str(screenPercentage(1)));
set(handles.edit_projection_v,'String',num2str(screenPercentage(2)));
set(handles.edit_offset_h,'String',num2str(offset(1)));
set(handles.edit_offset_v,'String',num2str(offset(2)));
closescreen

function edit_projection_v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_projection_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_projection_v as text
%        str2double(get(hObject,'String')) returns contents of edit_projection_v as a double

% Make the projected pixels to have a square size
if get(handles.check_square_screen,'Value')
    projectionV = str2double(get(hObject,'String'));
    screen = get(0,'ScreenSize');
    screenH = screen(3);
    screenV = screen(4);
    projectionH = projectionV * screenH/screenV;
    projectionH = num2str(projectionH);
    set(handles.edit_projection_h,'String',projectionH)
end

% --- Executes during object creation, after setting all properties.
function edit_projection_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_projection_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_projection_h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_projection_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_projection_h as text
%        str2double(get(hObject,'String')) returns contents of edit_projection_h as a double

% Make the projected pixels to have a square size
if get(handles.check_square_screen,'Value')
    projectionH = str2double(get(hObject,'String'));
    screen = get(0,'ScreenSize');
    screenH = screen(3);
    screenV = screen(4);
    projectionV = projectionH * screenV/screenH;
    projectionV = num2str(projectionV);
    set(handles.edit_projection_v,'String',projectionV)
end

% --- Executes during object creation, after setting all properties.
function edit_projection_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_projection_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_image_size_h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_image_size_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_image_size_h as text
%        str2double(get(hObject,'String')) returns contents of edit_image_size_h as a double


% --- Executes during object creation, after setting all properties.
function edit_image_size_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_image_size_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_image_size_v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_image_size_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_image_size_v as text
%        str2double(get(hObject,'String')) returns contents of edit_image_size_v as a double


% --- Executes during object creation, after setting all properties.
function edit_image_size_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_image_size_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_experiment_samples_Callback(hObject, eventdata, handles)
% hObject    handle to edit_experiment_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_experiment_samples as text
%        str2double(get(hObject,'String')) returns contents of edit_experiment_samples as a double


% --- Executes during object creation, after setting all properties.
function edit_experiment_samples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_experiment_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_experiment_measurements_Callback(hObject, eventdata, handles)
% hObject    handle to edit_experiment_measurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_experiment_measurements as text
%        str2double(get(hObject,'String')) returns contents of edit_experiment_measurements as a double


% --- Executes during object creation, after setting all properties.
function edit_experiment_measurements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_experiment_measurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in panel_reconstruction.
function panel_reconstruction_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_reconstruction
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.button_l2_min,'Value') == 1 || get(handles.button_basis_pursuit,'Value') == 1
    set(handles.button_con_equality,'Enable','off');
    set(handles.button_con_squared,'Enable','off');
    set(handles.button_con_dantzig,'Enable','off');
    set(handles.edit_epsilon,'Enable','off');
else
    set(handles.button_con_equality,'Enable','on');
    set(handles.button_con_squared,'Enable','on');
    set(handles.button_con_dantzig,'Enable','on');
    set(handles.edit_epsilon,'Enable','on');
end

if get(handles.button_basis_pursuit,'Value') == 1
    set(handles.text_BP_sparsity,'Visible','on');
    set(handles.edit_BP_sparsity,'Visible','on');
else
    set(handles.text_BP_sparsity,'Visible','off');
    set(handles.edit_BP_sparsity,'Visible','off');
end


% --- Executes when selected object is changed in panel_basis.
function panel_basis_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_basis
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%% button checked
if get(handles.button_basis_custom,'Value') == 1
    set(handles.text_basis_load,'Visible','on');
    set(handles.push_basis_load,'Visible','on');
else
    set(handles.text_basis_load,'Visible','off');
    set(handles.push_basis_load,'Visible','off');
end

%% button unchecked
if get(handles.button_basis_wavelet,'Value') == 1
    set(handles.panel_wavelet,'Visible','on');
else
    set(handles.panel_wavelet,'Visible','off');
end


% --- Executes when selected object is changed in panel_measurements.
function panel_measurements_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_measurements
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.button_measure_custom,'Value') == 1
    set(handles.text_measure_load,'Visible','on');
    set(handles.push_load_measuring_matrix,'Visible','on');
else
    set(handles.text_measure_load,'Visible','off');
    set(handles.push_load_measuring_matrix,'Visible','off');
end


% --- Executes on button press in push_projection.
function push_projection_Callback(hObject, eventdata, handles)
% hObject    handle to push_projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tic

%% General Variables
nMeasures = str2double(get(handles.edit_experiment_measurements,'String'));
imageH = str2double(get(handles.edit_image_size_h,'String'));
imageV = str2double(get(handles.edit_image_size_v,'String'));


%% RGB image?
colorMode = handles.colorMode;

%% Measuring Matrix
if ~get(handles.button_measure_custom,'Value')
    
    if get(handles.button_measure_bernoulli,'Value')
        measuringMatrix = 'bernoulli';
    end
    
    if get(handles.button_measure_bernoulli_fixed,'Value')
        measuringMatrix = 'bernoulliFixed';
    end
    
    if get(handles.button_measure_raster_scan,'Value')
        measuringMatrix = 'rasterScan';
        if imageH*imageV ~= nMeasures
             warndlg('The number of measurements should equal to total pixels of the image you defined','Parameter Error');
            return;
        end
    end
    
else
    measuringMatrix = handles.measuringMatrix(1:nMeasures,:);
    
    if handles.measuringMatrix(end,:) == 0
        measuringMatrix =[measuringMatrix; handles.measuringMatrix(end-1,:); handles.measuringMatrix(end,:)] ;
    end
end
%% testing mode and custom data

if strcmp(get(handles.menu_test_mode,'Checked'),'on')
    %Variables specific from test mode
    mu = str2double(get(handles.edit_noise_mu,'String'));
    sigma = str2double(get(handles.edit_noise_sigma,'String'));
    % If there is no test image loaded create a custom one
    if strmatch(get(handles.text_test_image_load,'String'),'Image Selected')
        testImage = handles.testImage;
        
    else
        testImage = zeros(imageV,imageH,colorMode);
        for ii = 1:imageH
            testImage(:,ii,:) = (ii-1)/(imageH-1);
        end
    end
    data = CS_data_teste(nMeasures,imageH,imageV,measuringMatrix,colorMode,testImage,mu,sigma);
else
    %Variables specific from projection mode
    screenH = str2double(get(handles.edit_projection_h,'String'));
    screenV = str2double(get(handles.edit_projection_v,'String'));
    offsetH = str2double(get(handles.edit_offset_h,'String'));
    offsetV = str2double(get(handles.edit_offset_v,'String'));
    nSamples = str2double(get(handles.edit_experiment_samples,'String'));
    averageMode = handles.averageMode;
    try
        calibrationMatrix = handles.calibrationMatrix;
    catch
        calibrationMatrix = ones(imageV,imageH);
    end
    
    %aquire the data

    data = CS_data_projector(nSamples,nMeasures,imageH,imageV,screenH,screenV,...
        measuringMatrix,colorMode,offsetH,offsetV,averageMode)
end

%separate the data into the measuring matrix and the measurements
handles.measuringMatrix = data(:,1:end-colorMode);
handles.measurements = data(:,end-colorMode+1:end);

set(handles.push_reconstruct,'Enable','on')
set(handles.menu_save_measurements,'Enable','on');
guidata(hObject,handles);

toc


% --- Executes on button press in push_load_test_image.
function push_load_test_image_Callback(hObject, eventdata, handles)
% hObject    handle to push_load_test_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[path,cancel] = imgetfile;

if cancel == 0
    testImage = imread(path);
    set(handles.text_test_image_load,'String','Image Selected')
    set(handles.text_test_image_load,'ForegroundColor',[0 0.5 0])
    imageH = str2double(get(handles.edit_image_size_h,'String'));
    imageV = str2double(get(handles.edit_image_size_v,'String'));
    testImage = imresize(testImage,[imageV,imageH],'bicubic');
    testImageShow = imresize(testImage,[512,512],'nearest');
    figure
    
    imshow(testImageShow)
    
    handles.testImage = testImage;
    
    guidata(hObject,handles);
end



function edit_noise_mu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise_mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise_mu as text
%        str2double(get(hObject,'String')) returns contents of edit_noise_mu as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_mu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise_mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_noise_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise_sigma as text
%        str2double(get(hObject,'String')) returns contents of edit_noise_sigma as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_offset_v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset_v as text
%        str2double(get(hObject,'String')) returns contents of edit_offset_v as a double


% --- Executes during object creation, after setting all properties.
function edit_offset_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_offset_h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset_h as text
%        str2double(get(hObject,'String')) returns contents of edit_offset_h as a double


% --- Executes during object creation, after setting all properties.
function edit_offset_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_select_data.
function push_select_data_Callback(hObject, eventdata, handles)
% hObject    handle to push_select_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName] = uigetfile;

if ~isequal(fileName,0) || ~isequal(pathName,0)
    
    struct = load(fullfile(pathName, fileName));
    field = fieldnames(struct);
    measurements = getfield(struct,field{1});
    
    set(handles.text_select_data,'String','Data Selected')
    set(handles.text_select_data,'ForegroundColor',[0 0.5 0])
    
    handles.measurements = measurements;
    
    set(handles.push_reconstruct,'Enable','on')
    
    guidata(hObject,handles);
    
end

function edit_BP_sparsity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BP_sparsity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BP_sparsity as text
%        str2double(get(hObject,'String')) returns contents of edit_BP_sparsity as a double

% --- Executes during object creation, after setting all properties.
function edit_BP_sparsity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BP_sparsity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in push_reconstruct.
function push_reconstruct_Callback(hObject, eventdata, handles)
% hObject    handle to push_reconstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nMeasures = str2double(get(handles.edit_experiment_measurements,'String'));
epsilon = str2double(get(handles.edit_epsilon,'String'));
imageH = str2double(get(handles.edit_image_size_h,'String'));
imageV = str2double(get(handles.edit_image_size_v,'String'));
colorMode = handles.colorMode;

%verify if the last row of the measuring matrix is all 0's
%if this is true then we can use the last measurement as
% the DC ofsset

if handles.measuringMatrix(end,:) == 0
    aux = 2;
else
    aux = 0;
end

measuringMatrix = handles.measuringMatrix(1:nMeasures + aux,:);
measurements = handles.measurements(1:nMeasures + aux,:);

data = measuringMatrix;
data(:,end+1:end+colorMode) = measurements;

disp('DEBUG')
save('data','data')

%% Remove DC?

removeDC = handles.removeDC;

%% Recovery Methods
if get(handles.button_l2_min,'Value')
    recoveryMethod = 'l2Min';
end

if get(handles.button_l1_min,'Value')
    
    if strcmp(get(handles.button_TV_min,'Selected'),'off');
        if imageH*imageV < nMeasures
            warndlg('You are using a conpressed sensing method. The number of measurements must be smaller than total pixel munbers.','Parameter Error');
            return;
        end
    end
    
    if get(handles.button_con_equality,'Value')
        recoveryMethod = 'l1MinEquality';
    end
    
    if get(handles.button_con_squared,'Value')
        recoveryMethod = 'l1MinQuadratic';
    end
        
    if get(handles.button_con_dantzig,'Value')
        recoveryMethod = 'l1MinDantzig';
    end
    
end

if get(handles.button_TV_min,'Value')

    if strcmp(get(handles.button_TV_min,'Selected'),'off');
        if imageH*imageV < nMeasures
            warndlg('You are using a conpressed sensing method. The number of measurements must be smaller than total pixel munbers.','Parameter Error');
            return;
        end
%         if imageV ~= imageH
%             warndlg('You are using a conpressed sensing method. The image should be square in this version, please equalise the horizontal and vertical pixels ','Parameter Error');
%             return;
%         end
    end
    
    if get(handles.button_con_equality,'Value')
        recoveryMethod = 'tvMinEquality';
    end
    
    if get(handles.button_con_squared,'Value')
        recoveryMethod = 'tvMinQuadratic';
    end
    
    
    if get(handles.button_con_dantzig,'Value')
        recoveryMethod = 'tvMinDantzig';
    end
    
end

if get(handles.button_basis_pursuit,'Value')
    recoveryMethod = 'BP';
    sparsity = str2double(get(handles.edit_BP_sparsity,'String'));
    if strcmp(get(handles.button_basis_pursuit,'Selected'),'off');
        if sparsity > nMeasures
        warndlg('The sparsity value should be smaller than number of measurements','Sparsity Value');
        return;
        end
    end
else
    sparsity = [];
end

%% custom Basis?

if get(handles.button_basis_custom,'Value')
    basis = handles.basis;
else
    
    if get(handles.button_basis_can,'Value')
        dictionaryType = 'canonical';
    end
    
    if get(handles.button_basis_DCT,'Value')
        dictionaryType = 'DCT';
    end
    
    if get(handles.button_basis_wavelet,'Value')
        dictionaryType = 'wavelet';
        waveletType = get(handles.edit_basis_wavelet_type,'String');
        decomposition = str2double(get(handles.edit_basis_wavelet_decomposition,'String'));
        
    else
        waveletType = [];
        decomposition = [];
    end
    
    basis = create_dictionary(dictionaryType,imageH,imageV,waveletType,decomposition);
end

%% reconstruction
try
    calibrationMatrix = handles.calibrationMatrix;
catch
    calibrationMatrix = [];
end
    
reconstruction = CS_reconstruction(data,basis,imageH,imageV,recoveryMethod,...
    colorMode,epsilon,removeDC,sparsity,calibrationMatrix);


handles.reconstruction = reconstruction;
guidata(hObject,handles);


set(handles.menu_save_reconstruction,'Enable','on');

% --- Executes on button press in push_load_calibration.
function push_load_calibration_Callback(hObject, eventdata, handles)
% hObject    handle to push_load_calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName] = uigetfile;

if ~isequal(fileName,0) || ~isequal(pathName,0)
    
    struct = load(fullfile(pathName, fileName));
    field = fieldnames(struct);
    calibrationMatrix = getfield(struct,field{1});
    
    set(handles.text_load_calibration,'String','Matrix Selected')
    set(handles.text_load_calibration,'ForegroundColor',[0 0.5 0])
    
    handles.calibrationMatrix = calibrationMatrix;
    
    guidata(hObject,handles);
    
end


% --- Executes on button press in check_square_screen.
function check_square_screen_Callback(hObject, eventdata, handles)
% hObject    handle to check_square_screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_square_screen


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_dcOffset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dcOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Checked'),'on')
    set(hObject,'Checked','on');
    handles.removeDC = 0;
else
    set(hObject,'Checked','on');
    handles.removeDC = 1;
    
end

guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_data_Callback(hObject, eventdata, handles)
% hObject    handle to menu_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_save_measurements_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save_measurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

measuringMatrix = handles.measuringMatrix;
measurements = handles.measurements;
uisave('measuringMatrix','measuringMatrix');
uisave('measurements','measurements');
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_save_reconstruction_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save_reconstruction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reconstruction = handles.reconstruction;
uisave('reconstruction','reconstruction');

guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_color_gray_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Checked','on')
set(handles.menu_color_rgb,'Checked','off')
handles.colorMode = 1;
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_color_rgb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_rgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Checked','on')
set(handles.menu_color_gray,'Checked','off')
handles.colorMode = 3;
guidata(hObject,handles);

% --------------------------------------------------------------------
function Untitled_22_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_average_mean_Callback(hObject, eventdata, handles)
% hObject    handle to menu_average_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'Checked','on');
set(handles.menu_average_median,'Checked','off');
set(handles.menu_average_mode,'Checked','off');

handles.averageMode = 'mean';
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_average_median_Callback(hObject, eventdata, handles)
% hObject    handle to menu_average_median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'Checked','on');
set(handles.menu_average_mean,'Checked','off');
set(handles.menu_average_mode,'Checked','off');

handles.averageMode = 'median';
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_average_mode_Callback(hObject, eventdata, handles)
% hObject    handle to menu_average_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'Checked','on');
set(handles.menu_average_median,'Checked','off');
set(handles.menu_average_mean,'Checked','off');

handles.averageMode = 'mode';
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_remove_dc_offset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_remove_dc_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Checked','on');
set(handles.menu_not_remove_dc_offset,'Checked','off');
handles.removeDC = 1;
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_not_remove_dc_offset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_not_remove_dc_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Checked','on');
set(handles.menu_remove_dc_offset,'Checked','off');
handles.removeDC = 0;
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_previous_data_Callback(hObject, eventdata, handles)
% hObject    handle to menu_previous_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.panel_previous_data,'Visible','on')

set(handles.edit_experiment_samples,'Enable','off')
set(handles.panel_offset,'Visible','off')
set(handles.panel_projection,'Visible','off')
set(handles.push_adjust ,'Visible','off')
set(handles.push_flat_field ,'Visible','off')
set(handles.push_projection,'Enable','off')
set(handles.panel_test_image,'Visible','off')
set(handles.panel_noise,'Visible','off')

set(hObject,'Checked','on')
set(handles.menu_test_mode,'Checked','off')
set(handles.menu_projection_mode,'Checked','off')


% --------------------------------------------------------------------
function menu_projection_mode_Callback(hObject, eventdata, handles)
% hObject    handle to menu_projection_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.panel_projection,'Visible','on')
set(handles.push_adjust,'Visible','on')
set(handles.push_flat_field,'Visible','off')
set(handles.panel_offset,'Visible','on')
set(handles.edit_experiment_samples,'Enable','off')
set(handles.push_projection,'Enable','on')

set(handles.panel_test_image,'Visible','off')
set(handles.panel_noise,'Visible','off')
set(handles.panel_previous_data,'Visible','off')

set(hObject,'Checked','on')
set(handles.menu_test_mode,'Checked','off')
set(handles.menu_previous_data,'Checked','off')

% --------------------------------------------------------------------
function menu_test_mode_Callback(hObject, eventdata, handles)
% hObject    handle to menu_test_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.panel_test_image,'Visible','on')
set(handles.panel_noise,'Visible','on')
set(handles.push_projection,'Enable','on')

set(handles.panel_projection,'Visible','off')
set(handles.push_adjust,'Visible','off')
set(handles.push_flat_field,'Visible','off')
set(handles.panel_offset,'Visible','off')
set(handles.edit_experiment_samples,'Enable','off')
set(handles.panel_previous_data,'Visible','off')

set(hObject,'Checked','on')
set(handles.menu_projection_mode,'Checked','off')
set(handles.menu_previous_data,'Checked','off')


% --------------------------------------------------------------------
function COM_port_Callback(hObject, eventdata, handles)
% hObject    handle to COM_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function COM5_Callback(hObject, eventdata, handles)
% hObject    handle to COM5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function COM4_Callback(hObject, eventdata, handles)
% hObject    handle to COM4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function COM3_Callback(hObject, eventdata, handles)
% hObject    handle to COM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_con_squared.
function button_con_squared_Callback(hObject, eventdata, handles)
% hObject    handle to button_con_squared (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_con_squared
