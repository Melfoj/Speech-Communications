clear all, close all, clc

%ucitavanje i sredjivanje signala
[x, fs] = audioread('recenica 22.wav');
f0 = load('f0_recenica 22.mat');
f0 = f0.f0;
DC=mean(x);
x=x-DC;%jednosmerna komponenta
n=max(abs(x));
x=x./n;%usrednjavanje

T=1/fs;
L = rms(x);
p0 = 2*10^-5;
L = 20*log10(L/p0);
t = 0.03;

%filtar
wn1=80/(fs/2);
wn2=300/(fs/2);
M=50;
N=2*M;
h=fir1(N, [wn1 wn2], rectwin(N+1));

R=fix(t*fs)/2;
kikoman=[];
izl = [];
loc=1;

for i = 1:length(f0)
    pobuda=zeros(1,R);
  if loc>R
      while loc>R
        kikoman=[kikoman zeros(1,R)];
        loc=loc-R;
        i=i+1;
      end
      pp=zeros(1,loc-1);
      pp(end+1)=1;
      pom=0.01*randn(1,R-loc);
      pobuda=[pp pom];
  else
    if isnan(f0(i))
      if i>1
        if isnan(f0(i-1))
          pobuda=0.01*randn(1,R);
        else
          pp=zeros(1,loc-1);
          pp(end+1)=1;
          pom=0.01*randn(1,R-loc);
          pobuda=[pp pom];
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
  kikoman=[kikoman pobuda];
end

for i = 1:R:length(x)-2*R
   y = x(i:i+2*R-1);
   
   ham = y.*hamming(2*R);
   
   p = 50;
   [A, G] = autolpc(ham, p);
   
   Gain = G/(sqrt(sum(kikoman(i:i+R-1).^2))+0.01); 
   med(i:i+R-1) = filter(Gain, A, kikoman(i:i+R-1));
   izl = [izl med(i:i+R-1)];
   
end

r = 0:t/2:(length(f0)-1)*t/2;
io = 0:T:(length(izl)-1)*T;
op= T:T:length(x)*T;

%iscrtavanje
figure,plot(kikoman);
figure, plot(io, izl, op, x);

player = audioplayer (izl, fs, 16);
play (player);