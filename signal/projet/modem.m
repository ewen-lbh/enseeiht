clear all;
close all;

Fe = 48000;
Te = 1/Fe;
Ts = 1/300; % 1 / débit en bits/sec
Ns = floor(Ts/Te);
Nbits = 10;
phi0=rand*2*pi;
phi1=rand*2*pi;
layout = tiledlayout(3, 3)

% 3.1.1

bits = randi([0, 1], 1, Nbits);
nrz = kron(bits, ones(1, Ns));

% 3.1.2

nexttile(layout)
plot(nrz)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal NRZ aléatoire")

% 3.1.3


nexttile(layout)
dsp = pwelch(nrz, [], [], [], Fe, 'twosided');
f=linspace(-Fe/2, Fe/2, length(dsp));
semilogy(f, fftshift(dsp))
xlabel("fréquence [Hz]")
ylabel("Densité spectrale de puissance")
title("Densité spectrale de puissance")

% 3.1.4

hold on;

dsp2 = 0.25*Ts*(sinc(f*Ts).^2);
dsp2(find(f==0)) = dsp2(find(f==0)) + 0.25
semilogy(f, dsp2, 'r')
legend("Pratique", "Théorique")

% 3.2.1
nexttile(layout)
t=0:Te:(Nbits*Ns-1)*Te;
size(t)
size(nrz)
frequence_0 = 6000; % 1180;
frequence_1 = 2000; % 980;
module = nrz .* cos(2*pi*frequence_1*t+phi1) + (1-nrz) .* cos(2*pi*frequence_0*t+phi0);
size(module)

% 3.2.2

plot(t, module);
xlabel("Temps [s]")
ylabel("Amplitude")
title("NRZ modulé en fréquence")

nexttile(layout)

% 3.2.3

dsp4=abs(fftshift(fft(module))).^2;
f=linspace(-Fe/2, Fe/2, length(dsp4));
semilogy(f, dsp4)
xlabel("Fréquence [Hz]")
ylabel("Amplitude")
title("Densité spectrale de puissance")


hold on;

% 3.2.4
dsp3=fftshift(pwelch(module, [], [], [], Fe, 'twosided'));
f=linspace(-Fe/2, Fe/2, length(dsp3));
semilogy(f, dsp3)
legend("Théorique", "Expérimentale")

% 4
nexttile(layout)
snr = 200;
puissance_module = mean(abs(module).^2);
sigma = sqrt(puissance_module/10^(snr/10));
bruit = sigma * randn(1, length(module));
module_bruite = module + bruit;
plot(module_bruite)
xlabel("Temps [s]")
ylabel("Amplitude")
title("Signal bruité")

% 5
f = linspace(-Fe/2, Fe/2, length(module_bruite));
ordre_2 = 61
t_ordre_2 = -(ordre_2 - 1) / 2 * Te : Te : (ordre_2 - 1)/2 * Te
fc = (frequence_0 + frequence_1) / 2
% Attention, h doit être exprimé en fréquences normalisées
% A l'intérieur du sinc c'est bon car tu fais apparaitre Te=1/Fe dans t_ordre_2
% Mais pour le module de h ce n'est pas bon (d'ailleurs h est sensé être
% adimensionnel et dans ton cas il est exprimé en Hz)

fc2=fc

h_haut = 2 * (fc2 / Fe) * sinc(2 * fc2 * t_ordre_2)
H_haut = fft(h_haut, 4096)

h_bas = -h_haut
h_bas(find(t_ordre_2==0)) = h_bas(find(t_ordre_2==0)) + 1

recu_1 = filter(h_haut, 1, module_bruite)
recu_0 = filter(h_bas, 1, module_bruite)

nexttile(layout)
hold on
plot(recu_1)
plot(recu_0)
xlabel("Temps [s]")
ylabel("Amplitude")
title("Signal démodulé")
legend("1", "0")


%5-4
%Signal modulé en fréquence
%densité spectrale puissance

nexttile(layout)
dsp2=fft(autocorr(nrz));
plot(dsp2);
hold on;