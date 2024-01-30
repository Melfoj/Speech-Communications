clear all; close all; clc;

Tw=30;           % duzina prozora (ms)
Ts=15;           % preklapanje (ms)
alpha=0.97;      % preemphasis koeficijent
R=[300 3700 ];  % frekvencijski opseg
M=30;            % broj filtara u banci
C=12;            % broj kepstralnih koeficijenata
L=22;            % cepstral sine lifter parametar

% Hamingov prozor
hamming=@(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

% Ucitavanje signala
[speech,fs]=wavread('a.wav');
speech=speech/max(abs(speech));

% Izracunavanje MFCC koeficijenata (obelezja se nalaze po kolonama)
[MFCCs,FBEs,frames]=mfcc(speech, fs, Tw, Ts, alpha, hamming, R, M, C, L );

% Crtanje MFCC matrice
figure, imagesc(MFCCs);
axis('xy');
xlabel('Redni broj prozora', 'FontSize', 11);
ylabel('MFCC koeficijent', 'FontSize', 11);

% "Prepakivanje" MFCC matrice i crtanje MFCC niza
MFCC_vektor=reshape(MFCCs,1,size(MFCCs,1)*size(MFCCs,2));
figure, plot(MFCC_vektor);
