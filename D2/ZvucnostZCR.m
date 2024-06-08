clear all, close all, clc
%% Promenljive
%ucitavanje i sredjivanje signala
[x,fs] = audioread('Audio\recenica22.wav');

DC=mean(x);
x=x-DC;%jednosmerna komponenta
n=max(abs(x));
x=x./n;%usrednjavanje

T=1/fs;
op= T:T:length(x)*T;
P=mean(x.^2);
L = rms(x);
p0 = 2*10^-5;
L = 20*log10(L/p0);
t = 0.03;
a = round(t*fs);  

%pragovi
Pe=66;%66
Pzcr=77;%77

%nizovi
RMS = [];
ZCR=[];
Z=[];
f0=[];

%filtar
wn1=80/(fs/2);
wn2=600/(fs/2);
M=50;
N=2*M;
h=fir1(N, [wn1 wn2], rectwin(N+1));

%% Popunjavanje nizova
for i = 1:(a/2):length(x)-a
   y = x(i:i+a -1);
   RMS(end+1) = 20*log10(rms(y)/p0);
   ZCR(end+1) = zcr(y);
   if ZCR(end)<=Pzcr && RMS(end)>=Pe
      Z(end+1)=1;
      y1 = filter(h, 1, y);
      %[p, loc] = findpeaks(xcorr(y1), "DoubleSided");
      [p, loc] = findpeaks(xcorr(y1), 'MinPeakDistance', 200);
      pmax = find(p == max(p));
      f0(end+1) = fs/(2*(loc(pmax)-loc(pmax-1)));
   else
      Z(end+1)=0;
      f0(end+1)=0;
   end
end

r = 0:t/2:(length(RMS)-1)*t/2;
%% Iscrtavanje
figure, plot(op,x,r,RMS/max(RMS),r,Z/max(Z),r,ZCR/max(ZCR))
title("RMS,ZCR,Zvucnost")
figure, plot(r, RMS)
title("RMS")
figure, plot(r, ZCR)
title("ZCR")
figure, plot(op, x, r, Z)
ylim([-1.1 1.1])
title("Zvucnost")
figure,plot(r, f0)
title("f0")

%% Racunanje ZCR
function z=zcr(x)
  z=0;
    for i=1:length(x)-1
      z=z+abs(sign(x(i))-sign(x(i+1)))/2;
    end
end