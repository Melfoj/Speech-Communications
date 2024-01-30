clear all, close all, clc

%% Ucitt

bp = 20;
MFCCm = [];

%% MB

i1 = 5;
i2 = 40;
for br1 = 1:i1
    for br2 = i2-4:i2
        filename = sprintf('Mala_baza/broj_%d_%d.wav', br1, br2);
        [sig fs] = audioread(filename);
        Tw = (length(sig)*1000)/(bp*fs);
        MFCCv = emefefce(Tw, sig, fs);
        MFCCm = [MFCCm; MFCCv];
    end
end

MFCCc = [];
Ist = [];

for i = 1:25
    for j = 1:25
        d = norm(MFCCm(i,:)-MFCCm(j,:));
        MFCCc(i,j) = d;
        if d<215
            Ist(i,j) = 1;
        else
            Ist(i,j) = 0;
        end
    end
end

%% Uspeh
Succ = zeros(1,round(max(MFCCc,[],'all')));

for k = 1:round(max(MFCCc,[],'all'))
    for i = 1:5*5
        for j = 1:5*5
            d = norm(MFCCm(i,:)-MFCCm(j,:));
            MFCCc(i,j) = d;
            if d<k
                Succ(k) = Succ(k) + 1;
            end
        end
    end
end

Succ = Succ/625;
figure(1), plot(1-Succ);

figure(2), surf(MFCCc, 'EdgeColor','none'), colorbar, view(2), colormap jet;

figure(3), surf(Ist, 'EdgeColor','none'), colorbar, view(2), colormap jet;

%% VB

i1 = 5;
i2 = 125;
i12=i1*i2;
for br1 = 1:i1
    for br2 = 1:i2
        filename = sprintf('Velika_baza/broj_%d_%d.wav', br1, br2);
        [sig fs] = audioread(filename);
        Tw = (length(sig)*1000)/(bp*fs);
        MFCCv = emefefce(Tw, sig, fs);
        MFCCm = [MFCCm; MFCCv];
    end
end

MFCCc = [];
Ist = [];

for i = 1:i12
    for j = 1:i12
        d = norm(MFCCm(i,:)-MFCCm(j,:));
        MFCCc(i,j) = d;
        if d<220
            Ist(i,j) = 1;
        else
            Ist(i,j) = 0;
        end
    end
end

%% Uspeh
Succ = zeros(1,round(max(MFCCc,[],'all')));

for k = 1:round(max(MFCCc,[],'all'))
    for i = 1:i12
        for j = 1:i12
            d = norm(MFCCm(i,:)-MFCCm(j,:));
            MFCCc(i,j) = d;
            if d<k
                Succ(k) = Succ(k) + 1;
            end
        end
    end
end

Succ = Succ/(i12*i12);
figure(4), plot(1-Succ);

figure(5), surf(MFCCc,'EdgeColor','none'), colorbar, view(2), colormap jet;

figure(6), surf(Ist, 'EdgeColor','none'), colorbar, view(2), colormap jet;

%% MFCC
function MFFCv = emefefce(Tw, speech, fs)


    Ts=Tw/2;        % preklapanje (ms)
    alpha=0.97;     % preemphasis koeficijent
    R=[300 3700];   %frekvencijski opseg
    M=30;           % broj filtara u banci
    C=12;           % broj kepstralnih koeficijenata
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
    MFFCv = reshape(MFCCs,1,size(MFCCs,1)*size(MFCCs,2));

end