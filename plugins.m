function varargout = plugins(varargin)
% PLUGINS M-file for plugins.fig
%      PLUGINS, by itself, creates a new PLUGINS or raises the existing
%      singleton*.
%
%      H = PLUGINS returns the handle to a new PLUGINS or the handle to
%      the existing singleton*.
%
%      PLUGINS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLUGINS.M with the given input arguments.
%
%      PLUGINS('Property','Value',...) creates a new PLUGINS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plugins_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plugins_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plugins

% Last Modified by GUIDE v2.5 01-Sep-2008 11:52:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plugins_OpeningFcn, ...
                   'gui_OutputFcn',  @plugins_OutputFcn, ...
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


% --- Executes just before plugins is made visible.
function plugins_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plugins (see VARARGIN)

% Choose default command line output for plugins
handles.output = hObject;

if exist('Data.log','file')~=0,
    load -mat Data.log
    if isfield(Data,'Plugins'), handles.Plugs = Data.Plugins;
    else handles.Plugs = {'none','none','none'}; end
else
    handles.Plugs = {'none','none','none'};
end

%if strcmp(handles.Plugs{1,1},'')==0, set(handles.Plug1,'String',[handles.Plugs{1,1} '.m']); end
%if strcmp(handles.Plugs{1,2},'')==0, set(handles.Plug2,'String',[handles.Plugs{1,2} '.m']); end
%if strcmp(handles.Plugs{1,3},'')==0, set(handles.Plug3,'String',[handles.Plugs{1,3} '.m']); end

cd Plugins
d=dir;
cd ..
txt='none';
for k=3:length(d),
    if strcmp(d(k).name(end-1:end),'.m'), txt = strvcat(txt,d(k).name);end
end
set(handles.Plug1,'String',txt);
set(handles.Plug2,'String',txt);
set(handles.Plug3,'String',txt);

k=[3 3 3];
c=0;
l=0;
for j=1:3,
    while(c==0 && k(j)<=length(d)),
        c=strcmp(d(k(j)).name(1:end-2),handles.Plugs(j));
        if strcmp(d(k(j)).name(end-1:end),'.m'), l=l+1; end
        k(j)=k(j)+1;
    end
    if c==0, k(j)=1;
    else k(j)=k(j)-(k(j)-l-1);end
    c=0; l=0;
end

set(handles.Plug1,'Value',k(1));
set(handles.Plug2,'Value',k(2));
set(handles.Plug3,'Value',k(3));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plugins wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plugins_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Plug1_Callback(hObject, eventdata, handles)
% hObject    handle to plug1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plug1 as text
%        str2double(get(hObject,'String')) returns contents of plug1 as a double
% da=get(hObject, 'String');
% if length(da)<=2,
%     set(hObject, 'String', '');
% elseif strcmp(da(end-1:end),'.m')==0,
%     set(hObject, 'String', '');
% end

% --- Executes during object creation, after setting all properties.
function Plug1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plug1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
cd Plugins
d=dir;
cd ..
txt='none';
for k=3:length(d),
    if strcmp(d(k).name(end-1:end),'.m'), txt = strvcat(txt,d(k).name);end
end
set(hObject,'String',txt);



function Plug2_Callback(hObject, eventdata, handles)
% hObject    handle to Plug2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Plug2 as text
%        str2double(get(hObject,'String')) returns contents of Plug2 as a double
% da=get(hObject, 'String');
% if length(da)<=2,
%     set(hObject, 'String', '');
% elseif strcmp(da(end-1:end),'.m')==0,
%     set(hObject, 'String', '');
% end

% --- Executes during object creation, after setting all properties.
function Plug2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plug2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
cd Plugins
d=dir;
cd ..
txt='none';
for k=3:length(d),
    if strcmp(d(k).name(end-1:end),'.m'), txt = strvcat(txt,d(k).name);end
end
set(hObject,'String',txt);


function Plug3_Callback(hObject, eventdata, handles)
% hObject    handle to Plug3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Plug3 as text
%        str2double(get(hObject,'String')) returns contents of Plug3 as a double
% da=get(hObject, 'String');
% if length(da)<=2,
%     set(hObject, 'String', '');
% elseif strcmp(da(end-1:end),'.m')==0,
%     set(hObject, 'String', '');
% end

% --- Executes during object creation, after setting all properties.
function Plug3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plug3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
cd Plugins
d=dir;
cd ..
txt='none';
for k=3:length(d),
    if strcmp(d(k).name(end-1:end),'.m'), txt = strvcat(txt,d(k).name);end
end
set(hObject,'String',txt);

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p1=cellstr(get(handles.Plug1,'String'));
l1=get(handles.Plug1,'Value');
if strcmp(p1(l1,:),'none'), p1='';
else p1=char(p1(l1)); p1=p1(1:end-2);
end
p2=cellstr(get(handles.Plug2,'String'));
l2=get(handles.Plug2,'Value');
if strcmp(p2(l2,:),'none'), p2='';
else p2=char(p2(l2)); p2=p2(1:end-2);
end
p3=cellstr(get(handles.Plug3,'String'));
l3=get(handles.Plug3,'Value');
if strcmp(p3(l3,:),'none'), p3='';
else p3=char(p3(l3)); p3=p3(1:end-2);
end

ListPlugins={p1,p2,p3};
% save Plugins.log ListPlugins

if exist('Data.log','file')==0,
    %data=struct('Levels',ll);
    Data.Plugins=ListPlugins;
    save Data.log Data
else
    load -mat Data.log
    save Data.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Plugins=ListPlugins;
    save Data.log Data
end

close