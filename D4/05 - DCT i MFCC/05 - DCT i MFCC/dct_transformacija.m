clear all; close all; clc;

[g fs]=wavread('recenica.wav');
g=g/max(abs(g));
t=(0:length(g)-1)/fs;
figure, plot(t,g)
% title('Originalni signal','FontSize',14)
xlabel('Vreme (s)','FontSize',11)
ylabel('Amplituda','FontSize',11)
ylim([-1 1])

% DFT transformacija
X=fft(g);
f=(0:length(X)-1)/length(X)*fs;
figure, plot(f,20*log10(abs(X)))
% title('DFT transformacija','FontSize',11)
xlabel('Frekvencija (Hz)','FontSize',11)

% DCT transformacija 
G=dct(g);
N=length(g);
% figure, plot(G)
% title('DCT transformacija','FontSize',12)
figure, plot(20*log10(abs(G)))
ylabel('Amplituda [dB]','FontSize',11)
% title('DCT transformacija','FontSize',12)

gcos=idct([G(1:round(N/4))' zeros(1,N-round(N/4))]);
figure, plot(t,gcos/max(abs(gcos)))
% title('Rekonstruisani signal','FontSize',14)
xlabel('Vreme (s)','FontSize',11)
ylabel('Amplituda','FontSize',11)
ylim([-1 1])