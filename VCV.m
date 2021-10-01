function varargout = VCV(varargin)
% VCV M-file for VCV.fig
%      VCV, by itself, creates a new VCV or raises the existing
%      singleton*.
%
%      H = VCV returns the handle to a new VCV or the handle to
%      the existing singleton*.
%
%      VCV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VCV.M with the given input arguments.
%
%      VCV('Property','Value',...) creates a new VCV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VCV_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VCV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VCV

% Last Modified by GUIDE v2.5 05-Mar-2021 12:46:56
%
% Following modifications for update and extension for joint pupillometry
% Changed 3 instances of wavread to audioread - 20-Nov-2019, D. Arzounian
% 
% 04-Mar-2021 - Added code for optional joint recording with Tobii -
% Lightened response button callback function by moving redundant code to
% ResponseButtonWasPressed helper function.
%
% 05_Mar-2021 - Modifications after testing the program in Babinski booth,
% with Tobii plugged in. Moved lines for updating handles at the end of the
% opening function; Modified location of saved data ('sessionID').
% Replaced sound by play/audioplayer command + extended the pause for
% playback from 1.2 to 1.5 s (max VCVCV duration is 1.41s).
% Added pre-stimulus silence when recording pupil.
% Making window fullscreen (required to change window size and re-center
% button pannel (done manually) in guide to preserve some centering, and to
% change units of uicontrol objectts to 'normalized'. Hiding button pannel
% and mouse cursor and displaying fixation cross during trial when
% recording pupil.
% Changed the name of the TobiiSDK structure field collecting stimulus
% onsets and adding more fields for other relevant timings to save.
% - Doroth�e Arzounian
%
% 5-Mar-2021, later, on a different machine: 
% Slightly modified the syntax of the pupil data file names to have suffix
% like _trial01 instead of _trial1 
% Now return handles as output argument of HideButtonPannel and
% ShowButtonPannel functions, otherwise the timing data of fixation
% display is not passed on.
% (did not test outcomes)
% - DA
%
% 3-Jun-2021 - Added conditional statements to handle the case of VCVCV
% maskers (where Parametres.SSN = 'VCVCV') in VCV_OpeningFcn and in
% routine_stimulus functions

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VCV_OpeningFcn, ...
                   'gui_OutputFcn',  @VCV_OutputFcn, ...
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


% --- Executes just before VCV is made visible.
function VCV_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VCV (see VARARGIN)

% Make VCV figure full screen
set(hObject, 'Units', 'Normalized', 'OuterPosition', [-0.0047   -0.0083    1.0094    1.0167]); % this size in adapted for the Babinski setup
% Center fixation cross

% Choose default command line output for VCV
handles.output = hObject;
h0 = cell2struct(varargin,'Parametres',2);
handles.Parametres = h0.Parametres;

routine_alloff(handles);

%init
handles.Fs=44100;
handles.level = handles.Parametres.level;
handles.NbLog = 16;
handles.NbOcc = 3;
handles.NbSelect = 48;
% if handles.Parametres.Noise, handles.RSB=-6;
% else handles.RSB=10000;
% end
handles.Factor = 10^(-(handles.Parametres.RSB/20));
handles.Essai = 0;
handles.Table = zeros(4,handles.NbSelect);
handles.ontour = 0;
handles.bip = audioread('ding.wav');
[handles.a, handles.b]=butter(6,8000/(0.5*handles.Fs)); % lowpass filtering at 36 dB/oct, fc=5kHz
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
if handles.Parametres.RSB==10000
    set(handles.TxtAccueil,'String',strvcat('Test Consonnes dans le silence         ', ' ','Cliquez sur D�marrer pour commencer    '));
else
    set(handles.TxtAccueil,'String',strvcat('Test Consonnes dans le bruit           ', ' ','Cliquez sur D�marrer pour commencer    '));
    %set(handles.TxtAccueil,'String',strvcat('Test Consonnes      ', 'Dans le silence     ', ' ', 'Cliquez sur Démarrer', 'pour commencer      '));
end

cd Bruits
switch handles.Parametres.SSN
    case 'VCVCV'
        cd(handles.Parametres.SSN)
        maskerFiles = dir; 
        maskerFiles(1:2) = []; % remove '.' and '..'
        for iFile = numel(maskerFiles) : -1: 1
            handles.masker{iFile} = audioread(maskerFiles(iFile).name);
        end
        cd ..
    otherwise
        handles.masker=audioread(handles.Parametres.SSN);
end
cd ..

if exist('Data1000.log','file')~=0
    load -mat Data1000.log
    if isfield(Data,'Plugins'), handles.Plugins = Data.Plugins;
    else handles.Plugins = {'','',''}; end
else
    handles.Plugins = {'','',''};
end

set(handles.TxtAccueil,'HorizontalAlignment','center');
set(handles.TxtAccueil,'Visible','on');

% Initialize Tobii
if handles.Parametres.TobiiRec
    % Initialization of the communication with TobiiPro
    % Add dependencies to path
    mfilepath = fileparts(which(mfilename));
    addpath([mfilepath,filesep,'TobiiPro.SDK.Matlab_1.8.0.21'])

    % Get Eyetracker
    clear TobiiSDK
    TobiiSDK.Tobii = EyeTrackingOperations();
    eyetracker_address = 'tet-tcp://169.254.159.211'; %'tet-tcp://172.28.195.1';
    TobiiSDK.eyetracker = TobiiSDK.Tobii.get_eyetracker(eyetracker_address);
    if isa(TobiiSDK.eyetracker,'EyeTracker')
        disp(['Address:',TobiiSDK.eyetracker.Address]);
        disp(['Name:',TobiiSDK.eyetracker.Name]);
        disp(['Serial Number:',TobiiSDK.eyetracker.SerialNumber]);
        disp(['Model:',TobiiSDK.eyetracker.Model]);
        disp(['Firmware Version:',TobiiSDK.eyetracker.FirmwareVersion]);
        disp(['Runtime Version:',TobiiSDK.eyetracker.RuntimeVersion]);
    else
        disp('Eye tracker not found!');
    end           

    % Initialize event count
    TobiiSDK.EventCount = 0;
    
    % Create TobiiData folder if needed
    TobiiDataDir = [mfilepath,filesep,'TobiiData'];
    if ~exist(TobiiDataDir,'dir')
        mkdir(TobiiDataDir)
    end

    % Define file name to store eyetracking data
    StartTime=fix(clock);
    StartTime=sprintf('%02d-%02d', StartTime(4), StartTime(5));
    datedID = [handles.Parametres.ID, '_' date '_' StartTime ];
    sessionDir = [TobiiDataDir, filesep, datedID ];
    mkdir(sessionDir)
    TobiiSDK.sessionID = [sessionDir, filesep, datedID ];
    
    % Store structure in handles
    handles.TobiiSDK = TobiiSDK;
    
end % Tobii recording condition

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes VCV wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VCV_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Stop Tobii recording if on
if handles.Parametres.TobiiRec          
    handles.TobiiSDK.eyetracker.stop_gaze_data();       
end

delete(handles.figure1);


% --- Executes on button press in apa.
function apa_Callback(hObject, eventdata, handles)
% hObject    handle to apa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 1;
if handles.Table(3,handles.Essai)==1, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in ata.
function ata_Callback(hObject, eventdata, handles)
% hObject    handle to ata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 2;
if handles.Table(3,handles.Essai)==2, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in aka.
function aka_Callback(hObject, eventdata, handles)
% hObject    handle to aka (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 3;
if handles.Table(3,handles.Essai)==3, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in aba.
function aba_Callback(hObject, eventdata, handles)
% hObject    handle to aba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 4;
if handles.Table(3,handles.Essai)==4, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in afa.
function afa_Callback(hObject, eventdata, handles)
% hObject    handle to afa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 7;
if handles.Table(3,handles.Essai)==7, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in assa.
function assa_Callback(hObject, eventdata, handles)
% hObject    handle to assa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 8;
if handles.Table(3,handles.Essai)==8, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in aga.
function aga_Callback(hObject, eventdata, handles)
% hObject    handle to aga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 6;
if handles.Table(3,handles.Essai)==6, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in ada.
function ada_Callback(hObject, eventdata, handles)
% hObject    handle to ada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 5;
if handles.Table(3,handles.Essai)==5, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in aza.
function aza_Callback(hObject, eventdata, handles)
% hObject    handle to aza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 11;
if handles.Table(3,handles.Essai)==11, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in aja.
function aja_Callback(hObject, eventdata, handles)
% hObject    handle to aja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 12;
if handles.Table(3,handles.Essai)==12, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in ava.
function ava_Callback(hObject, eventdata, handles)
% hObject    handle to ava (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 10;
if handles.Table(3,handles.Essai)==10, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in acha.
function acha_Callback(hObject, eventdata, handles)
% hObject    handle to acha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 9;
if handles.Table(3,handles.Essai)==9, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in ara.
function ara_Callback(hObject, eventdata, handles)
% hObject    handle to ara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 15;
if handles.Table(3,handles.Essai)==15, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in ala.
function ala_Callback(hObject, eventdata, handles)
% hObject    handle to ala (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 16;
if handles.Table(3,handles.Essai)==16, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in ana.
function ana_Callback(hObject, eventdata, handles)
% hObject    handle to ana (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 14;
if handles.Table(3,handles.Essai)==14, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)


% --- Executes on button press in amama.
function ama_Callback(hObject, eventdata, handles)
% hObject    handle to amama (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine_alloff(handles);
handles.Table(4,handles.Essai) = 13;
if handles.Table(3,handles.Essai)==13, handles.performance=handles.performance+1;end
ResponseButtonWasPressed(handles,hObject)

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
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

% Start Tobii recording if required
if handles.Parametres.TobiiRec
    % Start to collect data
    handles.TobiiSDK.eyetracker.get_gaze_data();
end

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
set(handles.apa,'Enable','off');
set(handles.ata,'Enable','off');
set(handles.aka,'Enable','off');
set(handles.aba,'Enable','off');
set(handles.afa,'Enable','off');
set(handles.assa,'Enable','off');
set(handles.aga,'Enable','off');
set(handles.ada,'Enable','off');
set(handles.aza,'Enable','off');
set(handles.aja,'Enable','off');
set(handles.ava,'Enable','off');
set(handles.acha,'Enable','off');
set(handles.ara,'Enable','off');
set(handles.ala,'Enable','off');
set(handles.ana,'Enable','off');
set(handles.ama,'Enable','off');

function routine_allon(handles)
set(handles.apa,'Enable','on');
set(handles.ata,'Enable','on');
set(handles.aka,'Enable','on');
set(handles.aba,'Enable','on');
set(handles.afa,'Enable','on');
set(handles.assa,'Enable','on');
set(handles.aga,'Enable','on');
set(handles.ada,'Enable','on');
set(handles.aza,'Enable','on');
set(handles.aja,'Enable','on');
set(handles.ava,'Enable','on');
set(handles.acha,'Enable','on');
set(handles.ara,'Enable','on');
set(handles.ala,'Enable','on');
set(handles.ana,'Enable','on');
set(handles.ama,'Enable','on');

function n=stim2num(name)
aa=name(2);
if strcmp(aa,'p') n=1;
elseif strcmp(aa,'t') n=2;
elseif strcmp(aa,'k') n=3;
elseif strcmp(aa,'b') n=4;
elseif strcmp(aa,'d') n=5;
elseif strcmp(aa,'g') n=6;
elseif strcmp(aa,'f') n=7;
elseif strcmp(aa,'s') n=8;
elseif strcmp(aa,'c') n=9;
elseif strcmp(aa,'v') n=10;
elseif strcmp(aa,'z') n=11;
elseif strcmp(aa,'j') n=12;
elseif strcmp(aa,'m') n=13;
elseif strcmp(aa,'n') n=14;
elseif strcmp(aa,'r') n=15;
elseif strcmp(aa,'l') n=16;
end





function handles = routine_stimulus(handles)

Fs=handles.Fs;

cd(handles.Parametres.StimRep);

handles.Essai = handles.Essai + 1;
Tirage = handles.alea(handles.Essai); 

Selection=stim2num(handles.d(Tirage + 2).name);

handles.Table(1,handles.Essai) = handles.Essai;
handles.Table(2,handles.Essai) = Selection;

if mod(Selection,handles.NbLog) == 0
    handles.Table(3,handles.Essai) = handles.NbLog;
else
    handles.Table(3,handles.Essai) = mod(Selection,handles.NbLog);
end

signal=audioread(handles.d(Tirage + 2).name);

cd(handles.Parametres.ProgRep);

%Plugins #1
if strcmp(handles.Plugins{1,1},'')~=1
    cd plugins
    plug = str2func(char(handles.Plugins{1,1}));
    signal = plug(signal);
    cd ..
end

signal=filtfilt(handles.a,handles.b,signal);

signal = signal ./ sqrt(mean(signal.^2));
duration=length(signal);

switch handles.Parametres.SSN
    case 'VCVCV'
        iMasker = randi(numel(handles.masker),1); % draw random masker
        % TO DO: change masker if it is the same C as the signal
        % TO DO: store masker identity for each trial
        noise = handles.masker{iMasker};
        handles.masker(iMasker) = []; % Suppress masker from list for next trials
        noise = noise ./ sqrt(mean(noise.^2)); % normalisation en énergie rms
        % Align noise and signal on their centers
        if length(signal) > length(noise)
            paddingLength = length(signal) - length(noise);
            noise = cat(1, zeros(floor(paddingLength/2),1), noise, zeros (ceil(paddingLength/2),1));
        else
            paddingLength = length(noise) - length(signal);
            signal = cat(1, zeros(floor(paddingLength/2),1), signal, zeros (ceil(paddingLength/2),1));
            duration=length(signal);
        end
        
    otherwise
        t=round(rand(1)*(length(handles.masker)-duration-4096));  % tirage aleatoire de la portion du fichier ssn à utiliser comme masque
        noise=handles.masker(t:(t+(duration-1)),round(rand(1))+1);
        
        % Note: I don't know whether the following should also be applied
        % to the 'VCVCV' masker case - DA, 3-Jun-2021
        %plugins #2
        if strcmp(handles.Plugins{1,2},'')~=1
            cd plugins
            plug = str2func(char(handles.Plugins{1,2}));
            noise = plug(noise);
            cd ..
        end

        total_duration=length(noise);
        t=1:total_duration; % vecteur temps

        noise = noise ./ sqrt(mean(noise.^2)); % normalisation en énergie rms
end


output = signal + (noise .* handles.Factor );  % Addition Signal et Bruit avec un rapport S/N donné (controle par Factor)

%Plugins #3
if strcmp(handles.Plugins{1,3},'')~=1
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
else
    output1 = output;
end
if handles.Parametres.Aud && handles.Parametres.Oreille == 3
    output2 = filter(handles.audiofilt,1,output);
else
    output2 = output;
end
if handles.Parametres.Aud && handles.Parametres.Oreille == 4
    output3 = filter(handles.audiofilt1,1,output);
    output4 = filter(handles.audiofilt2,1,output);
else
    output3 = output;
    output4 = output;
end

% Playback
if handles.Parametres.Oreille == 2
    stimulus = audioplayer([zz output1],Fs);% sound([zz output1],Fs);
elseif handles.Parametres.Oreille == 3
    stimulus = audioplayer([output2 zz],Fs); %sound([output2 zz],Fs);
else
    stimulus = audioplayer([output4 output3],Fs); % sound([output4 output3],Fs);
end
% If Tobii is recording, add silence and store eyetracker timestamps just
% before playback, hide pannel and display fixation cross
if handles.Parametres.TobiiRec
    % Increment event  count
   handles.TobiiSDK.EventCount = handles.TobiiSDK.EventCount + 1;
   % Hide button pannel and display fixation cross
    handles = HideButtonPannel(handles);       
           % See here what kind of data about the trial should be saved along, e.g.
           % the consonant?
        %    TobiiSDK.Run(TobiiSDK.EventCount) = work.numrun;
        %    TobiiSDK.Trial(TobiiSDK.EventCount) = work.presentationCounter;
        %    TobiiSDK.AFCexpvar(TobiiSDK.EventCount) = work.expvaract;
    % Silence and playback
   pause(2)
   handles.TobiiSDK.StimulusOnsetSystemTime(handles.TobiiSDK.EventCount) = handles.TobiiSDK.Tobii.get_system_time_stamp;
end % pupil recording option test
play(stimulus)

% If Tobii is recording
if handles.Parametres.TobiiRec
    % Also save time stamp after playback command?
    handles.TobiiSDK.StimulusPostOnsetSystemTime(handles.TobiiSDK.EventCount) = handles.TobiiSDK.Tobii.get_system_time_stamp;    
    % Extend pause to allow recording of pupil response
    pause(6)
end % pupil recording option test
pause(1.5);

handles = ShowButtonPannel(handles);





function handles = routine_output(handles)

for k=1:handles.NbSelect
    handles.mat(handles.Table(3,k),handles.Table(4,k)) = handles.mat(handles.Table(3,k),handles.Table(4,k))+1;
end

handles.perf=[handles.perf (handles.performance/handles.NbSelect)*100];

%mat=handles.mat;
%perf=handles.perf;
%traitement des données
[handles.voisement, handles.lieu, handles.mode]=trans_info(handles.mat);

handles.output=struct('results',[handles.perf handles.voisement handles.lieu handles.mode],'mat',handles.mat);
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

function ResponseButtonWasPressed(handles, hObject0)

% If Tobii is recording, store and save trial data
if handles.Parametres.TobiiRec
    % Save timestamp of button press
    handles.TobiiSDK.ButtonPressOnsetSystemTime(handles.TobiiSDK.EventCount) = handles.TobiiSDK.Tobii.get_system_time_stamp;    
    % Get gaze data from the ending trial
    gaze_data = handles.TobiiSDK.eyetracker.get_gaze_data();
    % Save to disk, in trial-specific file
    save([handles.TobiiSDK.sessionID,'_gaze-data'...
            '_trial',num2str(handles.TobiiSDK.EventCount,'%.2d'),...
            '.mat'],...
        'gaze_data')       
    % Save updated other Tobii info to disk
    TobiiSDK = handles.TobiiSDK;
    save([handles.TobiiSDK.sessionID,'.mat'],'-struct','TobiiSDK') 
end

if handles.Essai < handles.NbSelect
    handles = routine_stimulus(handles);
    ShowButtonPannel(handles)
    routine_allon(handles);
    guidata(hObject0, handles);
else 
    handles = routine_output(handles);
    guidata(hObject0, handles);
    uiresume(handles.figure1);
end

function handles = HideButtonPannel(handles)
set(handles.apa,'Visible','off');
set(handles.ata,'Visible','off');
set(handles.aka,'Visible','off');
set(handles.aba,'Visible','off');
set(handles.afa,'Visible','off');
set(handles.assa,'Visible','off');
set(handles.aga,'Visible','off');
set(handles.ada,'Visible','off');
set(handles.aza,'Visible','off');
set(handles.aja,'Visible','off');
set(handles.ava,'Visible','off');
set(handles.acha,'Visible','off');
set(handles.ara,'Visible','off');
set(handles.ala,'Visible','off');
set(handles.ana,'Visible','off');
set(handles.ama,'Visible','off');
% Hide mouse cursor
set(handles.figure1, 'Pointer', 'custom', 'PointerShapeCData', NaN(16,16))
% Display fixation cross
set(handles.FixationCross,'Visible','on');
if handles.Parametres.TobiiRec
    % Save timestamp of fixation cross onset
    handles.TobiiSDK.FixationOnsetSystemTime(handles.TobiiSDK.EventCount) = handles.TobiiSDK.Tobii.get_system_time_stamp;    
end

function handles = ShowButtonPannel(handles)
set(handles.FixationCross,'Visible','off');
set(handles.apa,'Visible','on');
set(handles.ata,'Visible','on');
set(handles.aka,'Visible','on');
set(handles.aba,'Visible','on');
set(handles.afa,'Visible','on');
set(handles.assa,'Visible','on');
set(handles.aga,'Visible','on');
set(handles.ada,'Visible','on');
set(handles.aza,'Visible','on');
set(handles.aja,'Visible','on');
set(handles.ava,'Visible','on');
set(handles.acha,'Visible','on');
set(handles.ara,'Visible','on');
set(handles.ala,'Visible','on');
set(handles.ana,'Visible','on');
set(handles.ama,'Visible','on');
% Display mouse cursor back
set(handles.figure1, 'Pointer', 'arrow', 'PointerShapeCData', ones(16,16))
if handles.Parametres.TobiiRec
    % Save timestamp of button pannel display
    handles.TobiiSDK.ButtonPannelDisplaySystemTime(handles.TobiiSDK.EventCount) = handles.TobiiSDK.Tobii.get_system_time_stamp;    
end
