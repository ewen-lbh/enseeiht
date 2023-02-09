clear all;
close all;

%Initialisation des variables
V21 = false;
NOMBRE_COEFS_FILTRE = 61;
snr = 10;

Fe = 48000;
Te = 1 / Fe;
Ts = 1/300; % 1/débit en bits/sec
Ns = floor(Ts / Te);
Nbits = 25;

% Déphasages tirés aléatoirement dans [0,2pi]
phi0 = rand * 2 * pi;
phi1 = rand * 2 * pi;

% 3 - Modem de fréquence

% 3.1.1

% génération d'un signal NRZ

bits = randi([0, 1], 1, Nbits); % suite de bits aléatoire
nrz = kron(bits, ones(1, Ns)); % signal NRZ

% 3.1.2
% Tracé du signal

figure; hold off;
plot(nrz)
xlabel("temps [s]")
ylabel("$m_i(t)$")
ylim([-0.1, 1.1])
title("Signal NRZ aléatoire")
% cleanfigure;
% matlab2tikz('figures/nrz-aleatoire.tex');

% 3.1.3

% Calcul de la densité spectrale de puissance expérimentale avec pwelch

figure; hold off;
dsp = pwelch(nrz, [], [], [], Fe, 'twosided');
f = linspace(-Fe / 2, Fe / 2, length(dsp));

% Tracé de la densité spectrale de puissance expérientale

semilogy(f, fftshift(dsp))
xlabel("fréquence [Hz]")
ylabel("Densité spectrale de puissance")
title("Densité spectrale de puissance")

% 3.1.4

% Calcul de la densité spectrale de puissance théorique

hold on;

dsp2 = 0.25 * Ts * (sinc(f * Ts) .^ 2);
dsp2(f == 0) = dsp2(f == 0) + 0.25;

% Tracé de la densité spectrale de puissance théorique
semilogy(f, dsp2, 'r')
legend("Pratique", "Théorique")
% cleanfigure;
% matlab2tikz('figures/dsp-nrz-pratique-theorique.tex');

% 3.2.1

% Génération du signal modulé en fréquence

t = 0:Te:(Nbits * Ns - 1) * Te;

% si on est dans le cadre de la recommandadtion V21 alors on utilise les
% fréquence recommandées, sinon on prend f0=6kHz et f1=2kHz
if V21
    frequence_0 = 1180
    frequence_1 = 980
else
    frequence_0 = 6000
    frequence_1 = 2000
end

% calcul du signal modulé en fréquence

module = nrz .* cos(2 * pi * frequence_1 * t + phi1) + (1 - nrz) .* cos(2 * pi * frequence_0 * t + phi0);
size(module)

% 3.2.2

% Tracé du signal modulé en fréquence

figure; hold off;
plot(t, module);
xlabel("Temps [s]")
ylabel("Amplitude")
ylim([-0.1, 1.1])
title("NRZ modulé en fréquence")
% cleanfigure;
% matlab2tikz('figures/nrz-module-en-frequence.tex');

% 3.2.3

% Calcul de la densité spectrale de puissance théorique du signal modulé

figure; hold off;

dsp4 = abs(fftshift(fft(module))) .^ 2;

% Tracé de la densité spectrale de puissance théorique du signal modulé
f = linspace(-Fe / 2, Fe / 2, length(dsp4));
semilogy(f, dsp4)
xlabel("Fréquence [Hz]")
ylabel("Amplitude")
title("Densité spectrale de puissance")

hold on;

% 3.2.4

% Calcul de la densité spectrale de puissance expérimentale du signal modulé

dsp3 = fftshift(pwelch(module, [], [], [], Fe, 'twosided'));

% Tracé de la densité spectrale de puissance théorique du signal modulé

f = linspace(-Fe / 2, Fe / 2, length(dsp3));
semilogy(f, dsp3)
legend("Théorique", "Expérimentale")
title("DSP du signal modulé")
% cleanfigure;
% matlab2tikz('figures/dsp-nrz-module-en-frequence.tex');

% 4 - Canal de transmission à bruit additif, blanc et Gaussien

% Génération du bruit
figure; hold off;
puissance_module = mean(abs(module) .^ 2);
sigma = sqrt(puissance_module / 10 ^ (snr / 10));
bruit = sigma * randn(1, length(module));

% On ajoute le bruit au signal modulé en fréquence
module_bruite = module + bruit;

% On trace la somme des deux signaux
plot(module_bruite)
xlabel("Temps [s]")
ylabel("Amplitude")
title("Signal bruité (SNR = " + snr + " dB)")
% cleanfigure;
% matlab2tikz('figures/signal-bruite.tex');

% 5 - Démodulation par filtrage

f = linspace(-Fe / 2, Fe / 2, length(module_bruite));

% On fixe l'ordre du filtre
ordre_2 = NOMBRE_COEFS_FILTRE; %valeur bonne: 61, test à 201
t_ordre_2 =- (ordre_2 - 1) / 2 * Te:Te:(ordre_2 - 1) / 2 * Te;

% On place la fréquence de coupure au milieu entre f0 et f1
fc = (frequence_0 + frequence_1) / 2;

% Calcul des fonctions transfert du passe haut et du passe bas
%TODO fix plotting of H
h_haut = 2 * (fc / Fe) * sinc(2 * fc * t_ordre_2);
H_haut = fftshift(fft(h_haut, 8192));
H_bas = 1 - H_haut;

h_bas = -h_haut;

% ajout d'un dirac
h_bas(t_ordre_2 == 0) = h_bas(t_ordre_2 == 0) + 1;
find(f==0)
% Réception du signal modulé bruité sortant du passe haut puis du passe bas
recu_1 = filter(h_haut, 1, module_bruite);
recu_0 = filter(h_bas, 1, module_bruite);

% Tracé des sorties
figure; hold off;
plot(recu_1)
hold on
plot(recu_0)
xlabel("Temps [s]")
ylabel("Amplitude")
title("Signal démodulé")
legend("1", "0")
cleanfigure;
matlab2tikz('figures/signal-demodule.tex');

%5-4
%Signal modulé en fréquence
%densité spectrale puissance

%1)
% tracé des réponses impultionnelles

figure; hold off;
plot(t_ordre_2, h_bas);
hold on
plot(t_ordre_2, h_haut);
title("Réponses impulsionnelles")
cleanfigure;
matlab2tikz('figures/reponse-impulsionnelle-bas-haut.tex');

% Tracé des réponses en fréquence des filtres
figure; hold off;
semilogy(linspace(-Fe / 2, Fe / 2, length(H_haut)), H_bas);
hold on
semilogy(linspace(-Fe / 2, Fe / 2, length(H_haut)), H_haut);
title("Réponses fréquentielles")
cleanfigure;
matlab2tikz('figures/reponse-frequentielle-bas-haut.tex');

%2
% Tracé de la densité spectrale de puissance du signal modulé
% et de la réponse en fréquences du fltre

figure; hold off;
signal_filtre = recu_1 + recu_0;
semilogy(linspace(-Fe / 2, Fe / 2, length(dsp)), fftshift(dsp));
title("DSP du signal filtré théorique")
cleanfigure;
matlab2tikz('figures/dsp-signal-filtre-theorique.tex');

figure; hold off;
pwelch_filtre = fftshift(pwelch(signal_filtre, [], [], [], Fe, 'twosided'));
semilogy(linspace(-Fe / 2, Fe / 2, length(dsp)), pwelch_filtre);
cleanfigure;
title("DSP du signal filtré expérimentale")
matlab2tikz('figures/dsp-signal-filtre-experimentale.tex');

%3)
%tracé dusignal filtré

%5-5
%Calcul des energies de chaque période

matrice_energie = reshape(recu_1, Nbits, Ns);
S = sum(matrice_energie .^ 2, 1);

% Définition du seuil K
K = mean(S);

% Reconstitution du signal avec la méthode des energies
signal_reconstitue = kron(S > K, ones(1, length(nrz) / Ns));

figure; hold off;

% Tracé des énergies
% TODO enlever si inutilisé
plot(S)
title("Énergies")
cleanfigure;
matlab2tikz('figures/energie.tex');

% Tracé du signal
figure; hold off;
plot(t, signal_reconstitue)
ylim([-0.1, 1.1])
title("Signal reconstitué")
cleanfigure;
matlab2tikz('figures/signal-reconstitue.tex');

% calcul du taux d'erreur binaire associé à la démodulation
erreur = sum(signal_reconstitue ~= nrz) / length(nrz); % 0.0912

% 3 scripts: création bruit, filtrage 1 et filtrage 2

%5-6-1 ----> a l'ordre 201 on obtient toujours de bons résultats.

% 6
% 6.1

if V21
    sync_0 = sum(reshape(module_bruite .* cos(2 * pi * frequence_0 * t + phi0), Nbits, Ns), 2);
    sync_1 = sum(reshape(module_bruite .* cos(2 * pi * frequence_1 * t + phi1), Nbits, Ns), 2) ;
    demodule_synchro_parfaite = kron((sync_0 - sync_1)' < 0, ones(1, Ns));

    figure; hold off;
    plot(sync_0)
    hold on
    plot(sync_1)
    hold on
    plot(module_bruite)
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
