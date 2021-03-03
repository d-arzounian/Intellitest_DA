function y=FM_vocoder_B2_Noise_0dBSNR(x)

% This function passes the original speech stimulus through the 2nd band of a 4-band
% vocoder, then, removes (ie, flattens) the AM component while leaving the FM component intact above a given threshold (ie, FM carrier=silence below -20dB re: rms) 
% and finally extracts only the first band. Finally, the program adds
% bandpass filtered pinknoise at a specified SNR to the original
% bandlimited FM signal

x = x ./ sqrt(mean(x.^2)); % normalization in RMS power of the speech stimulus
SNR=0;

load filterparam.mat

[bhp,ahp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2),'high');

x_bdf=gammafilter(x,Den,Num,nbch);
x_bdf=gammasynth_m(deltan1,deltamax1,phi1,mix1,x_bdf);

env=zeros(nbch,length(x_bdf));

for k=2:2,
    [Benv,Aenv]=butter(4,(fb1(k)/8)/44100);
    tmp=filter(Benv,Aenv,x_bdf(k,:).*(x_bdf(k,:)>0)); % AM component (extracted via half-wave rect and lowpass filtering) of the narrowband signal
    
    rms=20*log10(sqrt(mean(tmp.^2)));  % RMS power in the current band
    threshold=10^((rms-20)/20);  % threholds to apply to the AM ; threshold= -20 dB re: RMS
    env(k,:)=1.*(abs(tmp)>threshold); % AM fluctuations changed into "1" (ie, constant level) if above a threshold set at -20 dB re: rms in the current band, otherwise "0"
    [Benv,Aenv]=butter(1,(fb1(k)/8)/44100); 
    env(k,:)=filter(Benv,Aenv,env(k,:)); % smoothing of abrupt AM transitions via lowpass filtering
    x_bdf(k,:)=mean(abs(tmp)).*cos(angle(x_bdf(k,:))); % reconstruction of the final signal
end

%y1=sum(x_bdf(1:3,:),1);

y = x_bdf(k,:);


%%%To generate pinknoise and add to the signal at specific SNR%%%%%%
noise = pinknoise(length(y),472,1408);
rms_signal=sqrt(mean(y.^2)); %To compute the RMS of the original signal
rms_scale=10^(SNR/20);
rms_noise=sqrt(mean(noise.^2));
noise=((1/rms_scale).*rms_signal.*noise./rms_noise);
y=y+noise(1:length(y));
dBSPL_signal_final=20*log10(sqrt(mean(y.^2))/(20e-6));
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