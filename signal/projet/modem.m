clear all;
close all;

Fe = 48000;
Te = 1/Fe;
Ts = 1/300; % 1 / débit en bits/sec
Ns = floor(Ts/Te);
Nbits = 100;
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

% Attention, la définition Matlab de sinc prend déjà en compte pi. Voir section "More about" de https://fr.mathworks.com/help/signal/ref/sinc.html
% De plus la fonction dirac de matlab est la fonction 'continue' (donc vaut inf en 0), il ne faut donc pas l'utiliser de cette façon.
% Pour dirac tu peux faire quelque chose comme :
% dsp2(find(f==0)) = dsp2(find(f==0)) + 1
% ce qui change uniquement la valeur de dsp2 où f==0
dsp2=0.25*Ts*(sinc(pi*f*Ts).^2)+0.25*dirac(f);
semilogy(f, dsp2, 'r')
legend("Pratique", "Théorique")

% 3.2.1
nexttile(layout)
% t est mal défini : Tu commences à 1s, et tu termines à Nbits*Ts=100*0.003333=0.3333 secondes
% Il faut changer les bornes du linspace (attention à bien avoir des points
% tous les Te) ou alors définir simplement t comme t=0:Te:(Nbits*Ns-1)*Te
t = linspace(1, Nbits*Ts, Nbits*Ns);
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

dsp4=abs(fft(module)).^2;
f=linspace(-Fe/2, Fe/2, length(dsp4));
% Attention, fft calcule la transformée de Fourier entre 0 et Fe, 
% pas -Fe/2 et Fe/2
semilogy(f, dsp4)
xlabel("Fréquence [Hz]")
ylabel("Amplitude")
title("Densité spectrale de puissance")


hold on;

% 3.2.4
dsp3=pwelch(module, [], [], [], Fe, 'twosided');
f=linspace(-Fe/2, Fe/2, length(dsp3));
% Attention, welch calcule la transformée de Fourier entre 0 et Fe, 
% pas -Fe/2 et Fe/2
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
h = 2 * fc * sinc(2 * fc * t_ordre_2)
H = fft(h, 4096)

% recu_1 = lowpass(module_bruite, (fc + 20)/Fe)
recu_1 = filter(h, 1, module_bruite)
%recu_0 = 

%b0 = 2*pi*(frequence_1+tolerance)/Fe
%recu_1 = filter(b0, [1 1-b0], module_bruite)

% recu_0 = abs(ifft(fftshift(fft(module_bruite)) .* (f > frequence_0 - tolerance)));
% recu_1 = abs(ifft(fftshift(fft(module_bruite)) .* (f < frequence_1 + tolerance)));
nexttile(layout)
%plot(recu_1)
hold on
plot(recu_1)
xlabel("Temps [s]")
ylabel("Amplitude")
title("Signal démodulé")
legend("1", "0")


%5-4
%Signal modulé en fréquence
%densité spectrale puissance

dsp2=fft(autocorr(nrz));
plot(dsp2);
hold on;