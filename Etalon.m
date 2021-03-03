function varargout = Etalon(varargin)
% ETALON M-file for Etalon.fig
%      ETALON, by itself, creates a new ETALON or raises the existing
%      singleton*.
%
%      H = ETALON returns the handle to a new ETALON or the handle to
%      the existing singleton*.
%
%      ETALON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ETALON.M with the given input arguments.
%
%      ETALON('Property','Value',...) creates a new ETALON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Etalon_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Etalon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".(
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Etalon

% Last Modified by GUIDE v2.5 24-Jan-2014 14:53:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Etalon_OpeningFcn, ...
                   'gui_OutputFcn',  @Etalon_OutputFcn, ...
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


% --- Executes just before Etalon is made visible.
function Etalon_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Etalon (see VARARGIN)

% Choose default command line output for Etalon
handles.output = hObject;

handles.Fs=44100;
handles.sig = sin(2*pi*1000*(1:(handles.Fs*30))./handles.Fs);
handles.sig = (handles.sig ./ sqrt(mean(handles.sig.^2)));
handles.ScaleMin=100;
handles.ScaleMax=4000;

% if handles.fp==250,
% if exist('Data250.log','file'),
%     load -mat Data250.log; end 
% elseif handles.fp==500,
% if exist('Data500.log','file'),
%     load -mat Data500.log; end    
% elseif handles.fp==750,
% if exist('Data750.log','file'),
%     load -mat Data750.log;    end 
% elseif handles.fp==1000,
% if exist('Data1000.log','file'),
%     load -mat Data1000.log;     end
% elseif handles.fp==2000,
% if exist('Data2000.log','file'),
%     load -mat Data2000.log;   end
% elseif handles.fp==4000,
% if exist('Data4000.log','file'),
%     load -mat Data4000.log; end
%     
%     set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
%     set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
%     clear Data
% end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Etalon wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Etalon_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function s55_Callback(hObject, eventdata, handles)
% hObject    handle to s55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s55,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s50_Callback(hObject, eventdata, handles)
% hObject    handle to s50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s50,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function s50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s45_Callback(hObject, eventdata, handles)
% hObject    handle to s45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s45,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function s45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end

% --- Executes on slider movement.
function s40_Callback(hObject, eventdata, handles)
% hObject    handle to s40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s40,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function s40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end



% --- Executes on slider movement.
function s60_Callback(hObject, eventdata, handles)
% hObject    handle to s60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s60,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s65_Callback(hObject, eventdata, handles)
% hObject    handle to s65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s65,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s70_Callback(hObject, eventdata, handles)
% hObject    handle to s70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s70,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s75_Callback(hObject, eventdata, handles)
% hObject    handle to s75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s75,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s75_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s80_Callback(hObject, eventdata, handles)
% hObject    handle to s80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s80,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s80_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function sCL_Callback(hObject, eventdata, handles)
% hObject    handle to sCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.sCL,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sCL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --------------------------------------------------------------------
function OnGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to OnGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % if get(handles.OffSig,'Value'),
% %     set(handles.s60,'Enable','off');
% %     set(handles.s60,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s65,'Enable','off');
% %     set(handles.s65,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s70,'Enable','off');
% %     set(handles.s70,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s75,'Enable','off');
% %     set(handles.s75,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s80,'Enable','off');
% %     set(handles.s80,'BackgroundColor',[236 233 216]./256);
% %     set(handles.sCL,'Enable','off');
% %     set(handles.sCL,'BackgroundColor',[236 233 216]./256);
% %     stop(handles.y)
% % elseif get(handles.On60,'Value'),
% %     set(handles.s60,'Enable','on');
% %     set(handles.s60,'BackgroundColor',[1 1 1]);
% %     set(handles.s65,'Enable','off');
% %     set(handles.s65,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s70,'Enable','off');
% %     set(handles.s70,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s75,'Enable','off');
% %     set(handles.s75,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s80,'Enable','off');
% %     set(handles.s80,'BackgroundColor',[236 233 216]./256);
% %     set(handles.sCL,'Enable','off');
% %     set(handles.sCL,'BackgroundColor',[236 233 216]./256);
% %     out = handles.sig ./ (1/((get(handles.s60,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
% %     handles.y=audioplayer(out,handles.Fs);
% %     play(handles.y);
% % elseif get(handles.On65,'Value'),
% %     set(handles.s60,'Enable','off');
% %     set(handles.s60,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s65,'Enable','on');
% %     set(handles.s65,'BackgroundColor',[1 1 1]);
% %     set(handles.s70,'Enable','off');
% %     set(handles.s70,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s75,'Enable','off');
% %     set(handles.s75,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s80,'Enable','off');
% %     set(handles.s80,'BackgroundColor',[236 233 216]./256);
% %     set(handles.sCL,'Enable','off');
% %     set(handles.sCL,'BackgroundColor',[236 233 216]./256);
% %     out = handles.sig ./ (1/((get(handles.s65,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
% %     handles.y=audioplayer(out,handles.Fs);
% %     play(handles.y);
% % elseif get(handles.On70,'Value'),
% %     set(handles.s60,'Enable','off');
% %     set(handles.s60,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s65,'Enable','off');
% %     set(handles.s65,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s70,'Enable','on');
% %     set(handles.s70,'BackgroundColor',[1 1 1]);
% %     set(handles.s75,'Enable','off');
% %     set(handles.s75,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s80,'Enable','off');
% %     set(handles.s80,'BackgroundColor',[236 233 216]./256);
% %     set(handles.sCL,'Enable','off');
% %     set(handles.sCL,'BackgroundColor',[236 233 216]./256);
% %     out = handles.sig ./ (1/((get(handles.s70,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
% %     handles.y=audioplayer(out,handles.Fs);
% %     play(handles.y);
% % elseif get(handles.On75,'Value'),
% %     set(handles.s60,'Enable','off');
% %     set(handles.s60,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s65,'Enable','off');
% %     set(handles.s65,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s70,'Enable','off');
% %     set(handles.s70,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s75,'Enable','on');
% %     set(handles.s75,'BackgroundColor',[1 1 1]);
% %     set(handles.s80,'Enable','off');
% %     set(handles.s80,'BackgroundColor',[236 233 216]./256);
% %     set(handles.sCL,'Enable','off');
% %     set(handles.sCL,'BackgroundColor',[236 233 216]./256);
% %     out = handles.sig ./ (1/((get(handles.s75,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
% %     handles.y=audioplayer(out,handles.Fs);
% %     play(handles.y);
% % elseif get(handles.On80,'Value'),
% %     set(handles.s60,'Enable','off');
% %     set(handles.s60,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s65,'Enable','off');
% %     set(handles.s65,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s70,'Enable','off');
% %     set(handles.s70,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s75,'Enable','off');
% %     set(handles.s75,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s80,'Enable','on');
% %     set(handles.s80,'BackgroundColor',[1 1 1]);
% %     set(handles.sCL,'Enable','off');
% %     set(handles.sCL,'BackgroundColor',[236 233 216]./256);
% %     out = handles.sig ./ (1/((get(handles.s80,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
% %     handles.y=audioplayer(out,handles.Fs);
% %     play(handles.y);
% % elseif get(handles.OnCL,'Value'),
% %     set(handles.s60,'Enable','off');
% %     set(handles.s60,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s65,'Enable','off');
% %     set(handles.s65,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s70,'Enable','off');
% %     set(handles.s70,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s75,'Enable','off');
% %     set(handles.s75,'BackgroundColor',[236 233 216]./256);
% %     set(handles.s80,'Enable','off');
% %     set(handles.s80,'BackgroundColor',[236 233 216]./256);
% %     set(handles.sCL,'Enable','on');
% %     set(handles.sCL,'BackgroundColor',[1 1 1]);
% %     out = handles.sig ./ (1/((get(handles.sCL,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
% %     handles.y=audioplayer(out,handles.Fs);
% %     play(handles.y);
% % end
% % guidata(hObject, handles);


handles.Fs=44100;
fp=handles.fp;   
handles.sig = sin(2*pi*fp*(1:(handles.Fs*30))./handles.Fs);
handles.sig = (handles.sig ./ sqrt(mean(handles.sig.^2)));


if get(handles.OffSig,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256); 
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    stop(handles.y)  
elseif get(handles.On25,'Value'),
    set(handles.s25,'Enable','on');
    set(handles.s25,'BackgroundColor',[1 1 1]);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);        
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s40,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On30,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','on');
    set(handles.s30,'BackgroundColor',[1 1 1]);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);        
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s40,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On35,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','on');
    set(handles.s35,'BackgroundColor',[1 1 1]);        
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s40,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On40,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);        
    set(handles.s40,'Enable','on');
    set(handles.s40,'BackgroundColor',[1 1 1]);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s40,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On45,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','on');
    set(handles.s45,'BackgroundColor',[1 1 1]);
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s45,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On50,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','on');
    set(handles.s50,'BackgroundColor',[1 1 1]);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s50,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On55,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','on');
    set(handles.s55,'BackgroundColor',[1 1 1]); 
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s55,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On60,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);    
    set(handles.s60,'Enable','on');
    set(handles.s60,'BackgroundColor',[1 1 1]);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s60,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On65,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);      
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','on');
    set(handles.s65,'BackgroundColor',[1 1 1]);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s65,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On70,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);      
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','on');
    set(handles.s70,'BackgroundColor',[1 1 1]);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s70,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On75,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);      
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','on');
    set(handles.s75,'BackgroundColor',[1 1 1]);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s75,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.On80,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);      
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','on');
    set(handles.s80,'BackgroundColor',[1 1 1]);
    set(handles.sCL,'Enable','off');
    set(handles.sCL,'BackgroundColor',[236 233 216]./256);
    out = handles.sig ./ (1/((get(handles.s80,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
elseif get(handles.OnCL,'Value'),
    set(handles.s25,'Enable','off');
    set(handles.s25,'BackgroundColor',[236 233 216]./256);
    set(handles.s30,'Enable','off');
    set(handles.s30,'BackgroundColor',[236 233 216]./256);
    set(handles.s35,'Enable','off');
    set(handles.s35,'BackgroundColor',[236 233 216]./256);     
    set(handles.s40,'Enable','off');
    set(handles.s40,'BackgroundColor',[236 233 216]./256);
    set(handles.s45,'Enable','off');
    set(handles.s45,'BackgroundColor',[236 233 216]./256);  
    set(handles.s50,'Enable','off');
    set(handles.s50,'BackgroundColor',[236 233 216]./256);
    set(handles.s55,'Enable','off');
    set(handles.s55,'BackgroundColor',[236 233 216]./256);      
    set(handles.s60,'Enable','off');
    set(handles.s60,'BackgroundColor',[236 233 216]./256);
    set(handles.s65,'Enable','off');
    set(handles.s65,'BackgroundColor',[236 233 216]./256);
    set(handles.s70,'Enable','off');
    set(handles.s70,'BackgroundColor',[236 233 216]./256);
    set(handles.s75,'Enable','off');
    set(handles.s75,'BackgroundColor',[236 233 216]./256);
    set(handles.s80,'Enable','off');
    set(handles.s80,'BackgroundColor',[236 233 216]./256);
    set(handles.sCL,'Enable','on');
    set(handles.sCL,'BackgroundColor',[1 1 1]);
    out = handles.sig ./ (1/((get(handles.sCL,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
    handles.y=audioplayer(out,handles.Fs);
    play(handles.y);
end
guidata(hObject, handles);


% --- Executes on button press in Termine.
function Termine_Callback(hObject, eventdata, handles)
% hObject    handle to Termine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ll=struct('Sc25dB',(1/((get(handles.s25,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc30dB',(1/((get(handles.s30,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc35dB',(1/((get(handles.s35,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc40dB',(1/((get(handles.s40,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc45dB',(1/((get(handles.s45,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc50dB',(1/((get(handles.s50,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc55dB',(1/((get(handles.s55,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc60dB',(1/((get(handles.s60,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc65dB',(1/((get(handles.s65,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc70dB',(1/((get(handles.s70,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc75dB',(1/((get(handles.s75,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'Sc80dB',(1/((get(handles.s80,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)),...
          'ScCL',  (1/((get(handles.sCL,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax)));

% if exist('Data.log','file')==0,
%     %data=struct('Levels',ll);
%     Data.Levels=ll;
%     save Data.log Data
% else
%     load -mat Data.log
%     save Data.bak Data
%     %clear Data
%     %data=struct('levels',ll);
%     Data.Levels=ll;
%     save Data.log Data
% end

if handles.fp==250,
if exist('Data250.log','file')==0,
    %data=struct('Levels',ll);
    Data.Levels=ll;
    save Data250.log Data
else
    load -mat Data250.log
    save Data250.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Levels=ll;
    save Data250.log Data
end
elseif handles.fp==500,  
if exist('Data500.log','file')==0,
    %data=struct('Levels',ll);
    Data.Levels=ll;
    save Data500.log Data
else
    load -mat Data500.log
    save Data500.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Levels=ll;
    save Data500.log Data
end  
elseif handles.fp==750,  
if exist('Data750.log','file')==0,
    %data=struct('Levels',ll);
    Data.Levels=ll;
    save Data750.log Data
else
    load -mat Data750.log
    save Data750.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Levels=ll;
    save Data750.log Data
end 
elseif handles.fp==1000,  
if exist('Data1000.log','file')==0,
    %data=struct('Levels',ll);
    Data.Levels=ll;
    save Data1000.log Data
else
    load -mat Data1000.log
    save Data1000.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Levels=ll;
    save Data1000.log Data
end 
elseif handles.fp==2000,  
if exist('Data2000.log','file')==0,
    %data=struct('Levels',ll);
    Data.Levels=ll;
    save Data2000.log Data
else
    load -mat Data2000.log
    save Data2000.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Levels=ll;
    save Data2000.log Data
end 
elseif handles.fp==4000,  
if exist('Data4000.log','file')==0,
    %data=struct('Levels',ll);
    Data.Levels=ll;
    save Data4000.log Data
else
    load -mat Data4000.log
    save Data4000.bak Data
    %clear Data
    %data=struct('levels',ll);
    Data.Levels=ll;
    save Data4000.log Data
end 
end

close; 






% --- Executes on button press in Sauver.
function Sauver_Callback(hObject, eventdata, handles)
% hObject    handle to Sauver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Frequence.
function Frequence_Callback(hObject, eventdata, handles)
% hObject    handle to Frequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Frequence contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Frequence
if get(hObject,'Value')==2, handles.fp=250;  

    
if exist('Data250.log','file'),
    load -mat Data250.log; 
    set(handles.s25,'Value',((1/Data.Levels.Sc25dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s30,'Value',((1/Data.Levels.Sc30dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s35,'Value',((1/Data.Levels.Sc35dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));    
    set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
    set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    clear Data
end
    
elseif get(hObject,'Value')==3, handles.fp=500;
    
    if exist('Data500.log','file'),
    load -mat Data500.log; 
    set(handles.s25,'Value',((1/Data.Levels.Sc25dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s30,'Value',((1/Data.Levels.Sc30dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s35,'Value',((1/Data.Levels.Sc35dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
    set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    clear Data
end
    
elseif get(hObject,'Value')==4, handles.fp=750;
    
    if exist('Data750.log','file'),
    load -mat Data750.log; 
    set(handles.s25,'Value',((1/Data.Levels.Sc25dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s30,'Value',((1/Data.Levels.Sc30dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s35,'Value',((1/Data.Levels.Sc35dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
    set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    clear Data
end

elseif get(hObject,'Value')==5, handles.fp=1000;
    
    if exist('Data1000.log','file'),
    load -mat Data1000.log; 
    set(handles.s25,'Value',((1/Data.Levels.Sc25dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s30,'Value',((1/Data.Levels.Sc30dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s35,'Value',((1/Data.Levels.Sc35dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
    set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    clear Data
end

elseif get(hObject,'Value')==6, handles.fp=2000;
    
    if exist('Data2000.log','file'),
    load -mat Data2000.log; 
    set(handles.s25,'Value',((1/Data.Levels.Sc25dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s30,'Value',((1/Data.Levels.Sc30dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s35,'Value',((1/Data.Levels.Sc35dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
    set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    clear Data
end

elseif get(hObject,'Value')==7, handles.fp=4000;
    
    if exist('Data4000.log','file'),
    load -mat Data4000.log; 
    set(handles.s25,'Value',((1/Data.Levels.Sc25dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s30,'Value',((1/Data.Levels.Sc30dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s35,'Value',((1/Data.Levels.Sc35dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));    
    set(handles.s40,'Value',((1/Data.Levels.Sc40dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s45,'Value',((1/Data.Levels.Sc45dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s50,'Value',((1/Data.Levels.Sc50dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s55,'Value',((1/Data.Levels.Sc55dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));      
    set(handles.s60,'Value',((1/Data.Levels.Sc60dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s65,'Value',((1/Data.Levels.Sc65dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s70,'Value',((1/Data.Levels.Sc70dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s75,'Value',((1/Data.Levels.Sc75dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.s80,'Value',((1/Data.Levels.Sc80dB)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    set(handles.sCL,'Value',((1/Data.Levels.ScCL)-1/handles.ScaleMax)/(1/handles.ScaleMin - 1/handles.ScaleMax));
    clear Data
end

end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Frequence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function s35_Callback(hObject, eventdata, handles)
% hObject    handle to s35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s35,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s30_Callback(hObject, eventdata, handles)
% hObject    handle to s30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s30,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


% --- Executes on slider movement.
function s25_Callback(hObject, eventdata, handles)
% hObject    handle to s25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
out = handles.sig ./ (1/((get(handles.s25,'Value')*(1/handles.ScaleMin - 1/handles.ScaleMax)) + 1/handles.ScaleMax));
handles.y=audioplayer(out,handles.Fs);
play(handles.y);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function s25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end


