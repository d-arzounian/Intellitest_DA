function [out, varargout]=Recov8_4B_SSN_seuil(x)

% This function does pass the original speech stimulus through a 4-band
% vocoder, then for each band, removes (ie, flattens) the AM component while leaving the FM component intact above a given threshold (ie, FM carrier=silence below -20dB re: rms) 
% and finally removes the 4th band and replaces it with a high-pass filtered
% pink noise at an SNR of +12 dB

load filterparam.mat

[bhp,ahp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2),'high');

x_bdf=gammafilter(x,Den,Num,nbch);
x_bdf=gammasynth_m(deltan1,deltamax1,phi1,mix1,x_bdf);

cd ..
cd Bruits
noise = wavread('SSN_C.wav');
cd ..
cd Plugins

d=round(10000*rand(1,1));
noise = noise(d:d+length(x_bdf)-1);

noise = filter(bhp,ahp,noise); % highpass filtering the  SSN noise masker
% noise = noise ./ sqrt(mean(noise.^2)); % noise normalized in RMS power (=1)
% pknoise = noise .* 10^(-12/20); % noise added to speech at an SNR=+12 dB

env=zeros(nbch,length(x_bdf));


for k=1:nbch,
    [Benv,Aenv]=butter(4,(fb1(k)/8)/44100);
    tmp=filter(Benv,Aenv,x_bdf(k,:).*(x_bdf(k,:)>0)); % AM component (extracted via half-wave rect and lowpass filtering) of the narrowband signal
    rms=20*log10(sqrt(mean(tmp.^2)));  % RMS power in the current band
    threshold=10^((rms-20)/20);  % threholds to apply to the AM ; threshold= -20 dB re: RMS
    env(k,:)=1.*(abs(tmp)>threshold); % AM fluctuations changed into "1" (ie, constant level) if above a threshold set at -20 dB re: rms in the current band, otherwise "0"
    [Benv,Aenv]=butter(1,(fb1(k)/8)/44100); 
    env(k,:)=filter(Benv,Aenv,env(k,:)); % smoothing of abrupt AM transitions via lowpass filtering
    x_bdf(k,:)=env(k,:).*cos(angle(x_bdf(k,:))); % reconstruction of the final signal
    %x_bdf(k,:)=env(k,:).*sin(2*pi*fc1(k).*t./Fs + rand(1)*2*pi);
end

y1=sum(x_bdf(1:nbch,:),1);% somme des 4 bandes
[blp,alp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2));
y1=filter(blp,alp,y1);
y1 = y1 ./ sqrt(mean(y1.^2)); % normalization in RMS power of the vocoded speech stimulus

%%%%%%%%%%%%% Applied the noise %%%%%%%%%%
rms_db=12; % SNR +12 dB
rms_scale=10^(rms_db/20);
rms_noise=sqrt(mean(noise.^2)); rms_signal=sqrt(mean(y1.^2)); %RMS level for noise and for speech
pknoise=((1/rms_scale).*rms_signal.*noise./rms_noise); % normalization of the noise + application of the SNR re: to the RMS of the speech

y1=y1 + pknoise; % addition of the high-pass filtered SSN noise masker at an SNR of +12 dB
[out, varargout] = Recov_8ERB(y1);
y = y1 ./ sqrt(mean(y1.^2)); % normalization in RMS power of the vocoded speech stimulus


%wavwrite(y,44100,FM4bands);


%%%%%%%%%%%%%%

function y=gammafilter(x,den,num,nbch)

for n=1:nbch,
    y(n,:)=filter(num(n),den(n,:),x);
end


%%%%%%%%%%%%%%


function y=gammasynth_m(deltan,deltamax,phi,mix,x)

nbch=length(phi);

for n=1:nbch,
    x2(n,:) = exp(i*phi(n)).* x(n,:);%cos(phi(n))*real(x(n,:)) - sin(phi(n))*imag(x(n,:));
    x3(n,:) = [zeros(1,deltan(n)) x2(n,:) zeros(1,deltamax-deltan(n))];
    y(n,:) = x3(n,:).*mix(n);
end

%y=(x3.*mix);