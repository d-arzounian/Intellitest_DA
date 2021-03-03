function [out, varargout]=Recov_FM_B2_1ERB(x)

% This function does pass the original speech stimulus through a 4-band
% vocoder, then for each band, removes (ie, flattens) the AM component while leaving the FM component intact above a given threshold (ie, FM carrier=silence below -20dB re: rms) 
% and finally extracts only the second band
%
% This program then computes the recovered envelopes from 32 narrowband
% channels that are 1ERB wide and outputs the "recovered" envelope signal
% in the variable out. The Q values are set to Shera et al., 2002
%
% Program originally created by Dan Gnansia and modified by Jayaganesh
% Swaminathan on 01/04/12

x = x ./ sqrt(mean(x.^2)); % normalization in RMS power of the speech stimulus

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

%%%To compute the recov condition%%%
[out, varargout] = Recov_1ERB(y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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