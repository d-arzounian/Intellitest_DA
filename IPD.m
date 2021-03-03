function varargout = IPD(varargin)
% IPD M-file for IPD.fig
%      IPD, by itself, creates a new IPD or raises the existing
%      singleton*.
%
%      H = IPD returns the handle to a new IPD or the handle to
%      the existing singleton*.
%
%      IPD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IPD.M with the given input arguments.
%
%      IPD('Property','Value',...) creates a new IPD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IPD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IPD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IPD

% Last Modified by GUIDE v2.5 07-May-2014 14:37:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IPD_OpeningFcn, ...
                   'gui_OutputFcn',  @IPD_OutputFcn, ...
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


% --- Executes just before IPD is made visible.
function IPD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IPD (see VARARGIN)

% Choose default command line output for IPD

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
    set(handles.TxtAccueil,'String',strvcat('                      Test IPD dans le silence','S�lectionner les param�tres puis cliquez sur D�marrer pour commencer    '));
else
    set(handles.TxtAccueil,'String',strvcat('Test IPD dans le bruit', ' ','S�lectionner les param�tres puis cliquez sur D�marrer pour commencer    '));
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
set(handles.axes1,'Visible','off');
set(handles.Txtalarm,'Visible','off');
set(handles.text2,'Visible','off');
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
set(handles.Fp,'Enable','on');
set(handles.Fm,'Enable','on');

if handles.Parametres.Aud
set(handles.ampli,'Enable','on');
else set(handles.ampli,'Enable','off'); 
end

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);




function Fp_Callback(hObject, eventdata, handles)
% hObject    handle to Fp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Fp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Fp

if get(hObject,'Value')==2, handles.Fp=250; 
elseif get(hObject,'Value')==3, handles.Fp=500; 
elseif get(hObject,'Value')==4, handles.Fp=750; 
elseif get(hObject,'Value')==5, handles.Fp=1000; 
elseif get(hObject,'Value')==6, handles.Fp=2000; 
end
set(hObject,'Enable','off');
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



% --- Executes on selection change in Fm.
function Fm_Callback(hObject, eventdata, handles)
% hObject    handle to Fm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Fm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Fm
if get(hObject,'Value')==2, handles.Fm=4; 
end
set(hObject,'Enable','off');
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




function filtre=routine_CAMFIT0(handles)
% AudiogD = -handles.Parametres.AudiogD;

gabarit_dBD=[-100 (0) (0) (0) (0) (0) (0) (0) (0) -100 -100];

gabarit_freqD=[2.*[0 125 250 500 1000 2000 3000 4000 8000 10000] handles.Fs]./handles.Fs;

filtre=fir2(4096,gabarit_freqD,10.^(gabarit_dBD/20));


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

function routine_alloff(handles)
set(handles.Sound1,'Enable','off');
set(handles.Sound2,'Enable','off');




% --- Outputs from this function are returned to the command line.
function varargout = IPD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(hObject,'Enable','off');
set(hObject,'Visible','off');
set(handles.TxtAccueil,'Visible','off');
set(handles.Condition,'Enable','off');
set(handles.Duree,'Enable','off');
set(handles.Sound1,'Enable','on');
set(handles.Sound2,'Enable','on');
set(handles.text2,'Visible','on');



if handles.Fp==250;
    if exist('Data250.log','file')
    load -mat Data250.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end
elseif handles.Fp==500;
    if exist('Data500.log','file')
    load -mat Data500.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end
elseif handles.Fp==750;    
    if exist('Data750.log','file')
    load -mat Data750.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end
elseif handles.Fp==1000;    
    if exist('Data1000.log','file')
    load -mat Data1000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end    
elseif handles.Fp==2000;    
    if exist('Data2000.log','file')
    load -mat Data2000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end  
elseif handles.Fp==4000;
    if exist('Data4000.log','file')
    load -mat Data4000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end%handles.Plugs = {'none','none','none'}; 
    end  
else handles.error=1;
end



set(hObject,'Enable','off');    % Supprimer le bouton Start apr�s pression


if handles.level==40, handles.Scale=handles.Levels.Sc40dB;
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

if handles.Parametres.Aud
   if handles.ampli==1;
   handles.audiofilt1=routine_CAMFIT2D(handles); 
   handles.audiofilt2=routine_CAMFIT2G(handles);   
   elseif handles.ampli==2;
   handles.audiofilt1=routine_CAMFITD(handles); 
   handles.audiofilt2=routine_CAMFITG(handles); 
   end
   else 
   handles.audiofilt1=routine_CAMFIT0(handles); 
   handles.audiofilt2=routine_CAMFIT0(handles); 
end
% if handles.Parametres.Aud
Audiofilt1=handles.audiofilt1;
Audiofilt2=handles.audiofilt2;



Fs = 44100;
fm= handles.Fm;       % modulation frequency
dt = handles.dt;        % lenght of target and standard

duree_targ = dt*Fs;    % target duration
duree_stand = dt*Fs;   % standard duration = 1 sec

t_stim = 1:duree_targ;
amp=1;
m=1;                   %Modulation depth starting value = 1


%silent interval parameters
duree_sil = 0.4*Fs;     %silence duration = 0.5 sec
silence = zeros(duree_sil,1);

%2I2AFC parameters
nb_essais_max = 150;
Tab_phase = zeros(nb_essais_max,1); % cr�ation tableau remplis de 0 � 1 colonne et autant de ligne que le nb d'essai max

Essais_corrects = 0;
Nb_inversions = 0;
max_inversions_1  = 2;   %nb d'inversion avant modification du pas
max_inversions_2 = 12;  % nb d'inversion avec le pas final

dB_down_1 = sqrt(2);          % pas initial de 1/4 d'octave  == 1 octave = log2(2)
dB_down_2 = sqrt(sqrt(2));          % pas final en dB/ final step adaptive staircase



%initialisation loop
Facteur_down = dB_down_1;      % d�part avec pas initial
Essai = 0;
%handles.Reponse = 0;
Nb_trials = 0;
Nb_correct_trials = 0;

% zero padding 50ms ante et post stim
duree_zero = 0.05*Fs;
padding = zeros(duree_zero,1);

% modulante
mod=sin(2*pi*fm*t_stim./Fs + 3*pi/2);

%ramps

if handles.Fm==4 
duree_ramp = 0.25*Fs; 
on = ones(1,duree_ramp);
off = zeros(1,duree_ramp);
if handles.dt ==0.5;
ramp_vector1 = [off on];
ramp_vector2 = [on off];
elseif handles.dt ==1.0;
ramp_vector1 = [off on off on];
ramp_vector2 = [on off on off];
elseif handles.dt ==1.5;
ramp_vector1 = [off on off on off on];
ramp_vector2 = [on off on off on off];end
% elseif handles.Fm==2.5
% duree_ramp = 0.4*Fs; 
% on = ones(1,duree_ramp);
% off = zeros(1,duree_ramp);
% if handles.dt ==0.8;
% ramp_vector1 = [off on];
% ramp_vector2 = [on off];
% elseif handles.dt ==1.6;
% ramp_vector1 = [off on off on];
% ramp_vector2 = [on off on off];end
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phase = pi;
while Essai<nb_essais_max
    Essai = Essai + 1;

    Tab_phase(Essai) = phase;
    Tab_phasems(Essai) = (phase*(1/handles.Fp)/(2*pi));
    
    modulation_standard = (1 + m.*mod).*sin(2*pi*handles.Fp*t_stim./Fs + 0); %modulation standard 
    modulation_standard = [padding' modulation_standard padding'];
    modulation_standard = modulation_standard ./ sqrt(mean(modulation_standard.^2)); % Normalisation RMS
    modulation_standard = modulation_standard ./ Scale; % Mettre le bruit au dB SPL voulu (fixe)
    
    if handles.condition == 1;              % Condition diochotique - tracking en fr�quence
    modulation_target1 = (1 + m.*mod).*sin(2*pi*handles.Fp*t_stim./Fs + phase);
    modulation_target2 = (1 + m.*mod).*sin(2*pi*handles.Fp*t_stim./Fs + 0);
    modulation_target1 = modulation_target1.*ramp_vector1 ;
    modulation_target2 = modulation_target2.*ramp_vector2 ;
    modulation_target = modulation_target1 + modulation_target2;
    
    elseif handles.condition == 2;          % Condition diotique 
    modulation_target1 = (1 + m.*mod).*sin(2*pi*handles.Fp*t_stim./Fs + 0);
    modulation_target2 = (1 + m.*mod).*sin(2*pi*handles.Fp*t_stim./Fs + 0);
    modulation_target1 = modulation_target1.*ramp_vector1 ;
    modulation_target2 = modulation_target2.*ramp_vector2 ;
    modulation_target = modulation_target1 + modulation_target2;   
    end
    
    modulation_target = [padding' modulation_target padding'];
    modulation_target = modulation_target ./ sqrt(mean(modulation_target.^2)); % Normalisation RMS
    modulation_target = modulation_target ./ Scale; % Mettre le bruit au dB SPL voulu (fixe) 

%%%%%%%%%%% Sound presentation %%%%%%%%%%%    
    
     
if handles.Parametres.Aud
    modulation_targetd = filter(Audiofilt1,1,modulation_target);
    modulation_targetg = filter(Audiofilt2,1,modulation_target);
    modulation_standardd = filter(Audiofilt1,1,modulation_standard);
    modulation_standardg = filter(Audiofilt2,1,modulation_standard);
else 

     modulation_targetd = filter(Audiofilt1,1,modulation_target);
     modulation_targetg = filter(Audiofilt2,1,modulation_target);
     modulation_standardd = filter(Audiofilt1,1,modulation_standard);
     modulation_standardg = filter(Audiofilt2,1,modulation_standard);

end
      
    if rand(1,1)<0.5

    right_ear1=[modulation_targetd];
    left_ear1=[modulation_standardg];        

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
    
    
    right_ear3=[modulation_standardd];
    left_ear3=[modulation_standardg];         
        
    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
        tplay([left_ear3' right_ear3'],Fs); 
    otherwise
    set(handles.Sound2,'BackgroundColor',[79/255 129/255 189/255]);  drawnow;      
        wavplay([left_ear3' right_ear3'],Fs);
    set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]) ;   drawnow;

    end       
    reponse_correcte = 1;
 

    else

    right_ear1=[modulation_standardd];
    left_ear1=[modulation_standardg];        

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
    
   
    right_ear5=[modulation_targetd];
    left_ear5=[modulation_standardg];         
        
    switch(lower(getenv('computername')))
    case({'petitecabine' 'grandecabine'})
        tplay([left_ear5' right_ear5],Fs); 
    otherwise
    set(handles.Sound2,'BackgroundColor',[79/255 129/255 189/255]);  drawnow;      
        wavplay([left_ear5' right_ear5'],Fs);
    set(handles.Sound2,'BackgroundColor',[240/255 240/255 240/255]) ;   drawnow;
    set(handles.text2,'string','Lequel des deux sons change de lat�ralisation?');
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
        Tab_inv(Nb_inversions) = phase;
        Tab_invms(Nb_inversions) = (phase*(1/handles.Fp)/(2*pi));
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
        if phase*Facteur_down>=pi
            phase=pi;           
        else phase = (phase*Facteur_down);end
    end
    
    %Two down
    if Essais_corrects == 2
        phase = (phase/Facteur_down);
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

% close;

plot(Tab_phase)     %Tab_m adaptive staircase


%%%%%%%%%%%%%%%%%%%%%%%
set(handles.Score1,'Visible','on');
set(handles.Score2,'Visible','on');
set(handles.Score3,'Visible','on');
set(handles.Score4,'Visible','on');
set(handles.Score5,'Visible','on');
set(handles.Score6,'Visible','on');
set(handles.Score7,'Visible','on');
set(handles.Score8,'Visible','on');
set(handles.Sound1,'Visible','off');
set(handles.Sound2,'Visible','off');


handles.Seuil_arith =mean(Tab_inv(7:12));          % Moyenne de m
handles.STD_Seuil = std(Tab_inv(7:12));            % Ecart type de m
handles.Seuil_geo = (prod(abs(Tab_inv(7:12)))).^(1/6);
handles.Seuil_arithms =mean(Tab_invms(7:12))*1000000;          % Moyenne de m
handles.STD_Seuilms = std(Tab_invms(7:12))*1000000;            % Ecart type de m
handles.Seuil_geoms = (prod(abs(Tab_invms(7:12)))).^(1/6)*1000000;

set(handles.text2,'Visible','off');
handles.Essai=Essai;
handles.perf = round((Nb_correct_trials./Nb_trials)*100);
set(handles.Score1,'String',['moy_arith:  ',num2str(handles.Seuil_arith,'%6.2f'),'rad']);
set(handles.Score2,'String',['STD_arith:  ',num2str(handles.STD_Seuil,'%6.2f'),'rad']);
set(handles.Score3,'String',['moy_geo:  ',num2str(handles.Seuil_geo,'%6.2f'),'rad']);
set(handles.Score4,'String',['Essai:  ',num2str(handles.Essai,'%6.2f')]);
set(handles.Score5,'String',['Perf:  ',num2str(handles.perf,'%6.2f'),'%']);
set(handles.Score6,'String',['Seuil_ms:  ',num2str(handles.Seuil_arithms,'%6.2f'),'us']);
set(handles.Score7,'String',['STD_ms:  ',num2str(handles.STD_Seuilms,'%6.2f'),'us']);
set(handles.Score8,'String',['Seuil_geo:  ',num2str(handles.Seuil_geoms,'%6.2f'),'us']);

pause(4);
handles.task='IPD';


if handles.Fp==250, handles.freqp='0.25';
elseif handles.Fp==500, handles.freqp='0.50';
elseif handles.Fp==750, handles.freqp='0.75';
elseif handles.Fp==1000, handles.freqp='1.00';
elseif handles.Fp==2000, handles.freqp='2.00'; end


if handles.Fm==0.0 ;
elseif handles.Fm==4.0, handles.freqm='4.0';end 

if dt==0.5 , handles.dut= '0.5';
elseif dt==1.0 , handles.dut= '1.0'; 
elseif dt==1.5 , handles.dut= '1.5';end


mat = [Tab_phase'];
 
handles.Nom = handles.Parametres.Code;
handles.output=struct('results',[handles.Seuil_arith handles.STD_Seuil handles.Seuil_geo handles.Essai handles.perf handles.Seuil_arithms handles.STD_Seuilms handles.Seuil_geoms],'param',[handles.freqp handles.freqm handles.dut handles.task]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd Resultats
if exist(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'.txt','file'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep1','.txt'), 'mat','-ascii');
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep1','.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep2','.txt'), 'mat','-ascii')  ;
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep2','.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep3','.txt'), 'mat','-ascii')  ;
elseif exist(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep3','.txt'))~=0,
save(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep4','.txt'), 'mat','-ascii');
else save(strcat(handles.Nom,'_',handles.task,'_',num2str(handles.Fp),'_',num2str(handles.freqm),'_',num2str(handles.dut),'_Rep1','.txt'), 'mat','-ascii');end
cd ..


guidata(hObject, handles)
 uiresume(handles.figure1)





% --- Executes on selection change in Condition.
function Condition_Callback(hObject, eventdata, handles)
% hObject    handle to Condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Condition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Condition
if get(hObject,'Value')==2, handles.condition=1; % dichotique
elseif get(hObject,'Value')==3, handles.condition=2; % diotique
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in Duree.
function Duree_Callback(hObject, eventdata, handles)
% hObject    handle to Duree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Duree contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Duree
if get(hObject,'Value')==2, handles.dt=0.5;
elseif get(hObject,'Value')==3, handles.dt=1.0;
elseif get(hObject,'Value')==4, handles.dt=1.5;
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


% --- Executes on selection change in ampli.
function ampli_Callback(hObject, eventdata, handles)
% hObject    handle to ampli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ampli contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ampli
if get(hObject,'Value')==2, handles.ampli=1;
elseif get(hObject,'Value')==3, handles.ampli=2;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ampli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ampli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


