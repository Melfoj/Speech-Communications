clear all, close all, clc

%% Ucitavanje fajlova

C = 12;
frame_count = 20;
MFCC_matrix = [];

%% Mala baza

a = 5;
b = 40;
for br1 = 1:a
    for br2 = b-4:b
        file_name = sprintf('Mala_baza/broj_%d_%d.wav', br1, br2);
        [y fs] = audioread(file_name);
        Tw = (length(y)*1000)/(frame_count*fs);
        MFCC_vector = probamfcc(Tw, C, y, fs);
        MFCC_matrix = [MFCC_matrix; MFCC_vector];
    end
end

MFCC_compare = [];
Threshold = [];

for i = 1:5*5
    for j = 1:5*5
        d = norm(MFCC_matrix(i,:)-MFCC_matrix(j,:));
        MFCC_compare(i,j) = d;
        if d<185
            Threshold(i,j) = 1;
        else
            Threshold(i,j) = 0;
        end
    end
end

%Zavisnost uspeha od praga
Success_rate = zeros(1,round(max(MFCC_compare,[],'all')));

for k = 1:round(max(MFCC_compare,[],'all'))
    for i = 1:5*5
        for j = 1:5*5
            d = norm(MFCC_matrix(i,:)-MFCC_matrix(j,:));
            MFCC_compare(i,j) = d;
            if d<k
                Success_rate(k) = Success_rate(k) + 1;
            end
        end
    end
end

Success_rate = Success_rate/625;
figure(1), plot(1-Success_rate);

figure(2), surf(MFCC_compare, 'EdgeColor','none'), colorbar, view(2), colormap jet;

figure(3), surf(Threshold, 'EdgeColor','none'), colorbar, view(2), colormap jet;
%% Velika baza 

a = 5;
b = 125;
for br1 = 1:a
    for br2 = 1:b
        file_name = sprintf('Velika_baza/broj_%d_%d.wav', br1, br2);
        [y fs] = audioread(file_name);
        Tw = (length(y)*1000)/(frame_count*fs);
        MFCC_vector = probamfcc(Tw, C, y, fs);
        MFCC_matrix = [MFCC_matrix; MFCC_vector];
    end
end

MFCC_compare = [];
Threshold = [];

for i = 1:a*b
    for j = 1:a*b
        d = norm(MFCC_matrix(i,:)-MFCC_matrix(j,:));
        MFCC_compare(i,j) = d;
        if d<202
            Threshold(i,j) = 1;
        else
            Threshold(i,j) = 0;
        end
    end
end

%Zavisnost uspeha od praga
Success_rate = zeros(1,round(max(MFCC_compare,[],'all')));

for k = 1:round(max(MFCC_compare,[],'all'))
    for i = 1:5*5
        for j = 1:5*5
            d = norm(MFCC_matrix(i,:)-MFCC_matrix(j,:));
            MFCC_compare(i,j) = d;
            if d<k
                Success_rate(k) = Success_rate(k) + 1;
            end
        end
    end
end

Success_rate = Success_rate/(a*b);
figure(4), plot(1-Success_rate);

figure(5), surf(MFCC_compare,'EdgeColor','none'), colorbar, view(2), colormap jet;

figure(6), surf(Threshold, 'EdgeColor','none'), colorbar, view(2), colormap jet;

%% MFCC Funkcija
function MFCC_vektor = probamfcc(Tw, C, speech, fs)


    Tw;             % duzina prozora (ms)
    Ts=Tw/2;        % preklapanje (ms)
    alpha=0.97;     % preemphasis koeficijent
    R=[300 3700];   %frekvencijski opseg
    M=30;           % broj filtara u banci
    C;              % broj kepstralnih koeficijenata
    L=22;           % cepstral sine lifter parametar

    % Hamingov prozor
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

    % Izracunavanje MFCC koeficijenata (obelezja se nalaze po kolonama)
    [MFCCs,FBEs,frames] = mfcc(speech, fs, Tw, Ts, alpha, hamming, R, M, C, L);
    [m,n] = size(MFCCs);
    if n == 38
        MFCCs(:,n+1) = [mean(MFCCs.').'];
    end
     
    % "Prepakivanje" MFCC matrice
    MFCC_vektor = reshape(MFCCs,1,size(MFCCs,1)*size(MFCCs,2));

end