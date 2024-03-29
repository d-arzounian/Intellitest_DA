function varargout = MLD(varargin)
% MLD M-file for MLD.fig
%      MLD, by itself, creates a new MLD or raises the existing
%      singleton*.
%
%      H = MLD returns the handle to a new MLD or the handle to
%      the existing singleton*.
%
%      MLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MLD.M with the given input arguments.
%
%      MLD('Property','Value',...) creates a new MLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MLD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MLD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MLD

% Last Modified by GUIDE v2.5 07-Mar-2014 10:49:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MLD_OpeningFcn, ...
                   'gui_OutputFcn',  @MLD_OutputFcn, ...
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


% --- Executes just before MLD is made visible.
function MLD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MLD (see VARARGIN)

% Choose default command line output for MLD
% handles.output = hObject;

handles.output = hObject;
h0 = cell2struct(varargin,'Parametres',2);
handles.Parametres = h0.Parametres;

routine_alloff(handles);


handles.Fs=44100;    %sampling frequency
handles.level = handles.Parametres.level;
handles.perf = [];

cd(handles.Parametres.StimRep);
handles.d = dir;
cd(handles.Parametres.ProgRep);

if handles.Parametres.RSB==10000,
    set(handles.TxtAccueil,'String',strvcat('Test BMLD dans le silence','S�lectionner les param�tres puis cliquez sur D�marrer pour commencer    '));
else
    set(handles.TxtAccueil,'String',strvcat('Test BMLD dans le bruit', ' ','S�lectionner les param�tres puis cliquez sur D�marrer pour commencer    '));
end

cd Bruits
handles.masker=wavread(handles.Parametres.SSN);
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
set(handles.Txtalarm,'Visible','off');
set(handles.Result,'Visible','off');
set(handles.Score1,'Visible','off');
set(handles.Score2,'Visible','off');
set(handles.Score3,'Visible','off');
set(handles.Score4,'Visible','off');
set(handles.Score5,'Visible','off');
set(handles.Score6,'Visible','off');
set(handles.Score7,'Visible','off');
set(handles.Score8,'Visible','off');
set(handles.Score9,'Visible','off');
set(handles.Sound1,'Enable','off');
set(handles.Sound2,'Enable','off');


if handles.Parametres.Aud
set(handles.Ampli,'Enable','on');
else set(handles.Ampli,'Enable','off'); 
end

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes MLD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MLD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;

delete(handles.figure1);


% --- Executes on button press in Sound1.
function Sound1_Callback(hObject, eventdata, handles)
% hObject    handle to Sound1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Reponse=1;
guidata(hObject, handles);
uiresume;


% --- Executes on button press in Sound2.
function Sound2_Callback(hObject, eventdata, handles)
% hObject    handle to Sound2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Reponse=2;
guidata(hObject, handles);
uiresume;


% --- Executes on selection change in Duree.
function Duree_Callback(hObject, eventdata, handles)
% hObject    handle to Duree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Duree contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Duree
if get(hObject,'Value')==2, handles.dt=0.4;
elseif get(hObject,'Value')==3, handles.dt=1.0;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Duree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Duree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Fm.
function Fm_Callback(hObject, eventdata, handles)
% hObject    handle to Fm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Fm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Fm
if get(hObject,'Value')==2, handles.fm=0;
elseif get(hObject,'Value')==3, handles.fm=1;
elseif get(hObject,'Value')==4, handles.fm=2.5;
elseif get(hObject,'Value')==5, handles.fm=5;
elseif get(hObject,'Value')==6, handles.fm=10;
elseif get(hObject,'Value')==7, handles.fm=20;
end
guidata(hObject, handles);





function filtre=routine_CAMFIT2D(handles)
AudiogD = -handles.Parametres.AudiogD;

gabarit_dBD=[-100 (AudiogD(1)) (AudiogD(1)) (AudiogD(2)) (AudiogD(3)) (AudiogD(4)) (AudiogD(5)) (AudiogD(6)) (AudiogD(7)) -100 -100];

gabarit_freqD=[2.*[0 125 250 500 1000 2000 3000 4000 8000 10000] handles.Fs]./handles.Fs;

filtre=fir2(4096,gabarit_freqD,10.^(gabarit_dBD/20));


function filtre=routine_CAMFIT2G(handles)
AudiogG = -handles.Parametres.AudiogG;

gabarit_dBG=[-100 (AudiogG(1)) (AudiogG(1)) (AudiogG(2)) (AudiogG(3)) (AudiogG(4)) (AudiogG(5)) (AudiogG(6)) (AudiogG(7)) -100 -100];

gabarit_freqG=[2.*[0 125 250 500 1000 2000 3000 4000 8000 10000] handles.Fs]./handles.Fs;

filtre=fir2(4096,gabarit_freqG,10.^(gabarit_dBG/20));


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



% --- Executes during object creation, after setting all properties.
function Fm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

 
 

function routine_alloff(handles)
set(handles.Sound1,'Enable','off');
set(handles.Sound2,'Enable','off');



% --- Executes on selection change in Fp.
function Fp_Callback(hObject, eventdata, handles)
% hObject    handle to Fp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Fp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Fp
if get(hObject,'Value')==2, handles.fp=250;
elseif get(hObject,'Value')==3, handles.fp=500;
elseif get(hObject,'Value')==4, handles.fp=750;   
elseif get(hObject,'Value')==5, handles.fp=1000;
elseif get(hObject,'Value')==6, handles.fp=2000;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Fp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Ampli.
function Ampli_Callback(hObject, eventdata, handles)
% hObject    handle to Ampli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Ampli contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ampli
if get(hObject,'Value')==2, handles.ampli=1;
elseif get(hObject,'Value')==3, handles.ampli=2;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Ampli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ampli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Mod.
function Mod_Callback(hObject, eventdata, handles)
% hObject    handle to Mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Mod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Mod

if get(hObject,'Value')==2, handles.mod = 1; %BMLD tone
    set(handles.Fm,'Enable','off');    
    set(handles.rsb,'Enable','off'); 
elseif get(hObject,'Value')==3, handles.mod = 2;  %BMLD SAM
    set(handles.Fm,'Enable','on');
    set(handles.rsb,'Enable','on'); 
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Mod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Phase.
function Phase_Callback(hObject, eventdata, handles)
% hObject    handle to Phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Phase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Phase

if get(hObject,'Value')==2, handles.phase = 1;      % NOSII 
elseif get(hObject,'Value')==3, handles.phase = 2;  % NOSO
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dirCODE='C:\Users\Nicolas ENS\Documents\Doctorat\Projet AM\Code\V3\'; %Equipe Audition laptop 
addpath (strcat(dirCODE,'gtfb\'));

set(hObject,'Enable','off');
set(hObject,'Visible','off');
set(handles.TxtAccueil,'Visible','off');
set(handles.Mod,'Enable','off');
set(handles.Fp,'Enable','off');
set(handles.Fm,'Enable','off');
set(handles.Duree,'Enable','off');
set(handles.Ampli,'Enable','off');
set(handles.Phase,'Enable','off');
set(handles.Sound1,'Enable','on');
set(handles.Sound2,'Enable','on');


if handles.fp==250;
    if exist('Data250.log','file')
    load -mat Data250.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end
elseif handles.fp==500;
    if exist('Data500.log','file')
    load -mat Data500.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end
elseif handles.fp==750;    
    if exist('Data750.log','file')
    load -mat Data750.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end
elseif handles.fp==1000;    
    if exist('Data1000.log','file')
    load -mat Data1000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end    
elseif handles.fp==2000;    
    if exist('Data2000.log','file')
    load -mat Data2000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end  
elseif handles.fp==4000;
    if exist('Data4000.log','file')
    load -mat Data4000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end  
else handles.error=1;
end

if handles.Parametres.Aud
   if handles.ampli==1;
   handles.audiofilt1=routine_CAMFIT2D(handles); 
   handles.audiofilt2=routine_CAMFIT2G(handles);   
   elseif handles.ampli==2;
   handles.audiofilt1=routine_CAMFITD(handles); 
   handles.audiofilt2=routine_CAMFITG(handles); 
   end
end

if handles.Parametres.Aud
Audiofilt1=handles.audiofilt1;
Audiofilt2=handles.audiofilt2; end


set(hObject,'Enable','off');    % Supprimer le bouton Start apr�s pression


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

Scale=handles.Scale;
Fs = 44100;
low_cf=80; % low cutoff frequency for audio filtering 
high_cf=8000; % high cutoff frequency for audio filtering 

rand('state',sum(100*clock));

fp=handles.fp;      % carrier frequency

if handles.mod==1
fm=0;
else fm=handles.fm;     end  % modulation frequency

dt = handles.dt;        % lenght of target and standard
rsbSAM = handles.rsb;   % signal to noise ratio of the SAM in modulated BMLD

duree_targ = dt*Fs;    % target duration = 1 sec
duree_stand = dt*Fs;   % standard duration = 1 sec

duree_ramp = round(0.1*Fs);        %Cosine ramp duration = 100ms
freq_ramp = 1/(2*0.1);

t_stim = 1:duree_targ;

amp=1;
m=0.8;                   %Modulation depth starting value = 0.8


%silent interval parameters
duree_sil = 0.4*Fs;     %silence duration = 0.5 sec
silence = zeros(duree_sil,1);

%2I2AFC parameters
nb_essais_max = 150;
Tab_m = zeros(nb_essais_max,1); % cr�ation tableau remplis de 0 � 1 colonne et autant de ligne que le nb d'essai max
Tab_gain = zeros(nb_essais_max,1); % cr�ation tableau remplis de 0 � 1 colonne et autant de ligne que le nb d'essai max

Essais_corrects = 0;
Nb_inversions = 0;
max_inversions_1 = 2;   %nb d'inversion avant modification du pas
max_inversions_2 = 12;  % nb d'inversion avec le pas final

dB_down_1 = 4;          % pas initial en dB /initial step adaptive staircase
dB_down_2 = 2;          % pas final en dB/ final step adaptive staircase

lin_down_1 = 10.^(dB_down_1/20);    
lin_down_2 = 10.^(dB_down_2/20);


%initialisation loop
if     handles.mod == 1
Facteur_down = dB_down_1;
else
Facteur_down = lin_down_1;        
end

% Facteur_down = dB_down_1;      % d�part avec pas initial
Essai = 0;
%handles.Reponse = 0;
Nb_trials = 0;
Nb_correct_trials = 0;

% zero padding 50ms ante et post stim
duree_zero = 0.05*Fs;
padding = zeros(duree_zero,1);

%sine ramps
tmp = 1:duree_ramp;
onset  = (1+sin(2*pi*freq_ramp*tmp./Fs + (-pi/2)))/2;
offset = (1+sin(2*pi*freq_ramp*tmp./Fs + (pi/2)))/2;
steady = ones(1,duree_targ - (2*duree_ramp));
ramp_vector = [onset steady offset];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gainSAM = 10;        % Pr�sentation du Sinus � un RS/B de 10dB au d�part soit 90dB si stim � 80dB. 
while Essai<nb_essais_max
    Essai = Essai + 1;
    
    if handles.mod == 1
        
    Tab_gain(Essai) = gainSAM;
    else
    Tab_m(Essai) = m;
    end
        
if  handles.mod == 1;  % BMLD noise unmodulated
    
    if handles.phase == 1;%NOSpi
    modulation_target1 =(sin(2*pi*fp*t_stim./Fs + pi));    %NOSpi unmodulated
    modulation_target2 =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated 
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter
    noise_target = ramp_vector .* (noise_target);
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    noise_target = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1.*10.^(gainSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target1 = target1 + noise_target; % Addition Noise et Signal
    
    target2 = ramp_vector .* (modulation_target2);
    target2 = [padding' target2 padding'];
    target2 = target2 ./ sqrt(mean(target2.^2));
    target2 = target2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target2 = target2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target2 = target2.*10.^(gainSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target2 = target2 + noise_target; % Addition Noise et Signal
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter    
    standard = ramp_vector .*noise_target;
    standard  = [padding' standard  padding'];
    standard = standard ./ sqrt(mean(standard.^2));
    standard = standard.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard = standard ./ Scale;       

    elseif handles.phase == 2;%NOS0   
    modulation_target1 =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated
    modulation_target2 =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated 
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter
    noise_target = ramp_vector .* (noise_target);
    
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    noise_target = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1.*10.^(gainSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target1 = target1 + noise_target; % Addition Noise et Signal
    
        
    target2 = ramp_vector .* (modulation_target2);
    target2 = [padding' target2 padding'];
    target2 = target2 ./ sqrt(mean(target2.^2));
    target2 = target2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target2 = target2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target2 = target2.*10.^(gainSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target2 = target2 + noise_target; % Addition Noise et Signal
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter    
    standard = ramp_vector .*noise_target;
    standard  = [padding' standard  padding'];
    standard = standard ./ sqrt(mean(standard.^2));
    standard = standard.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard = standard ./ Scale;       
    
    end

 
elseif  handles.mod == 2;  % BMLD with SAM

    if handles.phase == 1;% NOSpi
        if rsbSAM ==90;
    modulation_target1 =(1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + pi));    %NOSpi modulated
    modulation_target2 =(1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + 0));    %NOSpi modulated 
    
    modulation_standard1 =(sin(2*pi*fp*t_stim./Fs + pi));    %NOS0 unmodulated
    modulation_standard2 =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter
    noise_target = ramp_vector .* (noise_target);
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    noise_target = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    noise_target = noise_target.*10.^(-rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
        
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1 + noise_target; % Addition Noise et Signal
            
    target2 = ramp_vector .* (modulation_target2);
    target2 = [padding' target2 padding'];
    target2 = target2 ./ sqrt(mean(target2.^2));
    target2 = target2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target2 = target2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target2 = target2 + noise_target; % Addition Noise et Signal
    
    standard1 = ramp_vector .* (modulation_standard1);
    standard1 = [padding' standard1 padding'];
    standard1 = standard1 ./ sqrt(mean(standard1.^2));
    standard1 = standard1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard1 = standard1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    standard1 = standard1 + noise_target; % Addition Noise et Signal
        
    standard2 = ramp_vector .* (modulation_standard2);
    standard2 = [padding' standard2 padding'];
    standard2 = standard2 ./ sqrt(mean(standard2.^2));
    standard2 = standard2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard2 = standard2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    standard2 = standard2 + noise_target; % Addition Noise et Signal
                
            
            
        else    
    modulation_target1 =(1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + pi));    %NOSpi modulated
    modulation_target2 =(1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + 0));    %NOSpi modulated 
    
    modulation_standard1 =(sin(2*pi*fp*t_stim./Fs + pi));    %NOS0 unmodulated
    modulation_standard2 =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter
    noise_target = ramp_vector .* (noise_target);
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    noise_target = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
        
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target1 = target1 + noise_target; % Addition Noise et Signal
            
    target2 = ramp_vector .* (modulation_target2);
    target2 = [padding' target2 padding'];
    target2 = target2 ./ sqrt(mean(target2.^2));
    target2 = target2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target2 = target2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target2 = target2.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target2 = target2 + noise_target; % Addition Noise et Signal
    
    standard1 = ramp_vector .* (modulation_standard1);
    standard1 = [padding' standard1 padding'];
    standard1 = standard1 ./ sqrt(mean(standard1.^2));
    standard1 = standard1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard1 = standard1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    standard1 = standard1.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    standard1 = standard1 + noise_target; % Addition Noise et Signal
        
    standard2 = ramp_vector .* (modulation_standard2);
    standard2 = [padding' standard2 padding'];
    standard2 = standard2 ./ sqrt(mean(standard2.^2));
    standard2 = standard2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard2 = standard2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    standard2 = standard2.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    standard2 = standard2 + noise_target; % Addition Noise et Signal
    
        end

    elseif handles.phase == 2;%NOS0
         if rsbSAM ==90;
    modulation_target1 = (1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + 0));   %NOS0 modulated
    modulation_target2 = (1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + 0));   %NOS0  modulated

    modulation_standard =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter
    noise_target = ramp_vector .* (noise_target);
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    noise_target = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    noise_target = noise_target.*10.^(-rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1 + noise_target; % Addition Noise et Signal
        
    target2 = ramp_vector .* (modulation_target2);
    target2 = [padding' target2 padding'];
    target2 = target2 ./ sqrt(mean(target2.^2));
    target2 = target2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target2 = target2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target2 = target2 + noise_target; % Addition Noise et Signal
    
    standard = ramp_vector .* (modulation_standard);
    standard = [padding' standard padding'];
    standard = standard ./ sqrt(mean(standard.^2));
    standard = standard.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard = standard ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    standard = standard + noise_target; % Addition Noise et Signal
    standard1= standard;
    standard2= standard;             
             
         else
    modulation_target1 = (1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + 0));   %NOS0 modulated
    modulation_target2 = (1 + m.*sin(2*pi*fm*t_stim./Fs + 0)).*(sin(2*pi*fp*t_stim./Fs + 0));   %NOS0  modulated

    modulation_standard =(sin(2*pi*fp*t_stim./Fs + 0));    %NOS0 unmodulated
    
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); %pass signal through filter
    noise_target = ramp_vector .* (noise_target);
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    noise_target = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target1 = target1 + noise_target; % Addition Noise et Signal
        
    target2 = ramp_vector .* (modulation_target2);
    target2 = [padding' target2 padding'];
    target2 = target2 ./ sqrt(mean(target2.^2));
    target2 = target2.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target2 = target2 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target2 = target2.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    target2 = target2 + noise_target; % Addition Noise et Signal
    
    standard = ramp_vector .* (modulation_standard);
    standard = [padding' standard padding'];
    standard = standard ./ sqrt(mean(standard.^2));
    standard = standard.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    standard = standard ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    standard = standard.*10.^(rsbSAM/20); % Correctif pour faire varier l'intensit� de SAM
    standard = standard + noise_target; % Addition Noise et Signal
    standard1= standard;
    standard2= standard;
         end
    end    
   
end
    

 
    %sound presentation
    zz=zeros(length(target1),1);
 
if handles.Parametres.Aud
    target1 = filter(Audiofilt1,1,target1);
    target2 = filter(Audiofilt2,1,target2);
    if handles.mod==1;
    standard1 = filter(Audiofilt1,1,standard);
    standard2 = filter(Audiofilt2,1,standard);
    else
    standard1 = filter(Audiofilt1,1,standard1);
    standard2 = filter(Audiofilt2,1,standard2);   
    end
else target1 = target1;
     target2= target2;
    if handles.mod==1;
    standard1 = standard;
    standard2 = standard;
    else
    standard1 = standard1;
    standard2 = standard2;   
    end  
end


    if rand(1,1)<0.5

    right_ear1=[target1];
    left_ear1=[target2];        

    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
    tplay([left_ear1' right_ear1],Fs);
        otherwise
    set(handles.text2,'string','Ecoutez');
    set(handles.Sound1,'BackgroundColor',[79/255 129/255 189/255]);   drawnow;
    wavplay([left_ear1' right_ear1'],Fs);
    set(handles.Sound1,'BackgroundColor',[240/255 240/255 240/255]) ; drawnow;  
    end    
    
    right_ear2=[silence];
    left_ear2=zeros(length(right_ear2),1);  

    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
        tplay([left_ear2 right_ear2],Fs);
    otherwise
        wavplay([left_ear2 right_ear2],Fs);
    end        
    
    
    right_ear3=[standard1];
    left_ear3=[standard2];         
        
    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
        tplay([left_ear3' right_ear3'],Fs); 
    otherwise
    set(handles.Sound2,'BackgroundColor',[79/255 129/255 189/255]);  drawnow;      
        wavplay([left_ear3' right_ear3'],Fs);
    set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]) ;   drawnow;
    set(handles.text2,'string','Lequel des trois sons contient l indice?');
    end
    

    reponse_correcte = 1;
    




    else

    right_ear1=[standard1];
    left_ear1=[standard2];        

    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
    tplay([left_ear1' right_ear1],Fs);
        otherwise
    set(handles.text2,'string','Ecoutez');
    set(handles.Sound1,'BackgroundColor',[79/255 129/255 189/255]);   drawnow;
    wavplay([left_ear1' right_ear1'],Fs);
    set(handles.Sound1,'BackgroundColor',[240/255 240/255 240/255]) ; drawnow;  
    end    
    
    
    right_ear2=[silence];
    left_ear2=zeros(length(right_ear2),1);  

    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
        tplay([left_ear2 right_ear2],Fs);
    otherwise
        wavplay([left_ear2 right_ear2],Fs);
    end        
    
    
    right_ear5=[target1];
    left_ear5=[target2];         
        
    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
        tplay([left_ear5' right_ear5],Fs); 
    otherwise
    set(handles.Sound2,'BackgroundColor',[79/255 129/255 189/255]);  drawnow;      
        wavplay([left_ear5' right_ear5'],Fs);
    set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]) ;   drawnow;
    set(handles.text2,'string','Lequel des trois sons contient l indice?');
    end                    
    reponse_correcte = 2;    
    
    end


uiwait;
handles = guidata(hObject);
    
    %Feedback
    if handles.Reponse == reponse_correcte
        Rep = 'OUI'; Rep_inv = 1;
    else
        Rep = 'NON'; Rep_inv = 0;
    end
  
      if (handles.Reponse==1) & (Rep == 'OUI')
        %display('OUI Reponse 1 correcte');
        set(handles.Sound1,'BackgroundColor',[146/255 208/255 80/255]);
        pause(1)
        set(handles.Sound1,'BackgroundColor',[240/255 240/255 240/255]);
        pause(0.5)
    elseif(handles.Reponse==1) & (Rep == 'NON')
        %display('NON Reponse 2 correcte');
        set(handles.Sound2,'BackgroundColor',[204/255 0/255 0/255]);
        pause(1)
        set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]);
        pause(0.5)
    elseif(handles.Reponse==2) & (Rep == 'OUI')
        %display('OUI reponse 2 correcte');
        set(handles.Sound2,'BackgroundColor',[146/255 208/255 80/255]);
        pause(1)
        set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]);
        pause(0.5)
    elseif(handles.Reponse==2) & (Rep == 'NON');
        %display('NON Reponse 1 correcte');
        set(handles.Sound1,'BackgroundColor',[204/255 0/255 0/255]);
        pause(1)
        set(handles.Sound1,'BackgroundColor',[240/255 240/255 240/255]);
        pause(0.5)
    end
    
    %calculation of inversions
    if Essai ==1,
        Rep1=Rep_inv;
        Rep2=Rep_inv;
    end

    Rep3 = Rep2;
    Rep2 = Rep1;
    Rep1 = Rep_inv;
    
    Vector = [Rep3 Rep2 Rep1]; %keep the last 3 answers
    inv1=[1 1 0];   %valley in staircaise
    inv2=[0 1 1];   %peak in staircase
    
    test1 = (Vector == inv1);
    test2 = (Vector == inv2);
    S=(sum(test1) == 3);
    T=(sum(test2) == 3);
    
    if xor(S,T)
        Nb_inversions = Nb_inversions + 1;
        if     handles.mod == 1
        Tab_invSAM(Nb_inversions) = gainSAM;
        else
        Tab_inv(Nb_inversions) = m;
        Tab_invdB(Nb_inversions) = 20*log10(m);         
        end
    end
    
    %go from step 1 to step 2 in staicase
    if Nb_inversions == max_inversions_1
        if     handles.mod == 1
        Facteur_down = dB_down_2;
        else
        Facteur_down = lin_down_2;        
        end
    end
    
    %one up
    if Rep == 'OUI'
        Essais_corrects = Essais_corrects + 1;
    else
        Essais_corrects = 0;
        if handles.mod == 1
        gainSAM = gainSAM + Facteur_down;
        else 
        if m<1, m=m.*Facteur_down;end
        end
    end
    
    %Two down
    if Essais_corrects == 2
        if handles.mod == 1
        gainSAM = gainSAM - Facteur_down;
        Essais_corrects = 0;
        else
        m = m./Facteur_down;
        Essais_corrects = 0;
        end        
     end
    
    
   %percent correct from 6th reversal
   
   if Nb_inversions > 6
       Nb_trials = Nb_trials + 1;
       if Rep == 'OUI'
           Nb_correct_trials = Nb_correct_trials + 1;
       end
   else
       Nb_trials = 0;
       Nb_correct_trials = 0;
   end
   
   
   %final stop
   if Nb_inversions == max_inversions_2
       break
   end
   
   handles.Reponse == 0;
end

% close;


if handles.mod == 1;
plot(Tab_gain)     %Tab_m adaptive staircase
else 
plot(Tab_m)     %Tab_m adaptive staircase
Tab_m = Tab_m;
end   



%%%%%%%%%%%%%%%%%%%%%%%
set(handles.Score1,'Visible','on');
set(handles.Score2,'Visible','on');
set(handles.Score3,'Visible','on');
set(handles.Score4,'Visible','on');
set(handles.Score5,'Visible','on');
set(handles.Sound1,'Visible','off');
set(handles.Sound2,'Visible','off');

% 
set(handles.Score7,'Visible','on');
set(handles.Score8,'Visible','on');



if     handles.mod == 1
handles.Seuil_arith =mean(Tab_invSAM(7:16));          % Moyenne de m
handles.STD_Seuil = std(Tab_invSAM(7:16));           % Ecart type de m
handles.Seuil_geo = (prod(abs(Tab_invSAM(7:16)))).^(1/10);
handles.Seuil_arithdB =handles.level + mean(Tab_invSAM(7:16));          % Moyenne du seuil en dB
handles.STD_SeuildB = handles.level;
handles.Seuil_geodB = handles.level + (prod(abs(Tab_invSAM(7:16)))).^(1/10);
handles.Essai=Essai;
handles.perf = round((Nb_correct_trials./Nb_trials)*100);
set(handles.Score1,'String',['RSB_arith:  ',num2str(handles.Seuil_arith,'%6.2f'),'dB']);
set(handles.Score2,'String',['STD_RSB:  ',num2str(handles.STD_Seuil,'%6.2f'),'dB']);
set(handles.Score3,'String',['RSB_geo:  ',num2str(handles.Seuil_geo,'%6.2f'),'dB']);
set(handles.Score4,'String',['Essai:  ',num2str(handles.Essai,'%6.2f')]);
set(handles.Score5,'String',['Perf:  ',num2str(handles.perf,'%6.2f'),'%']);
set(handles.Score7,'String',['Seuil_dBSPL:  ',num2str(handles.Seuil_arithdB,'%6.2f'),'dBSPL']);
set(handles.Score8,'String',['Niv_bruit:  ',num2str(handles.STD_SeuildB,'%6.2f'),'dBSPL']);


elseif handles.mod == 2
set(handles.Score9,'Visible','on');
handles.Seuil_arith =mean(Tab_inv(7:12)) *100;          % Moyenne de m
handles.STD_Seuil = std(Tab_inv(7:12))  *100;           % Ecart type de m
handles.Seuil_geo = (prod(abs(Tab_inv(7:12)))).^(1/10) *100;
handles.Seuil_arithdB =mean(Tab_invdB(7:12));          % Moyenne de m en dB
handles.STD_SeuildB = std(Tab_invdB(7:12));           % Ecart type de m en dB
handles.Seuil_geodB = (prod(abs(Tab_invdB(7:12)))).^(1/10);
handles.Essai=Essai;
handles.perf = round((Nb_correct_trials./Nb_trials)*100);
set(handles.Score1,'String',['Seuil_arith:  ',num2str(handles.Seuil_arith,'%6.2f'),'%']);
set(handles.Score2,'String',['STD_Seuil:  ',num2str(handles.STD_Seuil,'%6.2f'),'%']);
set(handles.Score3,'String',['Seuil_geo:  ',num2str(handles.Seuil_geo,'%6.2f'),'%']);
set(handles.Score4,'String',['Essai:  ',num2str(handles.Essai,'%6.2f')]);
set(handles.Score5,'String',['Perf:  ',num2str(handles.perf,'%6.2f'),'%']);
set(handles.Score7,'String',['Seui-arith:  ',num2str(handles.Seuil_arithdB,'%6.2f'),'dB']);
set(handles.Score8,'String',['STD_seuil:  ',num2str(handles.STD_SeuildB,'%6.2f'),'dB']);
set(handles.Score9,'String',['Seuil_geo:  ',num2str(handles.Seuil_geodB,'%6.2f'),'dB']);

end
    

pause (4);

if handles.mod == 1
handles.task='MLDs';
else 
handles.task='MLDm';
end

if handles.fp==250, handles.freqp='0.25';
elseif handles.fp==500, handles.freqp='0.50';
elseif handles.fp==750, handles.freqp='0.75';
elseif handles.fp==1000, handles.freqp='1.00';
elseif handles.fp==2000, handles.freqp='2.00'; end

if handles.mod==2
if handles.fm==0.0 ;
elseif handles.fm==1.0, handles.freqm='1.0';
elseif handles.fm==2.5, handles.freqm='2.5';
elseif handles.fm==5.0, handles.freqm='5.0';
elseif handles.fm==10., handles.freqm='10.';
elseif handles.fm==20., handles.freqm='20.';end 
else handles.freqm='0.0';
end

if dt==1.0 , handles.dut= '1.0';
elseif dt==0.4 , handles.dut= '0.4'; end

if handles.rsb==-9;handles.nivrsb ='-9';
elseif handles.rsb==-6;handles.nivrsb ='-6';
elseif handles.rsb==-3;handles.nivrsb ='-3';
elseif handles.rsb==0;handles.nivrsb ='+0';
elseif handles.rsb==3;handles.nivrsb ='+3';
elseif handles.rsb==6;handles.nivrsb ='+6';
elseif handles.rsb==9;handles.nivrsb ='+9';
else handles.nivrsb ='90'; end


if handles.mod == 1
mat = [Tab_gain'];
else 
mat = [Tab_m'];
end

if handles.phase == 1
    handles.condition='NOSp';
else handles.condition='NOS0'; end

handles.Nom = handles.Parametres.Code;
handles.output=struct('results',[handles.Seuil_arith handles.STD_Seuil handles.Seuil_geo handles.Essai handles.perf handles.Seuil_arithdB handles.STD_SeuildB handles.Seuil_geodB],'param',[handles.task handles.condition handles.freqm handles.freqp handles.dut handles.nivrsb]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd Resultats
if exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition, '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep1', '.txt'), 'mat','-ascii')
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep1', '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep2', '.txt'), 'mat','-ascii')
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep2', '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep3', '.txt'), 'mat','-ascii')
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep3', '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep4', '.txt'), 'mat','-ascii')
else save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'-',handles.condition,'_Rep1', '.txt'), 'mat','-ascii');end

cd ..

guidata(hObject, handles)
 uiresume(handles.figure1)


% --- Executes on selection change in rsb.
function rsb_Callback(hObject, eventdata, handles)
% hObject    handle to rsb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rsb contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rsb
if get(hObject,'Value')==2, handles.rsb=-9;
elseif get(hObject,'Value')==3, handles.rsb=-6;
elseif get(hObject,'Value')==4, handles.rsb=-3;
elseif get(hObject,'Value')==5, handles.rsb=0;
elseif get(hObject,'Value')==6, handles.rsb=3;    
elseif get(hObject,'Value')==7, handles.rsb=6;        
elseif get(hObject,'Value')==8, handles.rsb=9;     
elseif get(hObject,'Value')==9, handles.rsb=90;   
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rsb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



