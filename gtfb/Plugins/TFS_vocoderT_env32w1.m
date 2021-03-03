function y=TFS_vocoderT_env32w1(x)

load filterparam.mat

[bhp,ahp]=butter(12,(fc1(3)+fb1(3)/2)/(Fs/2),'high');

%threshold=0.01;

x_bdf=gammafilter(x,Den,Num,nbch);
x_bdf=gammasynth_m(deltan1,deltamax1,phi1,mix1,x_bdf);

bandw=32/nbch;

cd ..
cd Bruits
noise = wavread('SSN_V.wav');
cd ..
cd Plugins

d=round(10000*rand(1,1));
noise = noise(d:d+length(x_bdf)-1);%2*rand(1,length(x_bdf))-1;%

noise = filter(bhp,ahp,noise);
noise = noise ./ sqrt(mean(noise.^2));
x_bdf(nbch,:) = noise .* 10^(-12/20);

env=zeros(nbch,length(x_bdf));

for k=1:nbch-1,
    %tmp=filtfilt(Benv,Aenv,abs(x_bdf(k,:)));
    [Benv,Aenv]=butter(4,(fb1(k)/bandw)/44100);
    tmp=filter(Benv,Aenv,x_bdf(k,:).*(x_bdf(k,:)>0));
    
    rms=20*log10(sqrt(mean(tmp.^2)));
    threshold=10^((rms-20)/20);
    env(k,:)=1.*(abs(tmp)>threshold);
    [Benv,Aenv]=butter(1,(fb1(k)/bandw)/44100);
    env(k,:)=filter(Benv,Aenv,env(k,:));
    x_bdf(k,:)=env(k,:).*cos(angle(x_bdf(k,:)));%./rms;
    %x_bdf(k,:)=env(k,:).*sin(2*pi*fc1(k).*t./Fs + rand(1)*2*pi);
end

y1=sum(x_bdf(1:nbch-1,:),1);
y1 = y1 ./ sqrt(mean(y1.^2));
y=y1 + x_bdf(nbch,:);
y = y ./ sqrt(mean(y.^2));

%%%vocoder 32
x_bdf=gammafilter(y,Den321,Num321,32);
x_bdf=real(gammasynth_m(deltan321,deltamax321,phi321,mix321,x_bdf));
t=1:length(x_bdf);

for k=1:32,
    rms=sqrt(mean(x_bdf(k,:).^2));
    [Benv,Aenv]=butter(4,fb321(k)/44100);      % Low pass filtering @ERB/2
    x_bdf(k,:)=filter(Benv,Aenv,x_bdf(k,:).*(x_bdf(k,:)>0));
    x_bdf(k,:)=x_bdf(k,:).*sin(2*pi*fc321(k).*t./Fs + rand(1)*2*pi)./rms;
end

y=sum(x_bdf,1);
y = y ./ sqrt(mean(y.^2));


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