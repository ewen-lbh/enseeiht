clear all;
close all;

V21 = true;
snr = 200;
Fe = 48000;
Te = 1/Fe;
Ts = 1/300; % 1 / débit en bits/sec
Ns = floor(Ts/Te);
Nbits = 25;
phi0=rand*2*pi;
phi1=rand*2*pi;
layout = tiledlayout(5, 3);

% 3.1.1

bits = randi([0, 1], 1, Nbits);
nrz = kron(bits, ones(1, Ns));

% 3.1.2

figure; hold off;
plot(nrz)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal NRZ aléatoire")

% 3.1.3


figure; hold off;
dsp = pwelch(nrz, [], [], [], Fe, 'twosided');
f=linspace(-Fe/2, Fe/2, length(dsp));
semilogy(f, fftshift(dsp))
xlabel("fréquence [Hz]")
ylabel("Densité spectrale de puissance")
title("Densité spectrale de puissance")
% 3.1.4

hold on;

dsp2 = 0.25*Ts*(sinc(f*Ts).^2);
dsp2(f==0) = dsp2(f==0) + 0.25;
semilogy(f, dsp2, 'r')
legend("Pratique", "Théorique")

% 3.2.1
figure; hold off;
t=0:Te:(Nbits*Ns-1)*Te;
size(t)
size(nrz)
if V21
    frequence_0 = 1180;
    frequence_1 = 980;
else
    frequence_0 = 6000;
    frequence_1 = 2000;
end
module = nrz .* cos(2*pi*frequence_1*t+phi1) + (1-nrz) .* cos(2*pi*frequence_0*t+phi0);
size(module)

% 3.2.2

plot(t, module);
xlabel("Temps [s]")
ylabel("Amplitude")
title("NRZ modulé en fréquence")

figure; hold off;

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
figure; hold off;
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
ordre_2 = 61;  %valeur bonne: 61, test à 201
t_ordre_2 = -(ordre_2 - 1) / 2 * Te : Te : (ordre_2 - 1)/2 * Te;
fc = (frequence_0 + frequence_1) / 2;
% Attention, h doit être exprimé en fréquences normalisées
% A l'intérieur du sinc c'est bon car tu fais apparaitre Te=1/Fe dans t_ordre_2
% Mais pour le module de h ce n'est pas bon (d'ailleurs h est sensé être
% adimensionnel et dans ton cas il est exprimé en Hz)

fc2=fc;

%TODO fix plotting of H
h_haut = 2 * (fc2 / Fe) * sinc(2 * fc2 * t_ordre_2);
H_haut = fftshift(fft(h_haut, 8192));
H_bas = 1 - H_haut;

h_bas = -h_haut;
h_bas(t_ordre_2==0) = h_bas(t_ordre_2==0) + 1;
find(f==0)
recu_1 = filter(h_haut, 1, module_bruite);
recu_0 = filter(h_bas, 1, module_bruite);

figure; hold off;
hold on
plot(recu_1)
plot(recu_0)
xlabel("Temps [s]")
ylabel("Amplitude")
title("Signal démodulé")
legend("1", "0")

%5-4
%Signal modulé en fréquenfind(f==0)ce
%densité spectrale puissance

%1)
figure; hold off;

plot(t_ordre_2, h_bas);
hold on
plot(t_ordre_2, h_haut);

figure; hold off;
semilogy(linspace(-Fe/2, Fe/2, length(H_haut)), H_bas);
hold on
semilogy(linspace(-Fe/2, Fe/2, length(H_haut)), H_haut);

%2)
figure; hold off;
signal_filtre=recu_1+recu_0;
semilogy(linspace(-Fe/2, Fe/2, length(dsp)), fftshift(dsp));
figure; hold off;
aaaaaaaaaaaaa = fftshift(pwelch(signal_filtre, [], [], [], Fe, 'twosided'));
semilogy(linspace(-Fe/2, Fe/2, length(dsp)), aaaaaaaaaaaaa);

%3)
%afficher signal_filtre

%%%%%%5-5

matrice_energie = reshape(recu_1, Nbits, Ns);
S=sum(matrice_energie.^2, 1);


K=mean(S);
figure; hold off;
signal_reconstitue=kron(S > K, ones(1, length(nrz) / Ns));
plot(S)
figure; hold off;
plot(signal_reconstitue)

%erreur
erreur = sum(signal_reconstitue ~= nrz) / length(nrz)



% 3 scripts: création bruit, filtrage 1 et filtrage 2

%5-6-1 ----> a l'ordre 201 on obtient toujours de bons résultats.

if V21
    sync_0 = Te * sum(reshape(module_bruite .* cos(2 * pi * frequence_0 * t + phi0), Nbits, Ns), 2);
    
    sync_1 = Te * sum(reshape(module_bruite .* cos(2 * pi * frequence_1 * t + phi1), Nbits, Ns), 2) ;

    sync_0 - sync_1
    demodule_synchro_parfaite = kron((sync_0 - sync_1)' < 0, ones(1, Ns));

    figure; hold off;
    plot(sync_0)
    hold on
    plot(sync_1)
    hold on
    % plot(module_bruite)
    legend("sync 0", "sync 1", "modulé bruité")


    figure; hold off;
    figure
    plot(nrz, 'LineWidth', 2);
    hold on
    plot(demodule_synchro_parfaite, "--", 'LineWidth', 4)
    ylim([-0.1, 1.1])
    title("Signal démodulé avec synchronisation parfaite")
    legend("Signal d'origine", "Signal démodulé")
    % cleanfigure;
    % matlab2tikz('figures.v21.61/signal-demodule-synchro-parfaite.tex');
    taux_erreur = sum(demodule_synchro_parfaite ~= nrz) / length(nrz);


    % 6.2

    sync_sin_0 = sum(reshape(module_bruite .* sin(2 * pi * frequence_0 * t + phi0), Nbits, Ns), 2) .^ 2;
    sync_cos_0 = sum(reshape(module_bruite .* cos(2 * pi * frequence_0 * t + phi0), Nbits, Ns), 2) .^ 2;
    sync_sin_1 = sum(reshape(module_bruite .* sin(2 * pi * frequence_1 * t + phi1), Nbits, Ns), 2) .^ 2;
    sync_cos_1 = sum(reshape(module_bruite .* cos(2 * pi * frequence_1 * t + phi1), Nbits, Ns), 2) .^ 2;

    sync_0 = sync_sin_0 + sync_cos_0;
    sync_1 = sync_sin_1 + sync_cos_1;
    demodule_gestion_desync = kron((sync_0 - sync_1)' < 0, ones(1, Ns));

    figure; hold off;
    plot(nrz, 'LineWidth', 2);
    hold on
    plot(demodule_gestion_desync, "--", 'LineWidth', 4)
    ylim([-0.1, 1.1])
    title("Signal démodulé avec compensation du déphasage")
    legend("Signal d'origine", "Signal démodulé")
    % cleanfigure;
    % matlab2tikz('figures.v21.61/signal-demodule-compensation-dephasage.tex');
    taux_erreur = sum(demodule_gestion_desync ~= nrz) / length(nrz);

end