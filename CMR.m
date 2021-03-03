function varargout = CMR(varargin)
% CMR M-file for CMR.fig
%      CMR, by itself, creates a new CMR or raises the existing
%      singleton*.
%
%      H = CMR returns the handle to a new CMR or the handle to
%      the existing singleton*.
%
%      CMR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CMR.M with the given input arguments.
%
%      CMR('Property','Value',...) creates a new CMR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CMR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CMR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CMR

% Last Modified by GUIDE v2.5 07-Mar-2014 16:02:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CMR_OpeningFcn, ...
                   'gui_OutputFcn',  @CMR_OutputFcn, ...
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


% --- Executes just before CMR is made visible.
function CMR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CMR (see VARARGIN)

% Choose default command line output for CMR
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
% UIWAIT makes CMR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CMR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

delete(handles.figure1);



function routine_alloff(handles)
set(handles.Sound1,'Enable','off');
set(handles.Sound2,'Enable','off');





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
elseif get(hObject,'Value')==3, handles.dt=1;
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
%        contents{get(hObject,'Value')} returns selected item from Fm
if get(hObject,'Value')==2, handles.fm=0.0;
elseif get(hObject,'Value')==3, handles.fm=1.0;
elseif get(hObject,'Value')==4, handles.fm=2.5;
elseif get(hObject,'Value')==5, handles.fm=5.0;
elseif get(hObject,'Value')==6, handles.fm=10.;
elseif get(hObject,'Value')==7, handles.fm=20.;
end
guidata(hObject, handles);


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



% --- Executes during object creation, after setting all properties.
function Fp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in text12.
function Fp_Callback(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns text12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text12
if get(hObject,'Value')==2, handles.fp=0.25;
elseif get(hObject,'Value')==3, handles.fp=0.50;
elseif get(hObject,'Value')==4, handles.fp=0.75;   
elseif get(hObject,'Value')==5, handles.fp=1.00
elseif get(hObject,'Value')==6, handles.fp=2.00;
end
handles.fp = handles.fp*1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function text12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BPnoise.
function BPnoise_Callback(hObject, eventdata, handles)
% hObject    handle to BPnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BPnoise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BPnoise
if get(hObject,'Value')==2, handles.BWnoise=1;
elseif get(hObject,'Value')==3, handles.BWnoise=2;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BPnoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BPnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
set(handles.text12,'Enable','off');
set(handles.Fp,'Enable','off');
set(handles.Fm,'Enable','off');
set(handles.Duree,'Enable','off');
set(handles.Ampli,'Enable','off');
set(handles.BPnoise,'Enable','off');
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
rand('state',sum(100*clock));

fp=handles.fp;      % carrier frequency

if handles.mod==1;
    fm = 0.0;
else fm=handles. fm;  end % modulation frequency

dt = handles.dt;        % lenght of target and standard

duree_targ = dt*Fs;    % target duration
duree_stand = dt*Fs;   % standard duration

duree_ramp = round(0.1*Fs);        %Cosine ramp duration = 100ms
freq_ramp = 1/(2*0.1);

t_stim = 1:duree_targ;

amp=1;
m=1;                   %Modulation depth = 1


if handles.Parametres.Aud
   if handles.ampli==1 && handles.Parametres.Oreille == 2;
   handles.audiofilt1=routine_CAMFIT2D(handles); 
   elseif handles.ampli==1 && handles.Parametres.Oreille == 3;   
   handles.audiofilt2=routine_CAMFIT2G(handles);
   elseif handles.ampli==1 && handles.Parametres.Oreille == 4;
   handles.audiofilt1=routine_CAMFIT2D(handles);        
   handles.audiofilt2=routine_CAMFIT2G(handles);
   elseif handles.ampli==2 && handles.Parametres.Oreille == 2;
   handles.audiofilt1=routine_CAMFITD(handles); 
   elseif handles.ampli==2 && handles.Parametres.Oreille == 3;   
   handles.audiofilt2=routine_CAMFITG(handles);
   elseif handles.ampli==2 && handles.Parametres.Oreille == 4;
   handles.audiofilt1=routine_CAMFITD(handles);        
   handles.audiofilt2=routine_CAMFITG(handles);
   end
end

if handles.Parametres.Aud && handles.Parametres.Oreille == 2;
Audiofilt1=handles.audiofilt1;
elseif handles.Parametres.Aud && handles.Parametres.Oreille == 3;
Audiofilt2=handles.audiofilt2;
elseif handles.Parametres.Aud && handles.Parametres.Oreille == 4;
Audiofilt1=handles.audiofilt1;  
Audiofilt2=handles.audiofilt2;
end



%silent interval parameters
duree_sil = 0.4*Fs;     %silence duration = 0.5 sec =0,4+2x0,05 padding
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


%initialisation loop 
Facteur_down = dB_down_1; % CMR in steady noise


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

gainSAM = 0;        % Pr�sentation du Sinus � un RS/B de 0dB au d�part soit 90dB si stim � 80dB. 
while Essai<nb_essais_max
    Essai = Essai + 1;
    Tab_gain(Essai) = gainSAM;

    modulation_target1 =(sin(2*pi*fp*t_stim./Fs + 2*pi*rand(1,1)));    %Son cible
     
    noise_target = (amp*randn(1,duree_stand));   % G�n�ration du bruit entre low_cf et high_cf (fixe)
    if handles.BWnoise==2    
    gt = GammaChirp(fp,Fs,4,1.019,0,0,[],'peak');
    noise_target = fftfilt(gt,noise_target); end %pass signal through filter

    if  handles.mod == 2;  % CMR modulated
    noise_target = (1 + m.*sin(2*pi*fm*t_stim./Fs + 2*pi*rand(1,1))).*noise_target; end

    noise_target = ramp_vector .* (noise_target);
    noise_target = [padding' noise_target padding'];
    noise_target = noise_target ./ sqrt(mean(noise_target.^2)); % Normalisation RMS
    standard = noise_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    
    target1 = ramp_vector .* (modulation_target1);
    target1 = [padding' target1 padding'];
    target1 = target1 ./ sqrt(mean(target1.^2));
    target1 = target1.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
    target1 = target1 ./ Scale; % Mettre le bruit au dB SPL chosi dans intellitest
    target1 = target1.*10.^(gainSAM/20); 
    target = target1 + standard; % Addition Noise et Signal


   
%%%%%%%%%%%%%%%% S�lection de l'oreille %%%%%%%%%%%%%%%%%%%%
if length(target)==size(target,2), target=target';end
if length(standard)==size(standard,2), standard=standard';end
if length(silence)==size(silence,2), silence=silence;end
zz=zeros(length(target),1);
zzz=zeros(length(standard),1);
zzzz=zeros(length(silence),1);
      
if handles.Parametres.Aud && handles.Parametres.Oreille == 2;
    target1 = filter(Audiofilt1,1,target);
    standard1 = filter(Audiofilt1,1,standard);
elseif handles.Parametres.Aud && handles.Parametres.Oreille ==3;
    target2 = filter(Audiofilt2,1,target);
    standard2 = filter(Audiofilt2,1,standard);    
elseif handles.Parametres.Aud && handles.Parametres.Oreille ==4;
    target1 = filter(Audiofilt1,1,target);
    standard1 = filter(Audiofilt1,1,standard);   
    target2 = filter(Audiofilt2,1,target);
    standard2 = filter(Audiofilt2,1,standard);     
else target1 = target;
     target2= target;
     standard1 =standard;
     standard2 =standard;
end


    if handles.Parametres.Oreille == 2,
        target = [zz target1];
        standard = [zzz standard1];
    elseif handles.Parametres.Oreille == 3,
        target = [target2 zz];
        standard = [standard2 zzz];
    else 
        target = [target2 target1];
        standard = [standard2 standard1];
    end 
              
    
    
    if rand(1,1)<0.5

    set(handles.text22,'string','Ecoutez');    
    set(handles.Sound1,'BackgroundColor',[79/255 129/255 189/255]);   drawnow;
    wavplay(target,Fs);
    set(handles.Sound1,'BackgroundColor',[240/255 240/255 240/255]) ; drawnow;  
        
    wavplay(silence,Fs);
    
    set(handles.Sound2,'BackgroundColor',[79/255 129/255 189/255]);  drawnow;      
    wavplay(standard,Fs);
    set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]) ;   drawnow;
     
    set(handles.text22,'string','Lequel des trois sons contient des fluctuations?');
    reponse_correcte = 1;
    
    else
    
    set(handles.text22,'string','Ecoutez');    
    set(handles.Sound1,'BackgroundColor',[79/255 129/255 189/255]);   drawnow;
    wavplay(standard,Fs);
    set(handles.Sound1,'BackgroundColor',[240/255 240/255 240/255]) ; drawnow;  
        
    wavplay(silence,Fs);
    
    set(handles.Sound2,'BackgroundColor',[79/255 129/255 189/255]);  drawnow;      
    wavplay(target,Fs);
    set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]) ;   drawnow;    
    
    set(handles.text22,'string','Lequel des trois sons contient des fluctuations?');
    reponse_correcte = 2;   
 
    end


%Reponse = input('1 ou 2');
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
        Tab_invSAM(Nb_inversions) = gainSAM;
    end
    
    %go from step 1 to step 2 in staicase
    if Nb_inversions == max_inversions_1
        Facteur_down = dB_down_2;
    end
    
    %one up
    if Rep == 'OUI'
        Essais_corrects = Essais_corrects + 1;
    else
        Essais_corrects = 0;
        gainSAM = gainSAM + Facteur_down;
    end
    
    %Two down
    if Essais_corrects == 2
        gainSAM = gainSAM - Facteur_down;
        Essais_corrects = 0;
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


plot(Tab_gain)     %Tab_m adaptive staircase


%%%%%%%%%%%%%%%%%%%%%%%
set(handles.Score1,'Visible','on');
set(handles.Score2,'Visible','on');
set(handles.Score3,'Visible','on');
set(handles.Score4,'Visible','on');
set(handles.Score5,'Visible','on');
set(handles.Sound1,'Visible','off');
set(handles.Sound2,'Visible','off');
set(handles.text22,'Visible','off');
set(handles.Score7,'Visible','on');
set(handles.Score8,'Visible','on');



handles.Seuil_arith =mean(Tab_invSAM(7:12));          % Moyenne de m
handles.STD_Seuil = std(Tab_invSAM(7:12));           % Ecart type de m
handles.Seuil_geo = (prod(abs(Tab_invSAM(7:12)))).^(1/10);
handles.Seuil_arithdB =handles.level + mean(Tab_invSAM(7:12));          % Moyenne du seuil en dB
handles.STD_SeuildB = handles.level;
handles.Seuil_geodB = handles.level+(prod(abs(Tab_invSAM(7:12)))).^(1/10);
handles.Essai=Essai;
handles.perf = round((Nb_correct_trials./Nb_trials)*100);
set(handles.Score1,'String',['RSB_arith:  ',num2str(handles.Seuil_arith,'%6.2f'),'dB']);
set(handles.Score2,'String',['STD_RSB:  ',num2str(handles.STD_Seuil,'%6.2f'),'dB']);
set(handles.Score3,'String',['RSB_geo:  ',num2str(handles.Seuil_geo,'%6.2f'),'dB']);
set(handles.Score4,'String',['Essai:  ',num2str(handles.Essai,'%6.2f')]);
set(handles.Score5,'String',['Perf:  ',num2str(handles.perf,'%6.2f'),'%']);
set(handles.Score7,'String',['Seuil_dBSPL:  ',num2str(handles.Seuil_arithdB,'%6.2f'),'dBSPL']);
set(handles.Score8,'String',['Niv_bruit:  ',num2str(handles.STD_SeuildB,'%6.2f'),'dBSPL']);

pause(4);

if handles.mod == 1
handles.task='CMRs';
else 
handles.task='CMRm';
end

if handles.mod==2
if handles.fm==0.0 ;
elseif handles.fm==1.0, handles.freqm='1.0';
elseif handles.fm==2.5, handles.freqm='2.5';
elseif handles.fm==5.0, handles.freqm='5.0';
elseif handles.fm==10., handles.freqm='10.';
elseif handles.fm==20., handles.freqm='20.';end 
else handles.freqm='0.0';
end

if handles.fp==250, handles.freqp='0.25';
elseif handles.fp==500, handles.freqp='0.50';
elseif handles.fp==750, handles.freqp='0.75';
elseif handles.fp==1000, handles.freqp='1.00';
elseif handles.fp==2000, handles.freqp='2.00'; end

if dt==1.0 , handles.dut= '1.0';
elseif dt==0.4 , handles.dut= '0.4'; end


mat = [Tab_gain'];

handles.Nom = handles.Parametres.Code;
handles.output=struct('results',[handles.Seuil_arith handles.STD_Seuil handles.Seuil_geo handles.Essai handles.perf handles.Seuil_arithdB handles.STD_SeuildB],'param',[handles.task handles.freqm handles.freqp handles.dut]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd Resultats
if exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep1', '.txt'), 'mat','-ascii')
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep1', '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep2', '.txt'), 'mat','-ascii')
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep2', '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep3', '.txt'), 'mat','-ascii')
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep3', '.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep4', '.txt'), 'mat','-ascii')
else save(strcat(handles.Nom,'_',handles.task,'_',num2str(fm),'_',num2str(fp),'-',num2str(dt),'_Rep1', '.txt'), 'mat','-ascii');end

cd ..

guidata(hObject, handles)
 uiresume(handles.figure1)


% --- Executes on selection change in Ampli.
function Ampli_Callback(hObject, eventdata, handles)
% hObject    handle to Ampli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Ampli contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ampli
if get(hObject,'Value')==2, handles.ampli = 1;        % Full gain
elseif get(hObject,'Value')==3, handles.ampli = 2;    % Cambridge Formulae
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

if get(hObject,'Value')==2, handles.mod = 1;        % unmodulated
        set(handles.Fm,'Enable','off');
elseif get(hObject,'Value')==3, handles.mod = 2;    % modulated
        set(handles.Fm,'Enable','on');

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


