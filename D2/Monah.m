clc; clear all; close all;
%% Ucitavanje signala
[x,fs] = audioread('Audio\recenica22.wav');

%% Obrada

%Normalizacija signala, uklanjanje DC komponente i plot
x = x./max(abs(x));
x = x - mean(x);
t = (0:length(x)-1)*(1/fs);
%figure, plot(t, x, 'b'), ylim([-1.1 1.1])

%Parametri i konstante
p0 = 2*10^-5;
t_step = 30*10^-3;
samp = fix(t_step*fs);

RMS = [];
ZCR = [];
H_L = [];
f0 = [];
    
%Preklapanje i pragovi
cross = 2;
tau = 10*10^-3;
thRMS = 73; %73
thZCR = 63*3; %Slovo A:{2.291, 2.569}, Š:{0.065, 2.428} sekunde! %63

%Filter 80-600Hz
wn1=100/(fs/2);
wn2=600/(fs/2);
M=50;
N=2*M;
h=fir1(N, [wn1 wn2], rectwin(N+1));
[H,omega]=freqz(h,1,1000);

%Y = fft(y);
%f_osa = 0:length(Y)-1;
%y1 = filter(h, 1, y);
%Y1 = fft(y1);

figure,plot((omega/pi)*(fs/2),20*log10(abs(H))), xlim([0 1000])
%figure, stem(f_osa, [abs(Y1) abs(Y)])

for i = 1:(samp/cross):length(x)-samp
   y = x(i:i+samp-1);
   RMS(end+1) = 20*log10(rms(y)/p0);
   ZCR(end+1) = zcr(y)*tau*fs; 
   
   if RMS(end) >= thRMS && ZCR(end) <= thZCR
      H_L(end+1) = 1;
      
      %Autokorelacija i odredjivanje f0
      y1 = filter(h, 1, y);
      cy = xcorr(y1);
      [pks, locs] = findpeaks(cy, 'MinPeakDistance', 200);
      pmax = find(pks == max(pks));
      f0(end+1) = 1/((locs(pmax)-locs(pmax-1))*(t_step/samp));
      
      %corr_osa = 0:length(cy)-1;
      %figure, plot(cy, 'b'); hold on
      %stem(locs, pks, 'r')

   else
      H_L(end+1) = 0;
      f0(end+1) = 0;
   end
   
end

%Korekcija vremena u odnosu na preklapanje prozora
t_norm = t_step/cross;
t_osa = (0:length(RMS)-t_norm)*t_norm;
%figure, plot(t_osa, RMS);

%Plot RMS i signala zajedno
RMS1 = RMS/max(abs(RMS));
%figure, plot(t_osa, RMS1, 'g', t, x, 'b'), ylim([-1.1 1.1]);

%Plot H_L, RMS i signala zajedno
f01 = f0/max(abs(f0));
figure, plot(t_osa, H_L, 'r', t, x, 'b', t_osa, RMS1, 'g', t_osa, f01, 'black'), 
%xlim([0 0.005]),
ylim([-1.1 1.1]);

%% Plot pikova
corr_osa = 0:length(cy)-1;
figure, plot(cy, 'b'); hold on
stem(locs, pks, 'r')

%% ZCR funkcija
function zcr = zcr(x)
    zcr = 0;
        
    for i = 1:length(x)-1
        zcr = zcr + abs(sign(x(i))-sign(x(i+1)));
    end
    zcr = zcr/(2*length(x));
end