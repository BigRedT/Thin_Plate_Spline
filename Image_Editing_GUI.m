function varargout = Image_Editing_GUI(varargin)
% IMAGE_EDITING_GUI MATLAB code for Image_Editing_GUI.fig
%      IMAGE_EDITING_GUI, by itself, creates a new IMAGE_EDITING_GUI or raises the existing
%      singleton*.
%
%      H = IMAGE_EDITING_GUI returns the handle to a new IMAGE_EDITING_GUI or the handle to
%      the existing singleton*.
%
%      IMAGE_EDITING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_EDITING_GUI.M with the given input arguments.
%
%      IMAGE_EDITING_GUI('Property','Value',...) creates a new IMAGE_EDITING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Image_Editing_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Image_Editing_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Image_Editing_GUI

% Last Modified by GUIDE v2.5 05-Aug-2014 12:09:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Image_Editing_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Image_Editing_GUI_OutputFcn, ...
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


% --- Executes just before Image_Editing_GUI is made visible.
function Image_Editing_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Image_Editing_GUI (see VARARGIN)


% Choose default command line output for Image_Editing_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Image_Editing_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Image_Editing_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImage.
function loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Browse for the image file. 
[baseFileName, folder] = uigetfile('*.*', 'jpeg'); 

% Create the full file name. 
fullImageFileName = fullfile(folder, baseFileName); 
img=imread(fullImageFileName); 

axes(handles.editingPane); 
image(img); 
hold on
set(handles.loadImage, 'UserData',img);

M = size(img,1);
N = size(img,2);
increment = uint32(max([M,N])/16);
for k = 1:increment:M
    x = [1 N];
    y = [k k];
    plot(x,y,'Color','w','LineStyle','-');
    plot(x,y,'Color','k','LineStyle',':');
end

for k = 1:increment:N
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','w','LineStyle','-');
    plot(x,y,'Color','k','LineStyle',':');
end

hold off

function numPoints_Callback(hObject, eventdata, handles)
% hObject    handle to numPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numPoints as text
%        str2double(get(hObject,'String')) returns contents of numPoints as a double
numPts = str2double(get(hObject,'String'));
set(handles.displayNumber,'String',['Please pick ' int2str(numPts) ' point correspondences']);
set(handles.numPoints,'UserData',struct('numPts',numPts));


% --- Executes during object creation, after setting all properties.
function numPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pickPoints.
function pickPoints_Callback(hObject, eventdata, handles)
% hObject    handle to pickPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
numPointStruct = get(handles.numPoints,'UserData');
x_src = [];
y_src = [];
x_dst = [];
y_dst = [];
img = get(handles.loadImage,'UserData');
markerSize = uint32(.01*min([size(img,1) size(img,2)]));
markerInserter = vision.MarkerInserter('Shape', 'Circle','Size',markerSize,'Fill',true);
markerInserter2 = vision.MarkerInserter('Shape', 'Square','Size',markerSize,'Fill',true,'FillColor','White');
for i = 1:numPointStruct.numPts
    [x y] = ginput(1);
    img = step(markerInserter,img,[uint32(x) uint32(y)]);
    axes(handles.editingPane); 
    image(img);
    hold on
    M = size(img,1);
    N = size(img,2);
    increment = uint32(max([M,N])/16);
    for k = 1:increment:M
        xLine = [1 N];
        yLine = [k k];
        plot(xLine,yLine,'Color','w','LineStyle','-');
        plot(xLine,yLine,'Color','k','LineStyle',':');
    end
    for k = 1:increment:N
        xLine = [k k];
        yLine = [1 M];
        plot(xLine,yLine,'Color','w','LineStyle','-');
        plot(xLine,yLine,'Color','k','LineStyle',':');
    end
    hold off
    x_src = [x_src; x];
    y_src = [y_src; y];
    [x y] = ginput(1);
    img = step(markerInserter2,img,[uint32(x) uint32(y)]);
    axes(handles.editingPane); 
    image(img);
    hold on
    M = size(img,1);
    N = size(img,2);
    increment = uint32(max([M,N])/16);
    for k = 1:increment:M
        xLine = [1 N];
        yLine = [k k];
        plot(xLine,yLine,'Color','w','LineStyle','-');
        plot(xLine,yLine,'Color','k','LineStyle',':');
    end
    for k = 1:increment:N
        xLine = [k k];
        yLine = [1 M];
        plot(xLine,yLine,'Color','w','LineStyle','-');
        plot(xLine,yLine,'Color','k','LineStyle',':');
    end
    hold off
    x_dst = [x_dst; x];
    y_dst = [y_dst; y];
end
set(handles.pickPoints,'UserData',struct('x_src',x_src,'y_src',y_src,'x_dst',x_dst,'y_dst',y_dst));

% --- U(x,pi) 
function val = U(p_i,p_j)
l2norm = norm(p_i-p_j,2);
val = l2norm*log(l2norm+0.01)/(8*pi);

% --- Executes on button press in spline.
function spline_Callback(hObject, eventdata, handles)
% hObject    handle to spline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img = get(handles.loadImage,'UserData');
pickPointStruct = get(handles.pickPoints,'UserData');
x_src = pickPointStruct.x_src;
y_src = pickPointStruct.y_src;
x_dst = pickPointStruct.x_dst;
y_dst = pickPointStruct.y_dst;

numPointStruct = get(handles.numPoints,'UserData');
n = numPointStruct.numPts;
K=zeros(n,n);
P=zeros(n,3);
L=zeros(3,3);
vx=zeros(n+3,1);
vy=zeros(n+3,1);
for i=1:n
    for(j=i:n)
        p_i = [x_src(i,1);y_src(i,1)];
        p_j = [x_dst(j,1);y_dst(j,1)];
        K(i,j) = U(p_i,p_j);
        K(j,i) = K(i,j);
    end
    P(i,1) = x_dst(i,1);
    P(i,2) = y_dst(i,1);
    P(i,3) = 1;
    vx(i,1) = x_src(i,1);
    vy(i,1) = y_src(i,1);
end
% w=zeros(n,1);
% a=zeros(3,1);
yx=zeros(n+3,1);
yy=zeros(n+3,1);
A=[K,P;P',L];

yx=pinv(A)*vx;
yy=pinv(A)*vy;
newImg = img*0;
for i = 1:size(img,1)
    axes(handles.editingPane); 
    image(img);
    hold on;
    xLine = [1 size(img,2)];
    yLine = [i i];
    plot(xLine,yLine,'Color','c','LineStyle','-','LineWidth',3);
%     plot(xLine,yLine,'Color','k','LineStyle',':');
    hold off;
    parfor j = 1:size(img,2)
        x = [j;i];
        Knew = [];
        for k = 1:n
            p_k = [x_dst(k,1); y_dst(k,1)];
            Knew = [Knew U(x,p_k)];
        end
        Pnew = [j i 1];
        Anew = [Knew Pnew];
        Zx = uint32(Anew*yx);
        Zy = uint32(Anew*yy);
        if(Zx>0 && Zx<size(img,2) && Zy>0 && Zy<size(img,1))
            newImg(i,j,:) = img(Zy,Zx,:);
        end
    end
end
axes(handles.editingPane); 
image(newImg);
set(handles.spline,'UserData',newImg);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.editingPane); 
image(get(handles.loadImage,'UserData'));


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newImg = get(handles.spline,'UserData');
filename = get(handles.filename,'String');
imwrite(newImg,filename);


function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
