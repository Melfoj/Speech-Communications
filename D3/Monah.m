clear all, close all, clc

%% Ucitavanje signala
[x,fs] = audioread('recenica.wav');
f0 = load('f0_recenica.mat');
f0 = f0.f0;

%% Parametri i konstante
t_step = 30*10^-3;
cross = 2;
samp = fix(t_step*fs);
R = 0.5*samp; %Prozor za f0 (zbog preklapanja prozora)

%% Obrada
e = [];
gen_sig = [];
ctrl = 0;
loc = 0;

for i = 1:length(f0)
    pobuda=zeros(1,R);
  if loc>R
      loc=loc-R;
  else
    if isnan(f0(i))
      if i>1
        if isnan(f0(i-1))
          pobuda=0.01*randn(1,R);
        else
          pobuda(loc)=1;
          pobuda((loc+1):R)=0.01*randn(1,R-loc);
        end
      else
        pobuda=0.01*randn(1,R);
      end
    else
        if i>1
            if isnan(f0(i-1))
                pobuda(1:fix(fs/f0(i)):R)=1;
                loc= fix(fs/f0(i) - R + find(pobuda, 1, 'last'));
            else
                pobuda(loc:fix(fs/f0(i)):R)=1;
                loc= fix(fs/f0(i) - R + find(pobuda, 1, 'last'));
            end
        else
            pobuda(loc:fix(fs/f0(i)):R)=1;
            loc= fix(fs/f0(i) - R + find(pobuda, 1, 'last'));
        end
    end
  end
    e=[e pobuda];
end

e_osa = 0:length(e)-1;
figure, plot(e_osa,e);

%% Drugi deo obrade

s_kraj = [];
for i = 1:(samp/cross):length(x)-samp
   y = x(i:i+samp-1);
   
   yw = y.*hamming(samp); %Mnozenje Hamingom zbog uklapanja na spojevima
   
   p = 20;
   [A, G] = autolpc(yw, p); %Racunanje LPC koeficijenata
   
   Gain = G/(sqrt(sum(e(i:i+R-1).^2))+0.01); 
   s(i:i+R-1) = filter(Gain, A, e(i:i+R-1));
   s_kraj = [s_kraj s(i:i+R-1)]; %Kraj
   
end

s_osa = 0:length(s_kraj)-1;
t_osa = 0:length(x)-1;
figure, plot(s_osa, s_kraj, t_osa, x);


player = audioplayer (s_kraj, fs, 8);
play (player);