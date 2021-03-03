function y=TFS_NOvocoderT(x)

load filterparam.mat

[bhp,ahp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2),'high');

%threshold=0.01;

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
env=zeros(nbch,length(x_bdf));


for k=1:nbch,
    %tmp=filtfilt(Benv,Aenv,abs(x_bdf(k,:)));
%     [Benv,Aenv]=butter(4,(fb1(k)/8)/44100);
%     tmp=filter(Benv,Aenv,x_bdf(k,:).*(x_bdf(k,:)>0));
    tmp=abs(x_bdf(k,:));
    
%     rms=20*log10(sqrt(mean(tmp.^2)));
%     threshold=10^((rms-20)/20);
%     env(k,:)=1.*(abs(tmp)>threshold);
%     [Benv,Aenv]=butter(1,(fb1(k)/8)/44100);
%     env(k,:)=filter(Benv,Aenv,env(k,:));
    x_bdf(k,:)=tmp.*cos(angle(x_bdf(k,:)));%./rms;
    %x_bdf(k,:)=x_bdf(k,:).*sin(2*pi*fc1(k).*t./Fs + rand(1)*2*pi);
end

y1=sum(x_bdf(1:nbch,:),1); % somme des 4 bandes
[blp,alp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2));
y1=filter(blp,alp,y1);
y1 = y1 ./ sqrt(mean(y1.^2)); % normalization in RMS power of the vocoded speech stimulus

%%%%%%%%%%%%% Applied the noise %%%%%%%%%%
rms_db=12; % SNR +12 dB
rms_scale=10^(rms_db/20);
rms_noise=sqrt(mean(noise.^2)); rms_signal=sqrt(mean(y1.^2)); %RMS level for noise and for speech
pknoise=((1/rms_scale).*rms_signal.*noise./rms_noise); % normalization of the noise + application of the SNR re: to the RMS of the speech

y1=y1 + pknoise; % addition of the high-pass filtered SSN noise masker at an SNR of +12 dB
y = y1 ./ sqrt(mean(y1.^2)); % normalization in RMS power of the vocoded speech stimulus


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