pkg load signal
pkg load statistics
[x, fs] = audioread('sinusoida.wav');
T=1/fs;
op= T:T:length(x)*T;
a = round(0.03*fs);
for i = 1:(a/2):length(x)-a
   y = x(i:i+a -1);
   cor=xcorr(y);
   %[p, loc] = findpeaks(cor);
end
figure, plot(cor)