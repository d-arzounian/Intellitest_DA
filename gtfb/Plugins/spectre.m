

load filterparam.mat

cd 'C:\Users\Nicolas ENS\Documents\MATLAB\'Spectre''
[x, Fs, bits] = wavread ('ababa1a');% si valeur su volet d�roulant = 2; fixe niv. stim � 60dB 
wavplay(x,Fs);


[bhp,ahp]=butter(12,(3645)/(Fs/2),'high'); % fr�quence de coupure remise � 3645Hz pour �tre idem 4 bands

x_bdf=gammafilter(x,Den,Num,nbch);
x_bdf=gammasynth_m(deltan1,deltamax1,phi1,mix1,x_bdf);

noise = wavread('SSN_C.wav');

d=round(10000*rand(1,1));
noise = noise(d:d+length(x_bdf)-1);

noise = filter(bhp,ahp,noise); % highpass filtering the  SSN noise masker
% noise = noise ./ sqrt(mean(noise.^2)); % noise normalized in RMS power (=1)
% pknoise = noise .* 10^(-12/20); % noise added to speech at an SNR=+12 dB

env=zeros(nbch,length(x_bdf));


for k=1:nbch,
    %[Benv,Aenv]=butter(4,(fb1(k)/8)/44100);
    [Benv,Aenv]=butter(4,(fb1(k)/2)/44100); % BP de 2 ERB et non plus 8 ERB
    tmp=filter(Benv,Aenv,x_bdf(k,:).*(x_bdf(k,:)>0)); % AM component (extracted via half-wave rect and lowpass filtering) of the narrowband signal
    rms=20*log10(sqrt(mean(tmp.^2)));  % RMS power in the current band
    threshold=10^((rms-120)/20);  % threholds to apply to the AM ; threshold= -20 dB re: RMS
    env(k,:)=1.*(abs(tmp)>threshold); % AM fluctuations changed into "1" (ie, constant level) if above a threshold set at -20 dB re: rms in the current band, otherwise "0"   %[Benv,Aenv]=butter(1,(fb1(k)/8)/44100); 
    [Benv,Aenv]=butter(1,(fb1(k)/2)/44100); % BP de 2 ERB et non plus 8 ERB
    env(k,:)=filter(Benv,Aenv,env(k,:)); % smoothing of abrupt AM transitions via lowpass filtering
    x_bdf(k,:)=env(k,:).*cos(angle(x_bdf(k,:))); % reconstruction of the final signal
    %x_bdf(k,:)=env(k,:).*sin(2*pi*fc1(k).*t./Fs + rand(1)*2*pi);
end

y1=sum(x_bdf(1:nbch,:),1);% somme des 4 bandes
%[blp,alp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2));
[blp,alp]=butter(12,(3645)/(Fs/2)); % Filtrage passe bas au dela de 3645 Hz
y1=filter(blp,alp,y1);
y1 = y1 ./ sqrt(mean(y1.^2)); % normalization in RMS power of the vocoded speech stimulus

%%%%%%%%%%%%% Applied the noise %%%%%%%%%%
rms_db=12; % SNR +12 dB
rms_scale=10^(rms_db/20);
rms_noise=sqrt(mean(noise.^2)); rms_signal=sqrt(mean(y1.^2)); %RMS level for noise and for speech
pknoise=((1/rms_scale).*rms_signal.*noise./rms_noise); % normalization of the noise + application of the SNR re: to the RMS of the speech

y1=y1 + pknoise; % addition of the high-pass filtered SSN noise masker at an SNR of +12 dB
[y1] = Recov_8ERB(y1);
y = y1 ./ sqrt(mean(y1.^2)); % normalization in RMS power of the vocoded speech stimulus
wavplay(y,Fs);



% %%%%%%%%%%% Repr�sentation signal d'origine %%%%%%
nbEchFFT=512; 
recouv=95/100; 
Te=1/Fs; 
n=length(y); 
t=0:Te:(n-1)*Te;
figure (2);
subplot(1,3,1);
set(gca, 'fontsize', 15); 
plot(t,y); xlabel('temps [s]'); ylabel('s(t)'); 
axis([0 1.2 -3 3]);
Fee=3000*2;
title('Waveform of a single /aBaBa/', 'FontSize',16);

subplot(1,3,2);
set(gca, 'fontsize', 15); 
spectrogram(y,nbEchFFT, floor(nbEchFFT*recouv), nbEchFFT, Fs, 'yaxis'); 
axis([0 1.2 0 8957]);
title('Spectrogram of the /aBaBa/', 'FontSize',16);
xlabel('temps [s]'); ylabel('fr�quence [Hz]'); 

subplot(1,3,3);
set(gca, 'fontsize', 15); 
fs = 44100;

[pxx,f] = pwelch(y,22050,13240,11050,fs);
plot(f,10*log10(pxx))
title('Power spectral density estimate (Welch)', 'FontSize',16);

xlabel('fr�quence [Hz]'); ylabel('Level [dB]');
axis([0 8957 0 -120]);











