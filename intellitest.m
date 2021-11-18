function varargout = intellitest(varargin)
% intellitest M-file for intellitest.fig
%      intellitest, by itself, creates a new intellitest or raises the existing
%      singleton*.
%
%      H = intellitest returns the handle to a new intellitest or the handle to
%      the existing singleton*.
%
%      intellitest('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in intellitest.M with the given input arguments.
%
%      intellitest('Property','Value',...) creates a new intellitest or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before intellitest_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed t(o intellitest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES   
%
% Edit the above text to modify the response to help intellitest

% 04-Mar-2021 - Removed unnecessary commas, new callback to TobiiCheckbox
% after adding the corresponding uicontrol in intellitest.fig, modified
% callback to Stim uicontrol to enable/disable TobiiCheckbox based on
% selection, added TobiiCheckbox.Value to Parametres structure under field
% 'TobiiRec' in routine_VCV, as well as 'ID' field made of string
% containing patient code and noise type, to be passed to VCV.m
%- Dorothée Arzounian
%
% 05-Mar-2021 - Corrected the definition of 'ID' parameter field - DA
%
% 03-Jun-2021 - Added conditional statements to handle the case where VCVCV
% maskers are selected in BruitSelect_SelectionChangeFcn and in routine_VCV
% functions - DA
%
% 18-Oct-2021 - Now saving trial-specific data to disk in the case of
% consonant material: storing the new field 'sequence' of the output
% structure of VCV.m as an additional field of handles with the same name,
% in routine_VCV; then appending this as a new field 'Sequence' of the
% 'results_mat' structure variable in routine_outsave.
%
% Last Modified by GUIDE v2.5 04-Mar-2021 13:17:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @intellitest_OpeningFcn, ...
                   'gui_OutputFcn',  @intellitest_OutputFcn, ...
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


% --- Executes just before intellitest is made visible.
function intellitest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to intellitest (see VARARGIN)

% Choose default command line output for intellitest
handles.output = hObject;

handles.RSB=10000;
handles.BType='SSN';
handles.Aud=1;
handles.AudioDdB=[];
handles.AudioGdB=[];


if exist('Data1000.log','file')
    load -mat Data1000.log
    if isfield(Data,'Levels'), handles.Levels = Data.Levels; handles.error=0;
    else handles.error=1; end
else
    handles.error=1;
end

set(handles.AudOn,'Value',0)
set(handles.AudOff,'Value',1)

if ~isempty(handles.AudioDdB)
    plot([0 1 2 3 4 5 6],handles.AudioDdB,'wx-','LineWidth',3,'MarkerSize',15);
    axis([-0.5 6.5 -90 10])
    set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
    set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
    set(handles.AudiogD,'XMinorTick','off')
    set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
    set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
    grid on
end
if ~isempty(handles.AudioGdB)
    plot([0 1 2 3 4 5 6],handles.AudioGdB,'wx-','LineWidth',3,'MarkerSize',15);
    axis([-0.5 6.5 -90 10])
    set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
    set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
    set(handles.AudiogG,'XMinorTick','off')
    set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
    set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
    grid on
end
set(handles.AudiogG,'Color',[236 233 216]./256);
set(handles.AudiogG,'XColor',[192 192 192]./256);
set(handles.AudiogG,'YColor',[192 192 192]./256);
set(handles.AudiogD,'Color',[236 233 216]./256);
set(handles.AudiogD,'XColor',[192 192 192]./256);
set(handles.AudiogD,'YColor',[192 192 192]./256);
handles.Aud=0;
set(handles.ModifAudiogD,'Enable','off');
set(handles.ModifAudiogG,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes intellitest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = intellitest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Type.
function Type_Callback(hObject, eventdata, handles)
% hObject    handle to Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Type


% --- Executes during object creation, after setting all properties.
function Type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function AudiogD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AudiogD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate AudiogD




% --- Executes during object creation, after setting all properties.
function AudiogG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AudiogD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




function y=RAUCorr(x) % performance x en %

y=x;



% --- Executes on button press in ModifAudiogD.
function ModifAudiogD_Callback(hObject, eventdata, handles)
% hObject    handle to ModifAudiogD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off');
set(handles.ModifText,'FontSize',19);
set(handles.ModifText,'Visible','on');
outD=0;

handles.AudioDdB=[0 0 0 0 0 0 0];
DonePointsD=[0 0 0 0 0 0 0];

%plot([0 1 2 3 4 5],handles.AudioDdB,'rx-','LineWidth',3,'MarkerSize',15);
% cla
axis([-0.5 6.5 -90 10])
set(handles.AudiogD,'Box','on')
set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
set(handles.AudiogD,'XMinorTick','off')
set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
grid on
    
while outD==0
[x,y]=ginput(1);
q=isempty(x);
if q || (x<-0.5) || (x>6.5) || (y>10) || (y<-90)
    outD=1;
    plot([0 1 2 3 4 5 6],handles.AudioDdB,'rx-','LineWidth',3,'MarkerSize',15);
    %plot(x,y,'rx-','LineWidth',3,'MarkerSize',15);
    axis([-0.5 6.5 -90 10])
    set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
    set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
    set(handles.AudiogD,'XMinorTick','off')
    set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
    set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
    grid on
else    
    x=round(x);
    if x<0, x=0;end
    if x>6, x=6;end
    
    y=round(y/5)*5;
    if y>0, y=0;end
    if y<-80, y=-80;end
    
    handles.AudioDdB(x+1)=y;
    DonePointsD(x+1)=1;
    %plot([0 1 2 3 4 5],handles.AudioDdB,'rx-','LineWidth',3,'MarkerSize',15);
    %hold on
    for k=1:length(DonePointsD)
        if DonePointsD(k)==1
            plot(k-1,handles.AudioDdB(k),'rx-','LineWidth',3,'MarkerSize',15);
            hold on;
        end
    end
    hold off
    %plot(x,y,'rx-','LineWidth',3,'MarkerSize',15);
    axis([-0.5 6.5 -90 10])
    set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
    set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
    set(handles.AudiogD,'XMinorTick','off')
    set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
    set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
    grid on
end
end

set(hObject,'Enable','on');
set(handles.ModifText,'Visible','off');

guidata(hObject, handles);



% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.Code,'String'))
    set(handles.Txtalarm,'String','Veuillez compléter le code patient');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif (isempty(get(handles.Jour,'String'))) || (isempty(get(handles.Mois,'String'))) || (isempty(get(handles.Annee,'String')))
    set(handles.Txtalarm,'String','Veuillez indiquer la date de naissance');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif (get(handles.Sexe,'Value')==1)
    set(handles.Txtalarm,'String','Veuillez indiquer le sexe');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif get(handles.Info,'Value')==1
    set(handles.Txtalarm,'String','Veuillez indiquer le groupe');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif get(handles.Info,'Value')==6 && isempty(get(handles.InfoTxt,'String')),
    set(handles.Txtalarm,'String','Veuillez préciser le groupe');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif isempty(handles.AudioDdB) && get(handles.AudOn,'Value')&& get(handles.Oreille,'Value')==2
    set(handles.Txtalarm,'String','Veuillez compléter l''audiogramme OD');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif isempty(handles.AudioGdB) && get(handles.AudOn,'Value') && get(handles.Oreille,'Value')==3
    set(handles.Txtalarm,'String','Veuillez compléter l''audiogramme OG');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif isempty(handles.AudioGdB) && get(handles.AudOn,'Value') && get(handles.Oreille,'Value')==4
    set(handles.Txtalarm,'String','Veuillez compléter les 2 audiogrammes');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif (get(handles.Oreille,'Value')==1)
    set(handles.Txtalarm,'String','Veuillez indiquer l''oreille choisie');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif (get(handles.Stim,'Value')==1)
    set(handles.Txtalarm,'String','Veuillez indiquer le matériel vocal');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif get(handles.Stim,'Value')==5 && get(handles.Oreille,'Value')==2
    set(handles.Txtalarm,'String','Mesure monaurale du BMLD impossible');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');    
elseif get(handles.Stim,'Value')==5 && get(handles.Oreille,'Value')==3
    set(handles.Txtalarm,'String','Mesure monaurale du BMLD impossible');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');  
elseif get(handles.Stim,'Value')==6 && get(handles.Oreille,'Value')==2
    set(handles.Txtalarm,'String','Mesure monaurale du IPD impossible');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');    
elseif get(handles.Stim,'Value')==6 && get(handles.Oreille,'Value')==3
    set(handles.Txtalarm,'String','Mesure monaurale du IPD impossible');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif (get(handles.Level,'Value')==1)
    set(handles.Txtalarm,'String','Veuillez indiquer le niveau de présentation');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif handles.error
    set(handles.Txtalarm,'String','Erreur etalonnage');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
elseif isempty(get(handles.InRSB,'String')),
    set(handles.Txtalarm,'String','Veuillez completer le rapport signal bruit');
    set(handles.Txtalarm,'Visible','on');
    pause(2);
    set(handles.Txtalarm,'Visible','off');
else
    routine_alloff(handles);
    if get(handles.Stim,'Value')==2
        handles=routine_VCV(handles);
    elseif get(handles.Stim,'Value')==3
        handles=routine_CVC(handles);
    elseif get(handles.Stim,'Value')==4
        handles=routine_ModDetectGUI(handles);        
    elseif get(handles.Stim,'Value')==5
        handles=routine_MLD(handles);  
    elseif get(handles.Stim,'Value')==6
        handles=routine_IPD(handles);
    elseif get(handles.Stim,'Value')==7
%         handles=routine_Forward(handles);
        handles=routine_CMR(handles);
    else 
        handles=routine_Integration_ModDetect(handles);
    end

    routine_outsave(handles)
    set(handles.Run,'String','Fin du test');
    
    guidata(hObject, handles);
end


function Code_Callback(hObject, eventdata, handles)
% hObject    handle to Code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Code as text
%        str2double(get(hObject,'String')) returns contents of Code as a double
da=get(hObject, 'String');
if sum(isstrprop(da, 'alpha'))==0
    set(hObject, 'String', '');
end



function Jour_Callback(hObject, eventdata, handles)
% hObject    handle to Jour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Jour as text
%        str2double(get(hObject,'String')) returns contents of Jour as a double
da=get(hObject, 'String');
l=length(da);
if l>2
    set(hObject, 'String', da(1:2));
    l=2;
end
da=str2num(da(1:l));
if (isempty(da)) || (da>31) || (da<1)
    set(hObject, 'String', '');
end

function Mois_Callback(hObject, eventdata, handles)
% hObject    handle to Mois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mois as text
%        str2double(get(hObject,'String')) returns contents of Mois as a double
mo=get(hObject, 'String');
l=length(mo);
if l>2
    set(hObject, 'String', mo(1:2));
    l=2;
end
mo=str2num(mo(1:l));
if (isempty(mo)) || (mo>12) || (mo<1)
    set(hObject, 'String', '');
end

function Annee_Callback(hObject, eventdata, handles)
% hObject    handle to Annee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Annee as text
%        str2double(get(hObject,'String')) returns contents of Annee as a double
yr=get(hObject, 'String');
l=length(yr);
if l>4
    set(hObject, 'String', yr(1:4));
    l=4;
end
yr=str2num(yr(1:l));
if (isempty(yr)) || (yr>2007) || (yr<1900)
    set(hObject, 'String', '');
end


% --- Executes on selection change in Sexe.
function Sexe_Callback(hObject, eventdata, handles)
% hObject    handle to Sexe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Sexe contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sexe


% --- Executes during object creation, after setting all properties.
function Sexe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sexe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in Oreille.
function Oreille_Callback(hObject, eventdata, handles)
% hObject    handle to Oreille (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Oreille contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Oreille


% --- Executes during object creation, after setting all properties.
function Oreille_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oreille (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Stim.
function Stim_Callback(hObject, eventdata, handles)
% hObject    handle to Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject.Value == 2
    % 'Consonnes' stimuli selected, allow Tobii recording option for VCV
    handles.TobiiCheckbox.Value = true;
    handles.TobiiCheckbox.Enable = 'on';
else
    handles.TobiiCheckbox.Value = false;
    handles.TobiiCheckbox.Enable = 'off';
end

% Hints: contents = get(hObject,'String') returns Stim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stim


% --- Executes during object creation, after setting all properties.
function Stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Level.
function Level_Callback(hObject, eventdata, handles)
% hObject    handle to Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Level contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Level


if get(hObject,'Value')==2, handles.level=25;
elseif get(hObject,'Value')==3, handles.level=30;
elseif get(hObject,'Value')==4, handles.level=35;
elseif get(hObject,'Value')==5, handles.level=40;    
elseif get(hObject,'Value')==6, handles.level=45;
elseif get(hObject,'Value')==7, handles.level=50;
elseif get(hObject,'Value')==8, handles.level=55;
elseif get(hObject,'Value')==9, handles.level=60;
elseif get(hObject,'Value')==10, handles.level=65;
elseif get(hObject,'Value')==11, handles.level=70;
elseif get(hObject,'Value')==12, handles.level=75;
elseif get(hObject,'Value')==13, handles.level=80;
elseif get(hObject,'Value')==14, handles.level=90;


end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function BruitSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to BruitSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.Silence,'Value')
    handles.RSB=10000;
    handles.BType='SSN';
elseif get(handles.Stat,'Value')
    handles.RSB=str2num(get(handles.InRSB,'String'));
    handles.BType='SSN';
elseif get(handles.Tempo,'Value')
    handles.RSB=str2num(get(handles.InRSB,'String'));
    handles.BType='SSN_T';
elseif get(handles.Spectro,'Value')
    handles.RSB=str2num(get(handles.InRSB,'String'));
    handles.BType='SSN_SP';
elseif get(handles.SpectroTempo,'Value')
    handles.RSB=str2num(get(handles.InRSB,'String'));
    handles.BType='SSN_SPT';
elseif get(handles.VCVCV,'Value')
    handles.RSB=str2num(get(handles.InRSB,'String'));
    handles.BType='VCVCV';
end
guidata(hObject, handles);




% --------------------------------------------------------------------
function AudControl_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to AudControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.AudOn,'Value') &&   (get(handles.Oreille,'Value')==4)
    if ~isempty(handles.AudioDdB)
        plot([0 1 2 3 4 5 6],handles.AudioDdB,'rx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogD,'XMinorTick','off')
        set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogD,'Color',[1 0.67 0.67]);
    set(handles.AudiogD,'XColor',[0 0 0]);
    set(handles.AudiogD,'YColor',[0 0 0]);
    handles.Aud=1;
    set(handles.ModifAudiogD,'Enable','on');
    if ~isempty(handles.AudioGdB)
        plot([0 1 2 3 4 5 6],handles.AudioGdB,'rx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogG,'XMinorTick','off')
        set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogG,'Color',[0.65 0.74 0.91]);
    set(handles.AudiogG,'XColor',[0 0 0]);
    set(handles.AudiogG,'YColor',[0 0 0]);
    handles.Aud=1;
    set(handles.ModifAudiogG,'Enable','on');
elseif get(handles.AudOn,'Value') &&   (get(handles.Oreille,'Value')==3)    
        if ~isempty(handles.AudioGdB)
        plot([0 1 2 3 4 5 6],handles.AudioGdB,'rx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogG,'XMinorTick','off')
        set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogG,'Color',[0.65 0.74 0.91]);
    set(handles.AudiogG,'XColor',[0 0 0]);
    set(handles.AudiogG,'YColor',[0 0 0]);
    handles.Aud=1;
    set(handles.ModifAudiogG,'Enable','on');
elseif get(handles.AudOn,'Value') &&   (get(handles.Oreille,'Value')==2)
    if ~isempty(handles.AudioDdB)
        plot([0 1 2 3 4 5 6],handles.AudioDdB,'rx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogD,'XMinorTick','off')
        set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogD,'Color',[1 0.67 0.67]);
    set(handles.AudiogD,'XColor',[0 0 0]);
    set(handles.AudiogD,'YColor',[0 0 0]);
    handles.Aud=1;
    set(handles.ModifAudiogD,'Enable','on');
elseif get(handles.AudOff,'Value')
    if ~isempty(handles.AudioDdB)
        plot([0 1 2 3 4 5 6],handles.AudioDdB,'wx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogD,'XMinorTick','off')
        set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogD,'Color',[236 233 216]./256);
    set(handles.AudiogD,'XColor',[192 192 192]./256);
    set(handles.AudiogD,'YColor',[192 192 192]./256);
    handles.Aud=0;
    set(handles.ModifAudiogD,'Enable','off');
    if ~isempty(handles.AudioGdB)
        plot([0 1 2 3 4 5 6],handles.AudioGdB,'wx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogG,'XMinorTick','off')
        set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogG,'Color',[236 233 216]./256);
    set(handles.AudiogG,'XColor',[192 192 192]./256);
    set(handles.AudiogG,'YColor',[192 192 192]./256);
    handles.Aud=0;
    set(handles.ModifAudiogG,'Enable','off');
end
guidata(hObject, handles);




% --------------------------------------------------------------------
function NewTest_Callback(hObject, eventdata, handles)
% hObject    handle to NewTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Run,'Enable','on');
if get(handles.AudOn,'Value')
    if ~isempty(handles.AudioGdB)
        plot([0 1 2 3 4 5 6],handles.AudioGdB,'rx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogG,'XMinorTick','off')
        set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    if ~isempty(handles.AudioDdB)
        plot([0 1 2 3 4 5 6],handles.AudioDdB,'rx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogD,'XMinorTick','off')
        set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogD,'Color',[1 0.67 0.67]);
    set(handles.AudiogD,'XColor',[0 0 0]);
    set(handles.AudiogD,'YColor',[0 0 0]);
    set(handles.AudiogG,'Color',[0.65 0.74 0.91]);
    set(handles.AudiogG,'XColor',[0 0 0]);
    set(handles.AudiogG,'YColor',[0 0 0]);
    handles.Aud=1;
    set(handles.ModifAudiogD,'Enable','on');
    set(handles.ModifAudiogG,'Enable','on');
elseif get(handles.AudOff,'Value')
    if ~isempty(handles.AudioGdB)
        plot([0 1 2 3 4 5 6],handles.AudioGdB,'wx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogG,'XMinorTick','off')
        set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    if ~isempty(handles.AudioDdB)
        plot([0 1 2 3 4 5 6],handles.AudioDdB,'wx-','LineWidth',3,'MarkerSize',15);
        axis([-0.5 6.5 -90 10])
        set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
        set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
        set(handles.AudiogD,'XMinorTick','off')
        set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
        set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
        grid on
    end
    set(handles.AudiogD,'Color',[236 233 216]./256);
    set(handles.AudiogD,'XColor',[192 192 192]./256);
    set(handles.AudiogD,'YColor',[192 192 192]./256);
    set(handles.AudiogG,'Color',[236 233 216]./256);
    set(handles.AudiogG,'XColor',[192 192 192]./256);
    set(handles.AudiogG,'YColor',[192 192 192]./256);
    handles.Aud=0;
    set(handles.ModifAudiogD,'Enable','off');
    set(handles.ModifAudiogG,'Enable','off');
end
set(handles.Code,'Enable','on');
set(handles.Jour,'Enable','on');
set(handles.Mois,'Enable','on');
set(handles.Annee,'Enable','on');
set(handles.Sexe,'Enable','on');
set(handles.Oreille,'Enable','on');
set(handles.Run,'String','Lancer le test');
set(handles.TextPerf,'String','');
set(handles.TextVLM,'String','');
set(handles.Stim,'Enable','on');
set(handles.Level,'Enable','on');
set(handles.AudOn,'Enable','on');
set(handles.AudOff,'Enable','on');
set(handles.Silence,'Enable','on');
set(handles.Stat,'Enable','on');
set(handles.Tempo,'Enable','on');
set(handles.Spectro,'Enable','on');
set(handles.SpectroTempo,'Enable','on');
set(handles.Info,'Enable','on');
if get(handles.Info,'Value')==6, 
    set(handles.InfoTxt,'Enable','on');
    set(handles.InfoTxt,'BackgroundColor',[1 1 1]);
else
    set(handles.InfoTxt,'Enable','off');
    set(handles.InfoTxt,'BackgroundColor',[236 233 216]./256);
end
set(handles.InRSB,'Enable','on');
guidata(hObject, handles);



% --------------------------------------------------------------------
function NewPatient_Callback(hObject, eventdata, handles)
% hObject    handle to NewPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Run,'Enable','on');
set(handles.ModifAudiogD,'Enable','on');
set(handles.ModifAudiogG,'Enable','on');
set(handles.Code,'Enable','on');
set(handles.Code,'String','');
set(handles.Jour,'Enable','on');
set(handles.Jour,'String','');
set(handles.Mois,'Enable','on');
set(handles.Mois,'String','');
set(handles.Annee,'Enable','on');
set(handles.Annee,'String','');
set(handles.Sexe,'Enable','on');
set(handles.Sexe,'Value',1);
set(handles.Oreille,'Enable','on');
set(handles.Oreille,'Value',1);
set(handles.Run,'String','Lancer le test');
set(handles.TextPerf,'String','');
set(handles.TextVLM,'String','');
set(handles.Stim,'Enable','on');
set(handles.Level,'Enable','on');
set(handles.AudOn,'Enable','on');
set(handles.AudOn,'Value',1);
set(handles.AudOff,'Enable','on');
set(handles.AudOff,'Value',0);
set(handles.Silence,'Enable','on');
set(handles.Silence,'Value',1);
set(handles.Stat,'Enable','on');
set(handles.Stat,'Value',0);
set(handles.Tempo,'Enable','on');
set(handles.Tempo,'Value',0);
set(handles.Spectro,'Enable','on');
set(handles.Spectro,'Value',0);
set(handles.SpectroTempo,'Enable','on');
set(handles.SpectroTempo,'Value',0);
set(handles.Info,'Enable','on');
set(handles.Info,'Value',1);
set(handles.InfoTxt,'Enable','off');
set(handles.InfoTxt,'String','');
set(handles.InfoTxt,'BackgroundColor',[236 233 216]./256);
handles.AudioGdB=[];
handles.AudioDdB=[];
cla;
axis([-0.5 6.5 -90 10])
set(handles.AudiogG,'Box','on')
set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
set(handles.AudiogG,'XMinorTick','off')
set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
set(handles.AudiogG,'FontSize',16);
grid on
set(handles.AudiogG,'Color',[1 1 1]);
set(handles.AudiogG,'XColor',[0 0 0]);
set(handles.AudiogG,'YColor',[0 0 0]);
cla;
axis([-0.5 6.5 -90 10])
set(handles.AudiogD,'Box','on')
set(handles.AudiogD,'XTick',[0 1 2 3 4 5 6])
set(handles.AudiogD,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
set(handles.AudiogD,'XMinorTick','off')
set(handles.AudiogD,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
set(handles.AudiogD,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
set(handles.AudiogD,'FontSize',16);
grid on
set(handles.AudiogD,'Color',[1 1 1]);
set(handles.AudiogD,'XColor',[0 0 0]);
set(handles.AudiogD,'YColor',[0 0 0]);
set(handles.InRSB,'Enable','on');
set(handles.InRSB,'String','0');

guidata(hObject, handles);



function Quitter_Callback(hObject, eventdata, handles)
% hObject    handle to Quitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on selection change in Info.
function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Info contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Info
if get(hObject,'Value')==7,
    set(handles.InfoTxt,'Enable','on');
    set(handles.InfoTxt,'BackgroundColor',[1 1 1]);
else
    set(handles.InfoTxt,'Enable','off');
    set(handles.InfoTxt,'BackgroundColor',[236 233 216]./256);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function InfoTxt_Callback(hObject, eventdata, handles)
% hObject    handle to InfoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InfoTxt as text
%        str2double(get(hObject,'String')) returns contents of InfoTxt as a double


% --- Executes during object creation, after setting all properties.
function InfoTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InfoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[236 233 216]./256);
end





function InRSB_Callback(hObject, eventdata, handles)
% hObject    handle to InRSB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InRSB as text
%        str2double(get(hObject,'String')) returns contents of InRSB as a double

rsb=get(hObject, 'String');
rsb=str2num(rsb);
if (isempty(rsb)) || (rsb>20) || (rsb<-20)
    set(hObject, 'String', '');
end

if handles.RSB ~= 10000
    handles.RSB=str2num(get(handles.InRSB,'String'));
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function InRSB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InRSB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function Experience_Callback(hObject, eventdata, handles)
% hObject    handle to Experience (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Programme_Callback(hObject, eventdata, handles)
% hObject    handle to Programme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
About();



% --------------------------------------------------------------------
function Plugins_Callback(hObject, eventdata, handles)
% hObject    handle to Plugins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plugins();


% --- Executes during object creation, after setting all properties.
function AudControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AudControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles.AudOn,'Value',1);
% set(handles.AudOff,'Value',1);
% set(hObject,'Enable','off');

% --------------------------------------------------------------------
function Stimuli_Callback(hObject, eventdata, handles)
% hObject    handle to Stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StimRep();




% --- Executes during object creation, after setting all properties.
function Code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles=routine_VCV(handles)
switch handles.BType
    case 'VCVCV'
        ssn = handles.BType;
    otherwise
        ssn=strcat(handles.BType,'_V.wav');
end
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\VCV');
    else Rep = {'Stimuli\Default\VCV'}; end
else
    Rep = {'Stimuli\Default\VCV'};
end
if handles.Silence.Value
    ID = [handles.Code.String,'_Silence'];
else
    ID = [handles.Code.String,'_',handles.BType];
end
handles.Parametres = struct(...
    'StimRep',Rep,...
    'ProgRep','..\..\..',...
    'Aud',handles.Aud,...
    'AudiogD',handles.AudioDdB,...
    'AudiogG',handles.AudioGdB,...
    'SSN',ssn,...
    'RSB',handles.RSB,...
    'level',handles.level,...
    'Oreille',get(handles.Oreille,'Value'),...
    'ID', ID,...
    'TobiiRec',handles.TobiiCheckbox.Value);
out=VCV(handles.Parametres);
set(handles.TextPerf,'String',['Score:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'%']);
set(handles.TextVLM,'String',strvcat(['Voisement:  ',num2str(out.results(2),'%6.2f'),'%'], ['Lieu:            ',num2str(out.results(3),'%6.2f'),'%'], ['Mode:          ',num2str(out.results(4),'%6.2f'),'%']));
handles.VCVp=out.results(1);handles.VCVv=out.results(2);handles.VCVl=out.results(3);handles.VCVm=out.results(4);handles.VCVmat=out.mat;
handles.sequence = out.sequence; % storing trial-specific data as additional information - 18-Oct-2021 - DA

function handles=routine_CVC(handles)
ssn=strcat(handles.BType,'_V.wav');
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\CVC');
    else Rep = {'Stimuli\Default\CVC'}; end
else
    Rep = {'Stimuli\Default\CVC'};
end
handles.Parametres = struct('StimRep',Rep,'ProgRep','..\..\..','Aud',handles.Aud,'AudiogD',handles.AudioDdB,'AudiogG',handles.AudioGdB,'SSN',ssn,'RSB',handles.RSB,'level',handles.level,'Oreille',get(handles.Oreille,'Value'));
out=CVC(handles.Parametres);
set(handles.TextPerf,'String',['Score:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'%']);
handles.CVCp=out.results;handles.CVCmat=out.mat;


function handles=routine_CMR(handles)
ssn=strcat(handles.BType,'_V.wav');
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\CVC');
    else Rep = {'Stimuli\Default\CVC'}; end
else
    Rep = {'Stimuli\Default\CVC'};
end
handles.Parametres = struct('StimRep',Rep,'ProgRep','..\..\..','Aud',handles.Aud,'AudiogD',handles.AudioDdB,'AudiogG',handles.AudioGdB,'SSN',ssn,'RSB',handles.RSB,'level',handles.level,'Oreille',get(handles.Oreille,'Value'),'Code',get(handles.Code,'String'));
out=CMR(handles.Parametres);
set(handles.TextPerf,'String',strvcat(['Seuil_arith:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'dB'], ['STD:  ',num2str(out.results(2),'%6.2f'),'dB']));
set(handles.TextVLM,'String',strvcat(['Seuil_geom:  ',num2str(out.results(3),'%6.2f'),'dB'], ['Nb_essai:            ',num2str(out.results(4),'%6.2f'),' '], ['Perf:          ',num2str(out.results(5),'%6.2f'),'%'],['Seuil_dBSPL:  ',num2str(out.results(6),'%6.2f'),'dBSPL'],['level_std:  ',num2str(out.results(7),'%6.2f'),'dBSPL']));
% handles.courbe=out.mat();
handles.freqm=[out.param(5) out.param(6) out.param(7)]; handles.freqp=[out.param(8) out.param(9) out.param(10) out.param(11)]; handles.dut=[out.param(12) out.param(13) out.param(14)]; handles.task=[out.param(1) out.param(2) out.param(3) out.param(4)];
handles.Seuilarith=out.results(1);handles.STDarith=out.results(2);handles.seuilgeo=out.results(3);handles.nbessai=out.results(4);handles.perf=out.results(5);handles.perfSPL=out.results(6);handles.level_std=out.results(7);



function handles=routine_MLD(handles)
ssn=strcat(handles.BType,'_V.wav');
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\CVC');
    else Rep = {'Stimuli\Default\CVC'}; end
else
    Rep = {'Stimuli\Default\CVC'};
end
handles.Parametres = struct('StimRep',Rep,'ProgRep','..\..\..','Aud',handles.Aud,'AudiogD',handles.AudioDdB,'AudiogG',handles.AudioGdB,'SSN',ssn,'RSB',handles.RSB,'level',handles.level,'Oreille',get(handles.Oreille,'Value'),'Code',get(handles.Code,'String'));
out=MLD(handles.Parametres);
set(handles.TextPerf,'String',strvcat(['Seuil_arith:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'dB'], ['STD:  ',num2str(out.results(2),'%6.2f'),'dB']));
set(handles.TextVLM,'String',strvcat(['Seuil_geom:  ',num2str(out.results(3),'%6.2f'),'dB'], ['Nb_essai:            ',num2str(out.results(4),'%6.2f'),' '], ['Perf:          ',num2str(out.results(5),'%6.2f'),'%'],['Seuil_dBSPL:  ',num2str(out.results(6),'%6.2f'),'dBSPL'],['level_std:  ',num2str(out.results(7),'%6.2f'),'dBSPL']));
% handles.courbe=out.mat();
handles.freqm=[out.param(9) out.param(10) out.param(11)]; handles.freqp=[out.param(12) out.param(13) out.param(14) out.param(15)]; handles.dut=[out.param(16) out.param(17) out.param(18)]; handles.rsb=[out.param(19) out.param(20)];handles.task=[out.param(1) out.param(2) out.param(3) out.param(4)]; handles.condition=[out.param(5) out.param(6) out.param(7) out.param(8)];
handles.Seuilarith=out.results(1);handles.STDarith=out.results(2);handles.seuilgeo=out.results(3);handles.nbessai=out.results(4);handles.perf=out.results(5);handles.perfSPL=out.results(6);handles.level_std=out.results(7);handles.Seuil_geodB=out.results(8);




function handles=routine_IPD(handles)
ssn=strcat(handles.BType,'_V.wav');
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\CVC');
    else Rep = {'Stimuli\Default\CVC'}; end
else
    Rep = {'Stimuli\Default\CVC'};
end
handles.Parametres = struct('StimRep',Rep,'ProgRep','..\..\..','Aud',handles.Aud,'AudiogD',handles.AudioDdB,'AudiogG',handles.AudioGdB,'SSN',ssn,'RSB',handles.RSB,'level',handles.level,'Oreille',get(handles.Oreille,'Value'),'Code',get(handles.Code,'String'));
out=IPD(handles.Parametres);
set(handles.TextPerf,'String',strvcat(['Seuil_arith:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'rad'], ['STD:  ',num2str(out.results(2),'%6.2f'),'rad']));
set(handles.TextVLM,'String',strvcat(['Seuil_geom:  ',num2str(out.results(3),'%6.2f'),'rad'], ['Nb_essai:            ',num2str(out.results(4),'%6.2f'),' '], ['Perf:          ',num2str(out.results(5),'%6.2f'),'%'], ['Seuil_ar_us:            ',num2str(out.results(6),'%6.2f'),'us'], ['STD_ar_us:          ',num2str(out.results(7),'%6.2f'),'us'],['Seuil_geo_us:  ',num2str(RAUCorr(out.results(8)),'%6.2f'),'us']));
% handles.courbe=out.mat();
handles.task=[out.param(11) out.param(12) out.param(13)]; handles.Freq=[out.param(1) out.param(2) out.param(3) out.param(4)]; handles.freqm=[out.param(5) out.param(6) out.param(7)]; handles.dut=[out.param(8) out.param(9) out.param(10)];
handles.Seuilarith=out.results(1);handles.STDarith=out.results(2);handles.seuilgeo=out.results(3);handles.nbessai=out.results(4);handles.perf=out.results(5);handles.Seuilarithus=out.results(6);handles.STDarithus=out.results(7);handles.seuilgeous=out.results(8)



function handles=routine_ModDetectGUI(handles)
ssn=strcat(handles.BType,'_V.wav');
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\CVC');
    else Rep = {'Stimuli\Default\CVC'}; end
else
    Rep = {'Stimuli\Default\CVC'};
end

handles.Parametres = struct('StimRep',Rep,'ProgRep','..\..\..','Aud',handles.Aud,'AudiogD',handles.AudioDdB,'AudiogG',handles.AudioGdB,'SSN',ssn,'RSB',handles.RSB,'level',handles.level,'Oreille',get(handles.Oreille,'Value'),'Code',get(handles.Code,'String'));
out=ModDetectGUI(handles.Parametres);
set(handles.TextPerf,'String',strvcat(['Seuil_arith:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'%'], ['STD:  ',num2str(out.results(2),'%6.2f'),'%']));
set(handles.TextVLM,'String',strvcat(['Seuil_geom:  ',num2str(out.results(3),'%6.2f'),'%'], ['Nb_essai:            ',num2str(out.results(4),'%6.2f'),' '], ['Perf:          ',num2str(out.results(5),'%6.2f'),' '], ['Seuil_arith:            ',num2str(out.results(6),'%6.2f'),'dB'], ['STD_arith:            ',num2str(out.results(7),'%6.2f'),'dB'], ['Seuil_geo:            ',num2str(out.results(8),'%6.2f'),'dB']));
% handles.courbe=out.mat();
handles.freqm=[out.param(3) out.param(4) out.param(5)]; handles.freqp=[out.param(6) out.param(7) out.param(8) out.param(9)]; handles.dut=[out.param(10) out.param(11) out.param(12)]; handles.task=[out.param(1) out.param(2)];
handles.Seuilarith=out.results(1);handles.STDarith=out.results(2);handles.seuilgeo=out.results(3);handles.nbessai=out.results(4);handles.perf=out.results(5);handles.SeuilarithdB=out.results(6);handles.STDarithdB=out.results(7);handles.seuilgeodB=out.results(8);


function handles=routine_Integration_ModDetect(handles)
ssn=strcat(handles.BType,'_V.wav');
if exist('Data.log','file')~=0
    load -mat Data.log
    if isfield(Data,'StimRep'), Rep = strcat('Stimuli\' , Data.StimRep, '\CVC');
    else Rep = {'Stimuli\Default\CVC'}; end
else
    Rep = {'Stimuli\Default\CVC'};
end

handles.Parametres = struct('StimRep',Rep,'ProgRep','..\..\..','Aud',handles.Aud,'AudiogD',handles.AudioDdB,'AudiogG',handles.AudioGdB,'SSN',ssn,'RSB',handles.RSB,'level',handles.level,'Oreille',get(handles.Oreille,'Value'),'Code',get(handles.Code,'String'));
out=Integration_ModDetect(handles.Parametres);
set(handles.TextPerf,'String',strvcat(['Seuil_arith:  ',num2str(RAUCorr(out.results(1)),'%6.2f'),'%'], ['STD:  ',num2str(out.results(2),'%6.2f'),'%']));
set(handles.TextVLM,'String',strvcat(['Seuil_geom:  ',num2str(out.results(3),'%6.2f'),'%'], ['Nb_essai:            ',num2str(out.results(4),'%6.2f'),' '], ['Perf:          ',num2str(out.results(5),'%6.2f'),' '], ['Seuil_arith:            ',num2str(out.results(6),'%6.2f'),'dB'], ['STD_arith:            ',num2str(out.results(7),'%6.2f'),'dB'], ['Seuil_geo:            ',num2str(out.results(8),'%6.2f'),'dB']));
% handles.courbe=out.mat();
handles.freqm=[out.param(3) out.param(4) out.param(5)]; handles.freqp=[out.param(6) out.param(7) out.param(8) out.param(9)]; handles.dut=[out.param(10)]; handles.task=[out.param(1) out.param(2)];
handles.Seuilarith=out.results(1);handles.STDarith=out.results(2);handles.seuilgeo=out.results(3);handles.nbessai=out.results(4);handles.perf=out.results(5);handles.SeuilarithdB=out.results(6);handles.STDarithdB=out.results(7);handles.seuilgeodB=out.results(8);


function routine_alloff(handles)
set(handles.Run,'Enable','off');
set(handles.ModifAudiogD,'Enable','off');
set(handles.ModifAudiogG,'Enable','off');
set(handles.Code,'Enable','off');
set(handles.Jour,'Enable','off');
set(handles.Mois,'Enable','off');
set(handles.Annee,'Enable','off');
set(handles.Sexe,'Enable','off');
set(handles.Oreille,'Enable','off');
set(handles.Stim,'Enable','off');
set(handles.Level,'Enable','off');
set(handles.AudOn,'Enable','off');
set(handles.AudOff,'Enable','off');
set(handles.Silence,'Enable','off');
set(handles.Stat,'Enable','off');
set(handles.Tempo,'Enable','off');
set(handles.Spectro,'Enable','off');
set(handles.SpectroTempo,'Enable','off');
set(handles.Info,'Enable','off');
set(handles.InfoTxt,'Enable','off');
set(handles.InfoTxt,'BackgroundColor',[236 233 216]./256);
set(handles.InRSB,'Enable','off');

function routine_outsave(handles)
tmp=get(handles.Sexe,'String');
sx=char(tmp(get(handles.Sexe,'Value')));
tmp=get(handles.Oreille,'String');
or=char(tmp(get(handles.Oreille,'Value')));
if get(handles.Info,'Value')==6
    ss=get(handles.InfoTxt,'String');
else
    tmp=get(handles.Info,'String');
    ss=char(tmp(get(handles.Info,'Value')));
end

c=clock;
c1=num2str(c(3));if length(c1)==1, c1=['0' c1];end
c2=num2str(c(2));if length(c2)==1, c2=['0' c2];end
c3=num2str(c(1));c3=c3(3:4);
c4=num2str(c(4));if length(c4)==1, c4=['0' c4];end
c5=num2str(c(5));if length(c5)==1, c5=['0' c5];end
date=[c1 '/' c2 '/' c3 ' - ' c4 'h' c5];
name=[get(handles.Code,'String') '_' c1 c2 c3 c4 c5];

if get(handles.Silence,'Value'), bb='Silence';
elseif get(handles.Stat,'Value'), bb='BStationnaire';
elseif get(handles.Tempo,'Value'), bb='BFluctTempo';
elseif get(handles.Spectro,'Value'), bb='BFluctSpectro';
elseif get(handles.SpectroTempo,'Value'), bb='BFluctSpectroTempo';
elseif get(handles.VCVCV,'Value'), bb='VCVCV';
end

if get(handles.AudOn,'Value')
    aa='ON';
    AudioDdBtmp=handles.AudioDdB;
    AudioGdBtmp=handles.AudioGdB;
else
    aa='OFF';
    AudioDdBtmp=['X' 'X' 'X' 'X' 'X' 'X' 'X'];
    AudioGdBtmp=['X' 'X' 'X' 'X' 'X' 'X' 'X'];
end

if get(handles.Stim,'Value')==2
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'Oreille',or,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','VCVCV','Bruit',bb,...
                     'Performance',RAUCorr(handles.VCVp),'Voisement',handles.VCVv,'Lieu',handles.VCVl,'Mode',handles.VCVm,'Matrice',handles.VCVmat,...
                     'Sequence',handles.sequence); % new entry, to save trial-specific data to disk - 18-Oct.2021 - DA

%     resultats_xls={'Code','Date','DateDeNaissance','Sexe','TypeSurdite','Oreille','ControleAudibilite',...
%                    'AudiogD250','AudiogD500','AudiogD1000','AudiogD2000','AudiogD4000','AudiogD8000',...
%                    'AudiogG250','AudiogG500','AudiogG1000','AudiogG2000','AudiogG4000','AudiogG8000',...
%                    'Stmuli','Bruit','Perf','Voisement','Lieu','Mode';...
%                    get(handles.Code,'String'),date,[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
%                    sx,ss,or,aa,AudioDdBtmp(1),AudioDdBtmp(2),AudioDdBtmp(3),AudioDdBtmp(4),AudioDdBtmp(5),AudioDdBtmp(6),AudioGdBtmp(1),AudioGdBtmp(2),AudioGdBtmp(3),AudioGdBtmp(4),AudioGdBtmp(5),AudioGdBtmp(6),...
%                    'VCVCV',bb,RAUCorr(handles.VCVp),handles.VCVv,handles.VCVl,handles.VCVm};
%                
elseif get(handles.Stim,'Value')==3
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'Oreille',or,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','CVCVC','Bruit',bb,...
                     'Performance',RAUCorr(handles.CVCp),'Matrice',handles.CVCmat);

%     resultats_xls={'Code','Date','DateDeNaissance','Sexe','TypeSurdite','Oreille','ControleAudibilite',...
%                    'AudiogD250','AudiogD500','AudiogD1000','AudiogD2000','AudiogD4000','AudiogD8000',...
%                    'AudiogG250','AudiogG500','AudiogG1000','AudiogG2000','AudiogG4000','AudiogG8000',...
%                    'Stmuli','Bruit','Perf','Voisement','Lieu','Mode';...
%                    get(handles.Code,'String'),date,[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
%                    sx,ss,or,aa,AudioDdBtmp(1),AudioDdBtmp(2),AudioDdBtmp(3),AudioDdBtmp(4),AudioDdBtmp(5),AudioDdBtmp(6),AudioGdBtmp(1),AudioGdBtmp(2),AudioGdBtmp(3),AudioGdBtmp(4),AudioGdBtmp(5),AudioGdBtmp(6),...
%                    'CVCVC',bb,RAUCorr(handles.CVCp),'X','X','X'};
               
elseif get(handles.Stim,'Value')==4
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'Oreille',or,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','ModDetect','Bruit',bb,...
                     'Seuil_arith',handles.Seuilarith,'STD_arith',handles.STDarith,'seuil_geo',handles.seuilgeo,'Nb_essai',handles.nbessai,'Perf',handles.perf,...
                     'Seuil_arithdB',handles.SeuilarithdB,'STD_arithdB',handles.STDarithdB,'seuil_geodB',handles.seuilgeodB,...
                     'Frequence_Modulation_Hz',num2str(handles.freqm),'Porteuse_kHz',num2str(handles.freqp),'Duree_sec',num2str(handles.dut),'Tache',num2str(handles.task));
                 
    resultats_xls={'Code','Date','DateDeNaissance','Sexe','TypeSurdite','Oreille','ControleAudibilite',...
                   'AudiogD250','AudiogD500','AudiogD1000','AudiogD2000','AudiogD4000','AudiogD8000','AudiogG250','AudiogG500','AudiogG1000','AudiogG2000','AudiogG4000','AudiogG8000',...
                   'Stmuli','Bruit','Seuil_arith','STD_arith','Seuil_geo','Nb_essai','Perf','Seuil_arithdB','STD_arithdB','Seuil_geodB','Frequence_Modulation_Hz','Porteuse_kHz','Duree_sec','Tache';...
                   get(handles.Code,'String'),date,[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                   sx,ss,or,aa,AudioDdBtmp(1),AudioDdBtmp(2),AudioDdBtmp(3),AudioDdBtmp(4),AudioDdBtmp(5),AudioDdBtmp(6),AudioGdBtmp(1),AudioGdBtmp(2),AudioGdBtmp(3),AudioGdBtmp(4),AudioGdBtmp(5),AudioGdBtmp(6),...
                   'ModDetect',bb,handles.Seuilarith,handles.STDarith,handles.seuilgeo,handles.nbessai,handles.perf,handles.SeuilarithdB,handles.STDarithdB,handles.seuilgeodB,num2str(handles.freqm),num2str(handles.freqp),num2str(handles.dut),num2str(handles.task)};               
  

elseif get(handles.Stim,'Value')==5
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'Oreille',or,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','BMLD','Bruit',bb,...
                     'Seuil_arith',handles.Seuilarith,'STD_arith',handles.STDarith,'seuil_geo',handles.seuilgeo,'Nb_essai',handles.nbessai,'Perf',handles.perf,'Seuil_SPL',handles.perfSPL,'Seuil_std_SPL',handles.level_std,'Seuil_geo_SPL',handles.Seuil_geodB,...
                     'Frequence_Modulation_Hz',num2str(handles.freqm),'Porteuse_kHz',num2str(handles.freqp),'RSB',num2str(handles.rsb),'Duree_sec',num2str(handles.dut),'Tache',num2str(handles.task),'Condition',num2str(handles.condition));
                 
    resultats_xls={'Code','Date','DateDeNaissance','Sexe','TypeSurdite','Oreille','ControleAudibilite',...
                   'AudiogD250','AudiogD500','AudiogD1000','AudiogD2000','AudiogD4000','AudiogD8000','AudiogG250','AudiogG500','AudiogG1000','AudiogG2000','AudiogG4000','AudiogG8000',...
                   'Stmuli','Bruit','Seuil_arith','STD_arith','Seuil_geo','Nb_essai','Perf','Seuil_SPL','Seuil_std_SPL','Seuil_SPL_geo';...
                   get(handles.Code,'String'),date,[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                   sx,ss,or,aa,AudioDdBtmp(1),AudioDdBtmp(2),AudioDdBtmp(3),AudioDdBtmp(4),AudioDdBtmp(5),AudioDdBtmp(6),AudioGdBtmp(1),AudioGdBtmp(2),AudioGdBtmp(3),AudioGdBtmp(4),AudioGdBtmp(5),AudioGdBtmp(6),...
                   handles.task,bb,handles.Seuilarith,handles.STDarith,handles.seuilgeo,handles.nbessai,handles.perf,handles.perfSPL,handles.level_std,handles.Seuil_geodB};               

         
elseif get(handles.Stim,'Value')==6
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'Oreille',or,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','IPD','Bruit',bb,...
                     'Seuil_arith',handles.Seuilarith,'STD_arith',handles.STDarith,'seuil_geo',handles.seuilgeo,'Nb_essai',handles.nbessai,'Perf',handles.perf,'Seuil_arithus',handles.Seuilarithus,'STD_arithus',handles.STDarithus,'seuil_geous',handles.seuilgeous,...
                     'Tache',num2str(handles.task),'Frequence_Porteuse_kHz',num2str(handles.Freq),'Frequence_Modulation_Hz',num2str(handles.freqm),'Duree_sec',num2str(handles.dut));
                
                 
    resultats_xls={'Code','Date','DateDeNaissance','Sexe','TypeSurdite','Oreille','ControleAudibilite',...
                   'AudiogD250','AudiogD500','AudiogD1000','AudiogD2000','AudiogD4000','AudiogD8000','AudiogG250','AudiogG500','AudiogG1000','AudiogG2000','AudiogG4000','AudiogG8000',...
                   'Stmuli','Bruit','Seuil_arith','STD_arith','Seuil_geo','Nb_essai','Perf','Seuil_arithus','STD_arithus','seuil_geous'; ...
                   get(handles.Code,'String'),date,[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                   sx,ss,or,aa,AudioDdBtmp(1),AudioDdBtmp(2),AudioDdBtmp(3),AudioDdBtmp(4),AudioDdBtmp(5),AudioDdBtmp(6),AudioGdBtmp(1),AudioGdBtmp(2),AudioGdBtmp(3),AudioGdBtmp(4),AudioGdBtmp(5),AudioGdBtmp(6),...
                   'IPD',bb,handles.Seuilarith,handles.STDarith,handles.seuilgeo,handles.nbessai,handles.perf,handles.Seuilarithus,handles.STDarithus,handles.seuilgeous};         

elseif get(handles.Stim,'Value')==7
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','CMR','Bruit',bb,...
                     'Seuil_arith',handles.Seuilarith,'STD_arith',handles.STDarith,'seuil_geo',handles.seuilgeo,'Nb_essai',handles.nbessai,'Perf',handles.perf,'Seuil_SPL',handles.perfSPL,'Level_std',handles.level_std,...
                     'Tache',handles.task ,'Frequence_Modulation_Hz',num2str(handles.freqm),'Porteuse_kHz',num2str(handles.freqp),'Duree_sec',num2str(handles.dut));
                 
    resultats_xls={'Code','Date','DateDeNaissance','Sexe','TypeSurdite','Oreille','ControleAudibilite',...
                   'AudiogD250','AudiogD500','AudiogD1000','AudiogD2000','AudiogD4000','AudiogD8000','AudiogG250','AudiogG500','AudiogG1000','AudiogG2000','AudiogG4000','AudiogG8000',...
                   'Stmuli','Bruit','Seuil_arith','STD_arith','Seuil_geo','Nb_essai','Perf','Seuil_SPL','Level_std';...
                   get(handles.Code,'String'),date,[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                   sx,ss,or,aa,AudioDdBtmp(1),AudioDdBtmp(2),AudioDdBtmp(3),AudioDdBtmp(4),AudioDdBtmp(5),AudioDdBtmp(6),AudioGdBtmp(1),AudioGdBtmp(2),AudioGdBtmp(3),AudioGdBtmp(4),AudioGdBtmp(5),AudioGdBtmp(6),...
                   'CMR',bb,handles.Seuilarith,handles.STDarith,handles.seuilgeo,handles.nbessai,handles.perf,handles.perfSPL,handles.level_std}; 

elseif get(handles.Stim,'Value')==8
    resultats_mat=struct('Code',get(handles.Code,'String'),'Date',date,...
                     'DateDeNaissance',[get(handles.Jour,'String'),'/',get(handles.Mois,'String'),'/',get(handles.Annee,'String')],...
                     'Sexe',sx,'TypeSurdite',ss,'Oreille',or,'ControleAudibilite',aa,...
                     'AudiogrammeD',AudioDdBtmp,'AudiogrammeG',AudioGdBtmp,'Stimuli','ModDetect','Bruit',bb,...
                     'Seuil_arith',handles.Seuilarith,'STD_arith',handles.STDarith,'seuil_geo',handles.seuilgeo,'Nb_essai',handles.nbessai,'Perf',handles.perf,...
                     'Seuil_arithdB',handles.SeuilarithdB,'STD_arithdB',handles.STDarithdB,'seuil_geodB',handles.seuilgeodB,...
                     'Frequence_Modulation_Hz',num2str(handles.freqm),'Porteuse_kHz',num2str(handles.freqp),'NbCycles',num2str(handles.dut),'Tache',num2str(handles.task));
                 

end


cd Resultats
if exist('DataExp.mat','file')==0
    data=struct(name,resultats_mat);
else
    load DataExp.mat
    data=setfield(data,name,resultats_mat);
end
save DataExp.mat data


    if get(handles.Stim,'Value')==5
        if exist('DataMLD.xls','file')==0
        xlswrite('DataMLD.xls', resultats_xls);
        else
        [num txt raw]=xlsread('DataMLD.xls');
        raw=[raw;resultats_xls(2,:)];
        xlswrite('DataMLD.xls', raw);
        end
    elseif get(handles.Stim,'Value')==6
        if exist('DataIPD.xls','file')==0
        xlswrite('DataIPD.xls', resultats_xls);
        else
        [num txt raw]=xlsread('DataIPD.xls');
        raw=[raw;resultats_xls(2,:)];
        xlswrite('DataIPD.xls', raw);
        end
    elseif get(handles.Stim,'Value')==7

        if exist('DataCMR.xls','file')==0
        xlswrite('DataCMR.xls', resultats_xls);
        else
        [num txt raw]=xlsread('DataCMR.xls');
        raw=[raw;resultats_xls(2,:)];
        xlswrite('DataCMR.xls', raw);
        end
%     elseif get(handles.Stim,'Value')==8,
% 
%         if exist('DataIntegration.xls','file')==0,
%         xlswrite('DataIntegration.xls', resultats_xls);
%         else
%         [num txt raw]=xlsread('DataIntegration.xls');
%         raw=[raw;resultats_xls(2,:)];
%         xlswrite('DataIntegration.xls', raw);
%         end
        
    end
    

cd ..



  
    
% --- Executes on button press in ModifAudiogG.
function ModifAudiogG_Callback(hObject, eventdata, handles)
% hObject    handle to ModifAudiogG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)set(hObject,'Enable','off');
set(handles.ModifText2,'FontSize',19);
set(handles.ModifText2,'Visible','on');
outG=0;

handles.AudioGdB=[0 0 0 0 0 0 0];
DonePointsG=[0 0 0 0 0 0 0];

%plot([0 1 2 3 4 5],handles.AudioGdB,'rx-','LineWidth',3,'MarkerSize',15);
% cla
axis([-0.5 6.5 -90 10])
set(handles.AudiogG,'Box','on')
set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
set(handles.AudiogG,'XMinorTick','off')
set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
grid on
    
while outG==0
[xx,yy]=ginput(1);
qq=isempty(xx);
if qq || (xx<-0.5) || (xx>6.5) || (yy>10) || (yy<-90)
    outG=1;
    plot([0 1 2 3 4 5 6],handles.AudioGdB,'rx-','LineWidth',3,'MarkerSize',15);
    %plot(x,y,'rx-','LineWidth',3,'MarkerSize',15);
    axis([-0.5 6.5 -90 10])
    set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
    set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
    set(handles.AudiogG,'XMinorTick','off')
    set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
    set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
    grid on
else    
    xx=round(xx);
    if xx<0, xx=0;end
    if xx>6, xx=6;end
    
    yy=round(yy/5)*5;
    if yy>0, yy=0;end
    if yy<-80, yy=-80;end
    
    handles.AudioGdB(xx+1)=yy;
    DonePointsG(xx+1)=1;
    %plot([0 1 2 3 4 5],handles.AudioGdB,'rx-','LineWidth',3,'MarkerSize',15);
    %hold on
    for k=1:length(DonePointsG)
        if DonePointsG(k)==1
            plot(k-1,handles.AudioGdB(k),'rx-','LineWidth',3,'MarkerSize',15);
            hold on;
        end
    end
    hold off
    %plot(x,y,'rx-','LineWidth',3,'MarkerSize',15);
    axis([-0.5 6.5 -90 10])
    set(handles.AudiogG,'XTick',[0 1 2 3 4 5 6])
    set(handles.AudiogG,'XTickLabel',{'250','500','1000','2000','3000','4000','8000'})
    set(handles.AudiogG,'XMinorTick','off')
    set(handles.AudiogG,'YTick',[-80 -70 -60 -50 -40 -30 -20 -10 0])
    set(handles.AudiogG,'YTickLabel',{'-80','','-60','','-40','','-20','','0'})
    grid on
end
end

set(hObject,'Enable','on');
set(handles.ModifText2,'Visible','off');

guidata(hObject, handles);




% --- Executes on button press in TobiiCheckbox.
function TobiiCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to TobiiCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TobiiCheckbox
