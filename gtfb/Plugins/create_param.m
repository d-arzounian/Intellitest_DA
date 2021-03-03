function create_param(nbch,wide)

Param.Fs = 44100;
Param.nbch=nbch;

[FMIN,ENLARGE]=enlarge(80,wide);

[Param.a1,Param.fc1,Param.fb1,Param.deltan1,Param.deltamax1,Param.phi1,Param.mix1]=gammabank(FMIN,nbch,wide,ENLARGE,Param.Fs);
Param.Num=2*(1-abs(Param.a1)).^4;
for k=1:nbch,
    Param.Den(k,:)=poly([Param.a1(k) Param.a1(k) Param.a1(k) Param.a1(k)]);
end

[Param.a321,Param.fc321,Param.fb321,Param.deltan321,Param.deltamax321,Param.phi321,Param.mix321]=gammabank(80,32,1,1,Param.Fs);
Param.Num321=2*(1-abs(Param.a321)).^4;
for k=1:32,
    Param.Den321(k,:)=poly([Param.a321(k) Param.a321(k) Param.a321(k) Param.a321(k)]);
end

[Param.a322,Param.fc322,Param.fb322,Param.deltan322,Param.deltamax322,Param.phi322,Param.mix322]=gammabank(80,32,1,2,Param.Fs);
Param.Num322=2*(1-abs(Param.a322)).^4;
for k=1:32,
    Param.Den322(k,:)=poly([Param.a322(k) Param.a322(k) Param.a322(k) Param.a322(k)]);
end

[Param.a324,Param.fc324,Param.fb324,Param.deltan324,Param.deltamax324,Param.phi324,Param.mix324]=gammabank(80,32,1,4,Param.Fs);
Param.Num324=2*(1-abs(Param.a324)).^4;
for k=1:32,
    Param.Den324(k,:)=poly([Param.a324(k) Param.a324(k) Param.a324(k) Param.a324(k)]);
end

[Param.Benv,Param.Aenv]=butter(6,64*2/Param.Fs);

save filterparam.mat -struct Param;


%*******

function [a,fc,fb,deltan,deltamax,phi,mix]=gammabank(fmin,nbch,ERBpas,fbenlarge,fs)


%%% paramètres d'analyse
q=9.265;
l=24.7;
d=0.016;

erbscale=q*log(1+fmin/(l*q));

q3db=(2*sqrt(2^(1/4)-1))/((720*pi*2^(-6))/36);
q3db=q3db*fbenlarge;

for m=1:nbch,
    fc(m)=(exp((erbscale+(m-1)*ERBpas)/q)-1)*l*q;
    erb=l+fc(m)/q;
    fb(m)=q3db*erb;
    a(m)=acalcul(fc(m),fb(m),fs);
end

%%% paramètres de synthèse
samples=4096;

indmax=floor(d*fs) + 1;
t=0:samples-1;
for n=1:nbch,
    k(n,:)=((a(n).^t)/6).*(t.^3 + 6*t.^2 + 11*t +6).*2*(1-abs(a(n))).^4;
end

[mx,ind]=max(abs(k),[],2);

t=ind'.*(ind'<indmax);
t=t + indmax.*(t==0);
deltan=indmax*ones(1,nbch) - t;
t=t./fs;
phi=-2*pi.*fc.*(t);

deltamax=max(deltan);


for m=1:nbch, 
    ri(m,:)=real(k(m,:).*exp(i*phi(m))); 
    ri(m,:)=[zeros(1,deltan(m)) ri(m,1:samples-deltan(m))];
end

re_sp=fft(real(ri.'));
mix=ones(nbch,1);
si=fc.*samples./fs;
sesp=re_sp(round(si),:);

for m=1:10,
    sesp2=sesp*mix; mix=mix./abs(sesp2); 
end


%%%sous fonction
function a=acalcul(fc,fb,fs)

beta=2*pi*fc/fs;
phi=2*pi*(fb/2)/fs;
u=-3/4;
p=(-2+2*10^(u/10)*cos(phi))/(1-10^(u/10));
lambda=-p/2-sqrt((p^2)/4-1);
a=lambda*exp(i*beta);



%%%%%%%%%%%%%%

function y=gammafilter(x,den,num,nbch)

for n=1:nbch,
    y(n,:)=filter(num(n),den(n,:),x);
end


%%%%%%%%%%%%%%


function y=gammasynth(deltan,deltamax,phi,mix,x)

nbch=length(phi);

for n=1:nbch,
    x2(n,:) = cos(phi(n))*real(x(n,:)) - sin(phi(n))*imag(x(n,:));
    x3(n,:) = [zeros(1,deltan(n)) x2(n,:) zeros(1,deltamax-deltan(n))];
end

y=(x3'*mix)';

%%%%%%%%%%%%%%

function [fc,Xfb]=enlarge(fmin,F)


l=24.7;
q=9.265;
K=(2*sqrt(2^(1/4)-1))/((720*pi*2^(-6))/36);

fc=0.5*(((1+fmin/(l*q))*exp((F-1)/q)-1)*l*q*(1+K/(2*q))+fmin*(1-K/(2*q)));
Xfb=-(fmin-K/2*(l+fmin/q)-fc)/(K/2*(l+fc/q));