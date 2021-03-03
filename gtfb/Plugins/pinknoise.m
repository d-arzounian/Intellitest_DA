function [noise] = pinknoise(TPts,lco,hco);

% lco : low cutoff freq in Hz
% hco : high cutoff freq in Hz 
% TPtf : Duration (in sec) * fs (in Hz)

% usage, écrire: x=pinknoise(4*44100,10,10000); % génére et sauve en fichier 'pinknoise.wav' un bruit rose de 10 à 10000Hz, d'une durée de 4 secondes

fs = 44100;

bandwidth = hco - lco;
fftpts = pow2(nextpow2(TPts));
binfactor = fftpts / fs;
LPbin = round(lco*binfactor) + 1;
HPbin = round(hco*binfactor) + 1;
pink_weight = [1:fftpts] .* binfactor;
a = zeros(1,fftpts);
b = a;
a(LPbin:HPbin) = randn(1,HPbin-LPbin+1);
b(LPbin:HPbin) = randn(1,HPbin-LPbin+1);
fspec = a + i*b;
pspec = fspec ./ sqrt(pink_weight);
noise = ifft(pspec);
noise = real(noise(1:TPts));

rms_noise=sqrt(mean(noise.^2)); 
noise=(noise./rms_noise)/10; % normalization in rms power

%soundsc(noise);
%wavwrite(noise,fs,'pinknoise.wav'); % save file