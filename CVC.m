function varargout = CVC(varargin)
% CVC M-file for CVC.fig
%      CVC, by itself, creates a new CVC or raises the existing
%      singleton*.
%
%      H = CVC returns the handle to a new CVC or the handle to
%      the existing singleton*.
%
%      CVC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CVC.M with the given input arguments.
%
%      CVC('Property','Value',...) creates a new CVC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CVC_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CVC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CVC

% Last Modified by GUIDE v2.5 08-Nov-2007 13:02:01
% Following modifications for update and extension for joint pupillometry
% Changed 3 instances of wavread to audioread - 20-Nov-2019, D. Arzounian

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CVC_OpeningFcn, ...
                   'gui_OutputFcn',  @CVC_OutputFcn, ...
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


% --- Executes just before CVC is made visible.
function CVC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CVC (see VARARGIN)

% Choose default command line output for CVC
handles.output = hObject;
h0 = cell2struct(varargin,'Parametres',2);
handles.Parametres = h0.Parametres;

routine_alloff(handles);

%init
handles.Fs=44100;
handles.level = handles.Parametres.level;
handles.NbLog = 10;
handles.NbOcc = 3;
handles.NbSelect = 30;
% if handles.Parametres.Noise, handles.RSB=-6;
% else handles.RSB=10000;
% end
handles.Factor = 10^(-(handles.Parametres.RSB/20));
handles.Essai = 0;
handles.Table = zeros(4,handles.NbSelect);
handles.ontour = 0;
handles.bip = audioread('ding.wav');
[handles.a handles.b]=butter(6,8000/(0.5*handles.Fs)); % lowpass filtering at 36 dB/oct, fc=5kHz
if handles.Parametres.Aud && handles.Parametres.Oreille == 2
    handles.audiofilt=routine_CAMFITD(handles);
elseif handles.Parametres.Aud && handles.Parametres.Oreille == 3
    handles.audiofilt=routine_CAMFITG(handles);
elseif handles.Parametres.Aud && handles.Parametres.Oreille == 4
    handles.audiofilt1=routine_CAMFITD(handles);
    handles.audiofilt2=routine_CAMFITG(handles);
end

%Output init
handles.mat = zeros(handles.NbLog,handles.NbLog);
handles.perf = [];

cd(handles.Parametres.StimRep);
handles.d = dir;
cd(handles.Parametres.ProgRep);

% MAJ panneau accueil
if handles.Parametres.RSB==10000,
    set(handles.TxtAccueil,'String',strvcat('Test Voyelles dans le silence      ', ' ','Cliquez sur Démarrer pour commencer    '));
else
    set(handles.TxtAccueil,'String',strvcat('Test Voyelles dans le bruit        ', ' ','Cliquez sur Démarrer pour commencer    '));
    %set(handles.TxtAccueil,'String',strvcat('Test Consonnes      ', 'Dans le silence     ', ' ', 'Cliquez sur Démarrer', 'pour commencer      '));
end

cd Bruits
handles.masker=audioread(handles.Parametres.SSN);
cd ..

if exist('Data.log','file')~=0,
    load -mat Data.log
    if isfield(Data,'Plugins'), handles.Plugins = Data.Plugins;
    else handles.Plugins = {'','',''}; end
else
    handles.Plugins = {'','',''};
end

set(handles.TxtAccueil,'HorizontalAlignment','center');
set(handles.TxtAccueil,'Visible','on');

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes CVC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CVC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

delete(handles.figure1);


% --- Executes on button press in face.
function face_Callback(hObject, eventdata, handles)
% hObject    handle to face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 1;
if handles.Table(3,handles.Essai)==1, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in pushbutton2.
function fance_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 3;
if handles.Table(3,handles.Essai)==3, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in feuce.
function feuce_Callback(hObject, eventdata, handles)
% hObject    handle to feuce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 4;
if handles.Table(3,handles.Essai)==4, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in faice.
function faice_Callback(hObject, eventdata, handles)
% hObject    handle to faice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 2;
if handles.Table(3,handles.Essai)==2, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in fince.
function fince_Callback(hObject, eventdata, handles)
% hObject    handle to fince (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 6;
if handles.Table(3,handles.Essai)==6, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in foce.
function foce_Callback(hObject, eventdata, handles)
% hObject    handle to foce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 7;
if handles.Table(3,handles.Essai)==7, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end


% --- Executes on button press in fice.
function fice_Callback(hObject, eventdata, handles)
% hObject    handle to fice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 5;
if handles.Table(3,handles.Essai)==5, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in fonce.
function fonce_Callback(hObject, eventdata, handles)
% hObject    handle to fonce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 8;
if handles.Table(3,handles.Essai)==8, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in fouce.
function fouce_Callback(hObject, eventdata, handles)
% hObject    handle to fouce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 9;
if handles.Table(3,handles.Essai)==9, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in fuce.
function fuce_Callback(hObject, eventdata, handles)
% hObject    handle to fuce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 10;
if handles.Table(3,handles.Essai)==10, handles.performance=handles.performance+1;end
if handles.Essai < handles.NbSelect,
    handles = routine_stimulus(handles);
    routine_allon(handles);
    guidata(hObject, handles);
else 
    handles = routine_output(handles);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist('Data1000.log','file')
    load -mat Data1000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end
else
    handles.error=1;
end

set(hObject,'Enable','off');    % Supprimer le bouton Start après pression

if handles.level==25, handles.Scale=handles.Levels.Sc25dB;
elseif handles.level==30, handles.Scale=handles.Levels.Sc30dB;
elseif handles.level==35, handles.Scale=handles.Levels.Sc35dB;
elseif handles.level==40, handles.Scale=handles.Levels.Sc40dB;
elseif handles.level==45, handles.Scale=handles.Levels.Sc45dB;
elseif handles.level==50, handles.Scale=handles.Levels.Sc50dB;
elseif handles.level==55, handles.Scale=handles.Levels.Sc55dB;
elseif handles.level==60, handles.Scale=handles.Levels.Sc60dB;
elseif handles.level==65, handles.Scale=handles.Levels.Sc65dB;
elseif handles.level==70, handles.Scale=handles.Levels.Sc70dB;
elseif handles.level==75, handles.Scale=handles.Levels.Sc75dB;
elseif handles.level==80, handles.Scale=handles.Levels.Sc80dB;
elseif handles.level==90, handles.Scale=handles.Levels.ScCL;
end

set(hObject,'Enable','off');
set(hObject,'Visible','off');
set(handles.TxtAccueil,'Visible','off');

rand('state',sum(100*clock));

handles.Essai = 0;
handles.performance = 0;
handles.alea=randperm(handles.NbLog * handles.NbOcc);
handles = routine_stimulus(handles);
routine_allon(handles);
guidata(hObject, handles);



function routine_alloff(handles)
set(handles.face,'Enable','off');
set(handles.faice,'Enable','off');
set(handles.fance,'Enable','off');
set(handles.feuce,'Enable','off');
set(handles.fice,'Enable','off');
set(handles.fince,'Enable','off');
set(handles.foce,'Enable','off');
set(handles.fonce,'Enable','off');
set(handles.fouce,'Enable','off');
set(handles.fuce,'Enable','off');


function routine_allon(handles)
set(handles.face,'Enable','on');
set(handles.faice,'Enable','on');
set(handles.fance,'Enable','on');
set(handles.feuce,'Enable','on');
set(handles.fice,'Enable','on');
set(handles.fince,'Enable','on');
set(handles.foce,'Enable','on');
set(handles.fonce,'Enable','on');
set(handles.fouce,'Enable','on');
set(handles.fuce,'Enable','on');

function n=stim2num(name)
aa=name(2:3);
if strcmp(aa,'af') n=1;
elseif strcmp(aa,'ai') n=2;
elseif strcmp(aa,'an') n=3;
elseif strcmp(aa,'eu') n=4;
elseif strcmp(aa,'if') n=5;
elseif strcmp(aa,'in') n=6;
elseif strcmp(aa,'of') n=7;
elseif strcmp(aa,'on') n=8;
elseif strcmp(aa,'ou') n=9;
elseif strcmp(aa,'uf') n=10;
end

function handles = routine_stimulus(handles)

Fs=handles.Fs;

cd(handles.Parametres.StimRep);

handles.Essai = handles.Essai + 1;
Tirage = handles.alea(handles.Essai); 

Selection=stim2num(handles.d(Tirage + 2).name);

handles.Table(1,handles.Essai) = handles.Essai;
handles.Table(2,handles.Essai) = Selection;

if mod(Selection,handles.NbLog) == 0,
    handles.Table(3,handles.Essai) = handles.NbLog;
else
    handles.Table(3,handles.Essai) = mod(Selection,handles.NbLog);
end

signal=audioread(handles.d(Tirage + 2).name);

cd(handles.Parametres.ProgRep);

%Plugins #1
if strcmp(handles.Plugins{1,1},'')~=1,
    cd plugins
    plug = str2func(char(handles.Plugins{1,1}));
    signal = plug(signal);
    cd ..
end

signal=filtfilt(handles.a,handles.b,signal);

signal = signal ./ sqrt(mean(signal.^2));
duration=length(signal);

t=round(rand(1)*(length(handles.masker)-duration-4096));  % tirage aleatoire de la portion du fichier ssn à utiliser comme masque

noise=handles.masker(t:(t+(duration-1)),round(rand(1))+1);

%plugins #2
if strcmp(handles.Plugins{1,2},'')~=1,
    cd plugins
    plug = str2func(char(handles.Plugins{1,2}));
    noise = plug(noise);
    cd ..
end

total_duration=length(noise);
t=1:total_duration; % vecteur temps

noise = noise ./ sqrt(mean(noise.^2)); % normalisation en énergie rms
output = signal + (noise .* handles.Factor );  % Addition Signal et Bruit avec un rapport S/N donné (controle par Factor)

%Plugins #3
if strcmp(handles.Plugins{1,3},'')~=1,
    cd plugins
    plug = str2func(char(handles.Plugins{1,3}));
    output = plug(output);
    cd ..
end

output = (output ./ sqrt(mean(output.^2))) ./ handles.Scale;
if length(output)==size(output,2), output=output';end
zz=zeros(length(output),1);

if handles.Parametres.Aud && handles.Parametres.Oreille == 2
    output1 = filter(handles.audiofilt,1,output);
else output1 = output ;end
if handles.Parametres.Aud && handles.Parametres.Oreille == 3
    output2 = filter(handles.audiofilt,1,output);
else output2 = output ;end
if handles.Parametres.Aud && handles.Parametres.Oreille == 4
    output3 = filter(handles.audiofilt1,1,output);
    output4 = filter(handles.audiofilt2,1,output);
else output3 = output 
     output4 = output ;end



if handles.Parametres.Oreille == 2,sound([zz output1],Fs);
elseif handles.Parametres.Oreille == 3,sound([output2 zz],Fs);
else sound([output4 output3],Fs);
end
pause(1.3);





function handles = routine_output(handles)

for k=1:handles.NbSelect,
    handles.mat(handles.Table(3,k),handles.Table(4,k)) = handles.mat(handles.Table(3,k),handles.Table(4,k))+1;
end

handles.perf=[handles.perf (handles.performance/handles.NbSelect)*100];

%mat=handles.mat;
%perf=handles.perf;
handles.output=struct('results',handles.perf,'mat',handles.mat);
sound((handles.bip ./ max(sqrt(mean(handles.bip.^2)))) ./ handles.Scale, 22050);



function filtre=routine_CAMFITD(handles)
AudiogD = -handles.Parametres.AudiogD;

gabarit_dBD=[-100 (AudiogD(1)*0.48-11) (AudiogD(1)*0.48-10) (AudiogD(2)*0.48-8) (AudiogD(3)*0.48) (AudiogD(4)*0.48+1) (AudiogD(5)*0.48-1) (AudiogD(6)*0.48) (AudiogD(7)*0.48+1) -100 -100];

gabarit_freqD=[2.*[0 125 250 500 1000 2000 3000 4000 8000 10000] handles.Fs]./handles.Fs;

filtre=fir2(4096,gabarit_freqD,10.^(gabarit_dBD/20));


function filtre=routine_CAMFITG(handles)
AudiogG = -handles.Parametres.AudiogG;

gabarit_dBG=[-100 (AudiogG(1)*0.48-11) (AudiogG(1)*0.48-10) (AudiogG(2)*0.48-8) (AudiogG(3)*0.48) (AudiogG(4)*0.48+1) (AudiogG(5)*0.48-1) (AudiogG(6)*0.48) (AudiogG(7)*0.48+1) -100 -100];

gabarit_freqG=[2.*[0 125 250 500 1000 2000 3000 4000 8000 10000] handles.Fs]./handles.Fs;

filtre=fir2(4096,gabarit_freqG,10.^(gabarit_dBG/20));