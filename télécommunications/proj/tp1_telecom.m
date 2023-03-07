% PARTIE 1
clc;
clear all;
close all;


% modulateur 1

n=1;

Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 10000;
Ns = floor(Ts/Te);

bits_non_map = randi([0, 1], 1, Nbits); %Nbits
bits_non_map2 = randi([0, 1], 1, 15*Nbits);

signal_1 = 2*bits_non_map - ones(1, length(bits_non_map));
signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);
f = linspace(-Te/2, Te/2, Ns);
h_2 = ones(1, Ns); 


figure;
plot(signal_1_map)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal aléatoire")

figure;
%x=filter(signal_1, 1, ones(1,Ns));
x=filter(h_2,1 , signal_1_map);
t = 0:Te:(length(x)-1)*Te;
plot(t, x)
title("(1) Signal filtré")

figure;

dsp_1 = fftshift(pwelch(x, [], [], [], Fe, 'twosided'));
f=linspace(-Fe/2, Fe/2, length(dsp_1));
%semilogy(f, dsp_1)
%xlabel("fréquence [Hz]")
%ylabel("Densité spectrale de puissance")
%title("(1) Densité spectrale de puissance théorique")




% modulateur 2

n=2;
Ts = n*Tb;
Ns = floor(Ts/Te);

signal_2 = reshape(bits_non_map2, 2, [])';%bit_non_map, 2, []
signal_2_kron = (2*bi2de(signal_2)-3)';
%signal_2_kron = kron(signal_2_map, [1 zeros(1, Ns-1)]);

figure(666);
t = 0:Te:(length(signal_2_kron)-1)*Te;
plot(t,signal_2_kron)
xlabel("temps [s]")
ylabel("amplitude")
title("(2) Signal")
axis([0 0.02 -3.3 3.5])

h_2 = ones(1, Ns);
figure(111);
x=filter(h_2, 1, signal_2_kron);
t = 0:Te:(length(x)-1)*Te;
plot(t, x)
title("(2) Signal filtré")

figure; 
dsp_2 = fftshift(pwelch(x, [], [], [], Fe, 'twosided'));
f=linspace(-Fe/2, Fe/2, length(dsp_2));
%semilogy(f, dsp_2)
x%label("fréquence [Hz]")
%ylabel("Densité spectrale de puissance")
%title("(2) Densité spectrale de puissance théorique")



%modulateur 3
n=1; % # bits / symbole
Ts = n*Tb;
Ns = floor(Ts/Te);

bits_non_map = randi([0, 1], 1, Nbits);

signal_1 = 2*bits_non_map - 1;

signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);

figure(99);
t = 0:Te:(length(signal_1_map)-1)*Te;
plot(t, signal_1_map)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal aléatoire")

alpha = 0.5;
L = 20;
h_3 = rcosdesign(alpha,L ,Ns);

x = filter(h_3, 1, signal_1_map);
t = 0:Te:(length(x)-1)*Te;

figure (110)
plot(h_3);

figure (100) ;
plot(t, x)
title("signal 3 filtré")
axis([0 0.02 -3.3 3.5])

dsp_3 = fftshift(pwelch(x, [], [], [], Fe, 'twosided'));
f=linspace(-Fe/2, Fe/2, length(dsp_3));
%semilogy(f, dsp_3)
%xlabel("fréquence [Hz]")
%ylabel("Densité spectrale de puissance")
%title("(3) Densité spectrale de puissance théorique")

hold on;
figure(500)
semilogy(f, dsp_1, f, dsp_2, f, dsp_3)
%semilogy(f, dsp_2)
%semilogy(f, dsp_3)

