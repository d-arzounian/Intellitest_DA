clear all 
close all

clc


Fs = 44100;


rand('state',sum(100*clock));

fp=500;      % carrier frequency
fm=20;       % modulation frequency
dt=2;        % lenght of target and standard

duree_targ = (dt/fm)*Fs;    % target duration
duree_stand = (dt/fm)*Fs;   % standard duration = 1 sec

duree_ramp = round(0.5/fm*Fs);        %Cosine ramp duration = 1/2 période de Fm
freq_ramp = 1/2*duree_ramp;

t_stim = 1:duree_targ;

%modulation parameters
%phi=2*pi*rand(1,1);
amp=1;
%scale=7;
m=0.8;                   %Modulation depth starting value = 1
deltaf = fm*5*2*2;        % Excursions de fréquences df = 50Hz ; p-t-p = 100Hz



%silent interval parameters
duree_sil = 0.4*Fs;     %silence duration = 0.5 sec (-2*0.05 de 0 padding)
silence = zeros(duree_sil,1);

% zero padding 50ms ante et post stim

duree_zero = 0.05*Fs;
padding = zeros(duree_zero,1);


%2I2AFC parameters
nb_essais_max = 150;
Tab_m = zeros(nb_essais_max,1); % création tableau remplis de 0 à 1 colonne et autant de ligne que le nb d'essai max
Tab_deltaf = zeros(nb_essais_max,1); % création tableau remplis de 0 à 1 colonne et autant de ligne que le nb d'essai max

Essais_corrects = 0;
Nb_inversions = 0;
max_inversions_1 = 2;   %nb d'inversion avant modification du pas
max_inversions_2 = 12;  % nb d'inversion avec le pas final

dB_down_1 = 4;          % pas initial en dB /initial step adaptive staircase
dB_down_2 = 2;          % pas final en dB/ final step adaptive staircase

lin_down_1 = 10.^(dB_down_1/20);    
lin_down_2 = 10.^(dB_down_2/20);


%initialisation loop
Facteur_down = lin_down_1;      % départ avec pas initial
Essai = 0;
%handles.Reponse = 0;
Nb_trials = 0;
Nb_correct_trials = 0;

%sine ramps
tmp = 1:duree_ramp;
onset  = (1+sin(2*pi*fm*tmp./Fs + (-pi/2)))/2;
offset = (1+sin(2*pi*fm*tmp./Fs + (pi/2)))/2;
steady = ones(1,duree_targ - (2*duree_ramp));
ramp_vector = [onset steady offset];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
while Essai<nb_essais_max
    Essai = Essai + 1;


%     modulation_target = (1 + m.*sin(2*pi*fm*t_stim./Fs + 3*pi/2)).*sin(2*pi*fp*t_stim./Fs + 2*pi*rand(1,1));
%     modulation_standard = 1.*sin(2*pi*fp*t_stim./Fs + 2*pi*rand(1,1));
%    

 
    beta=deltaf./fm;     % facteur beta de modulation en FM + AM interférente
    modulation_target = (1 + 0.33.*sin(2*pi*fm*t_stim./Fs + 3*pi/2)).*sin((2*pi*fp*t_stim./Fs + 2*pi*rand(1,1))+beta.*(sin(2*pi*fm*t_stim./Fs + 2*pi*rand(1,1))));
    modulation_standard = (1 + 0.33.*sin(2*pi*fm*t_stim./Fs + 3*pi/2)).*sin((2*pi*fp*t_stim./Fs + 2*pi*rand(1,1))); 
%    
end
    target = ramp_vector .* modulation_target;
%     target = modulation_target;
%     target = [padding' target padding'];
    target = target ./ sqrt(mean(target.^2));
    target = target.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
%     target = target ./ Scale;
    
    standard = ramp_vector .* modulation_standard;
%     standard = modulation_standard;
%     standard = [padding' standard padding'];
    standard = standard ./ sqrt(mean(standard.^2));
    standard = standard.* 10^((-1.5+3.*rand(1,1))/20);     %roving +-1.5dB
%     standard = standard ./ Scale;       


subplot(4,1,1)
plot(modulation_target)

subplot(4,1,2)
plot(ramp_vector)

subplot(4,1,3)
plot(target)

subplot(4,1,4)
plot(standard)

    