clear all;
close all;


% CONSTANTES
ordre_filtre = 61;
snr = 10;
Fe = 48000;
Te = 1/Fe;
Ts = 1/300; % 1 / débit en bits/sec
Ns = floor(Ts/Te);
Nbits = 25;


% 3.1.1
[bits_originaux, signal_nrz] = nrz(Nbits, Ns);
% 3.1.2
figure_nrz(signal_nrz, Te, Nbits, Ns, "Signal NRZ aléatoire", "signal-nrz-aleatoire")
% 3.1.(3, 4)
dsp_nrz_experimentale = dsp_experimentale(signal_nrz, Fe);
figure_dsp(dsp_nrz_experimentale, dsp_nrz_theorique(Ts, Te, length(dsp_nrz_experimentale)), Fe, "Densité spectrale de puissance du signal NRZ aléatoire", "dsp-nrz-aleatoire")

% 3.2.1
phi_0 = rand*2*pi;
phi_1 = rand*2*pi;
frequence_0 = 6000;
frequence_1 = 2000;
nrz_module = moduler(signal_nrz, frequence_0, frequence_1, phi_0, phi_1, Nbits, Ns, Te);
% 3.2.2
figure_signal_module(nrz_module, sprintf("Modulation du signal NRZ aléatoire (bit 0 sur %dHz, bit 1 sur %dHz)", frequence_0, frequence_1), "signal-nrz-module")
% 3.2.3
dsp_nrz_module_theorique = dsp_signal_module_theorique(nrz_module);
% 3.2.4
dsp_nrz_module_experimentale = dsp_experimentale(nrz_module, Fe);
figure_dsp(dsp_nrz_module_theorique, dsp_nrz_module_experimentale, Fe, "Densité spectrale de puissance du signal modulé", "dsp-nrz-module")

% 4
nrz_bruite = bruiter(nrz_module, snr);
figure_signal_module(nrz_bruite, "Signal bruité", "signal-bruite")

% 5.1
frequence_coupure = mean([frequence_1, frequence_0]);
[filtre_haut_impulsionnelle, filtre_haut_frequentielle] = construire_filtre_haut(frequence_coupure, ordre_filtre, Te);
% 5.2.1
% TODO
% 5.2.2
[filtre_bas_impulsionnelle, filtre_bas_frequentielle] = construire_filtre_bas(filtre_haut_impulsionnelle, filtre_haut_frequentielle, ordre_filtre, Te);

% 5.3
[signal_0, signal_1] = demoduler(nrz_bruite, filtre_haut_impulsionnelle, filtre_bas_impulsionnelle);

% 5.4.1
figure_reponses_filtre(filtre_haut_impulsionnelle, filtre_haut_frequentielle, ordre_filtre, Te, 'filtre passe-haut', 'reponse-passe-haut')
figure_reponses_filtre(filtre_bas_impulsionnelle, filtre_bas_frequentielle, ordre_filtre, Te, 'filtre passe-bas', 'reponse-passe-bas')
% 5.4.2
f = linspace(-Fe/2, Fe/2, length(dsp_nrz_module_experimentale));
hold on 
semilogy(f, fftshift(dsp_nrz_module_experimentale))
semilogy(f, fftshift(reponse_bas_frequentielle))
semilogy(f, fftshift(reponse_haut_frequentielle))
hold off
xlabel("fréquence [Hz]")
ylabel("amplitude")
legend('Entrée', 'Passe-bas', 'Passe-haut')
title("Filtrage du signal modulé")
tikzfigure('filtrage-signal-module')
% 5.4.3
figure_signal_demodule(signal_0, signal_1, Fe, 'Signal démodulé', 'signal-demodule')
% TODO: faire les DSPs du démodulé

% 5.5.(1, 2)
bits_reconstruits = reconstruire_depuis_demodule_filtre(signal_1, Nbits, Ns);
figure_bits_comparaison(bits_reconstruits, bits_originaux, Te, Nbits, Ns, snr, 'Signal reconstruit par filtrage et détection d''énergie', 'bits-reconstruits-filtrage')

% 5.6
% TODO

% 6.1.1
% TODO

% 6.1.2
bits_reconstruits = reconstruire_phase_parfaite_v21(nrz_bruite, Ns, phi_0, phi_1, Te);
figure_bits_comparaison(bits_reconstruits, bits_originaux, Te, Nbits, Ns, snr, 'Signal reconstruit par démodulation FSK, avec une synchronisation idéale', 'bits-reconstruits-fsk-synchro-parfaite')

% 6.2.1
% On introduit une erreur en retirant la compensation du déphasage
% aléatoire: on met phi_0 et phi_1 à 0 en entrée du reconstructeur
% seulement, et on les laisse sur le signal NRZ original
bits_reconstruits = reconstruire_phase_parfaite_v21(nrz_bruite, Ns, 0, 0, Te);
figure_bits_comparaison(bits_reconstruits, bits_originaux, Te, Nbits, Ns, snr, 'Signal reconstruit par démodulation FSK, sans correction de désynchronisation', 'bits-reconstruits-fsk-sans-correction-desynchro')
% TODO explication

% 6.2.2.a 
% cf rapport

% 6.2.2.b
bits_reconstruits = reconstruire_v21(nrz_bruite, Ns);
figure_bits_comparaison(bits_reconstruits, bits_originaux, Te, Nbits, Ns, snr, 'Signal reconstruit par démodulation FSK', 'bits-reconstruits-fsk')

% 6.2.2.c
% TODO


function [bits, signal_nrz] = nrz(Nbits, Ns)
    bits = randi([0, 1], 1, Nbits);
    signal_nrz = kron(bits, ones(1, Ns));
end

function dsp = dsp_experimentale(signal, Fe)
    dsp = fftshift(pwelch(signal, [], [], [], Fe, 'twosided'));
end


function dsp = dsp_nrz_theorique(Ts, Te, taille_dsp_exp)
    f = linspace(-Te/2, Te/2, taille_dsp_exp);
    dsp = 0.25*Ts*(sinc(f*Ts).^2);
    dsp(f==0) = dsp(f==0) + 0.25;
end


function signal_module = moduler(nrz, frequence_0, frequence_1, phi_0, phi_1, Nbits, Ns, Te)
    t=0:Te:(Nbits*Ns-1)*Te;
    signal_module = nrz .* cos(2*pi*frequence_1*t+phi_1) + (1-nrz) .* cos(2*pi*frequence_0*t+phi_0);
end

% 3.2.3

function dsp = dsp_signal_module_theorique(signal_module)
    % FIXME on devrai utiliser nrz, pas le signal module
    dsp=abs(fftshift(fft(signal_module))).^2;
    f=linspace(-Fe/2, Fe/2, length(dsp));
    semilogy(f, dsp)
    xlabel("Fréquence [Hz]")
    ylabel("Amplitude")
    title("Densité spectrale de puissance du signal modulé en fréquence")
end

% 4
function signal_bruite = bruiter(signal, snr)
    puissance_module = mean(abs(signal).^2);
    sigma = sqrt(puissance_module/10^(snr/10));
    bruit = sigma * randn(1, length(signal));
    signal_bruite = signal + bruit;
end

function [reponse_impulsionnelle, reponse_frequentielle] = construire_filtre_haut(frequence_coupure, ordre_filtre, Te)
    t = -(ordre_filtre - 1) / 2 * Te : Te : (ordre_filtre - 1)/2 * Te;
    reponse_impulsionnelle = 2 * (frequence_coupure / Fe) * sinc(2 * frequence_coupure * t);
    reponse_frequentielle = fftshift(fft(reponse_impulsionnelle, 8192));
end

function [reponse_impulsionnelle, reponse_frequentielle]  = construire_filtre_bas(filtre_haut_impuls, filtre_haut_freq, ordre_filtre, Te)
    t = -(ordre_filtre - 1) / 2 * Te : Te : (ordre_filtre - 1)/2 * Te;
            
    reponse_frequentielle = 1 - filtre_haut_freq;
    reponse_impulsionnelle = -filtre_haut_impuls;
    reponse_impulsionnelle(t==0) = reponse_impulsionnelle(t==0) + 1;
end

function [signal_0, signal_1] = demoduler(signal, filtre_haut_impuls, filtre_bas_impuls)
    signal_1 = filter(filtre_haut_impuls, 1, signal);
    signal_0 = filter(filtre_bas_impuls, 1, signal);
end

function [signal_reconstruit] = reconstruire_depuis_demodule_filtre(signal_1, Nbits, Ns)
    matrice_energie = reshape(signal_1, Nbits, Ns);
    energies=sum(matrice_energie.^2, 1);
    energie_moyenne=mean(energies);
    signal_reconstruit=energies > energie_moyenne;
end

function taux_erreur = taux_erreur(original, recu)
    taux_erreur = sum(recu ~= original) / length(original);
end

function signal_reconstruit = reconstruire_phase_parfaite_v21(module_bruite, Ns, phi_0, phi_1, Te)
    frequence_0 = 1180;
    frequence_1 = 980;
    sync_0 = Te * sum(reshape(module_bruite .* cos(2 * pi * frequence_0 * t + phi_0), Ns, []));    
    sync_1 = Te * sum(reshape(module_bruite .* cos(2 * pi * frequence_1 * t + phi_1), Ns, []));

    signal_reconstruit = sync_1 > sync_0;
end

function signal_reconstruit = reconstruire_v21(module_bruite, Ns)
    frequence_0 = 1180;
    frequence_1 = 980;
    % On montre que l'ajout d'un déphasage aléatoire ne change pas le
    % résultat
    phi0 = 0;
    phi1 = 0;

    sync_sin_0 = sum(reshape(module_bruite .* sin(2 * pi * frequence_0 * t + phi0), Ns, [])) .^ 2;
    sync_cos_0 = sum(reshape(module_bruite .* cos(2 * pi * frequence_0 * t + phi0), Ns, [])) .^ 2;
    sync_sin_1 = sum(reshape(module_bruite .* sin(2 * pi * frequence_1 * t + phi1), Ns, [])) .^ 2;
    sync_cos_1 = sum(reshape(module_bruite .* cos(2 * pi * frequence_1 * t + phi1), Ns, [])) .^ 2;

    sync_0 = sync_sin_0 + sync_cos_0;
    sync_1 = sync_sin_1 + sync_cos_1;
    signal_reconstruit = sync_1 > sync_0;
end


function image_retrouvee = reconstruire_image(signal)
    suite_binaire_reconstruite = reconstruire_v21(signal, Ns);
    mat_image_binaire_retrouvee = reshape(suite_binaire_reconstruite,105*100,8);
    mat_image_decimal_retrouvee = bi2de(mat_image_binaire_retrouvee);
    image_retrouvee = reshape(mat_image_decimal_retrouvee,105,100);
end

function figure_signal_module(signal, titre, fichier_tikz)
   plot(signal)
   xlabel("temps [s]")
   ylabel("amplitude")
   ylim([-1.1, 1.1])
   title(titre)
   tikzfigure(fichier_tikz)
end

function figure_signal_demodule(signal_0, signal_1, titre, fichier_tikz)
   hold on
   plot(signal_0)
   plot(signal_1)
   hold off
   xlabel("temps [s]")
   ylabel("amplitude")
   ylim([-1.1, 1.1])
   title(titre)
   legend("Bit 1", "Bit 0")
   tikzfigure(fichier_tikz)
end

% Attention: la dsp ne doit pas être fftshiftée
function figure_dsp(dsp_experimentale, dsp_theorique, Fe, titre, fichier_tikz)
    f = linspace(-Fe/2, Fe/2, length(dsp_experimentale));
    semilogy(f, fftshift(dsp_experimentale), 'r')
    semilogy(f, dsp_theorique, 'b')
    xlabel("fréquence [Hz]")
    ylabel("Densité spectrale de puissance")
    legend("Expérimentale", "Théorique")
    title(titre)
    tikzfigure(fichier_tikz)
end

function figure_nrz(nrz, Te, Nbits, Ns, titre, fichier_tikz)
    t = 0:Te:(Nbits*Ns-1)*Te;
    plot(t, nrz)
    xlabel("temps [s]")
    ylabel("bit")
    title(titre)
    ylim([-0.1, 1.1])
    tikzfigure(fichier_tikz)
end

function figure_bits_comparaison(bits_recus, bits_originaux, Te, Nbits, Ns, snr, titre, fichier_tikz)
    t = 0:Te:(Nbits*Ns-1)*Te;
    
    nrz_recu = kron(bits_recu, ones(1, Ns));
    nrz_original = kron(bits_originaux, ones(1, Ns));
    
    hold on 
    plot(t, nrz_original, 'LineWidth', 2)
    plot(t, nrz_recu, '--', 'LineWidth', 4)
    hold off
    xlabel("temps [s]")
    ylabel("bit")
    legend("Original", "Reconstitué")
    ylim([-0.1, 1.1])
    title(sprintf("%s (taux d'erreur: %.2f%%, SNR: %d)", titre, taux_erreur(bits_originaux, bits_recus)*100), snr)
    tikzfigure(fichier_tikz)
end

function figure_reponses_filtre(reponse_impulsionnelle, reponse_frequentielle, ordre_filtre, Te, titre, fichier_tikz)
    t_filtres = -(ordre_filtre - 1) / 2 * Te : Te : (ordre_filtre - 1)/2 * Te;
    f_filtres = linspace(-Fe/2, Fe/2, length(reponse_frequentielle));
    
    plot(t_filtres, reponse_impulsionnelle);
    xlabel("temps [s]")
    ylabel("amplitude")
    title(sprintf('Réponse impulsionnelle du %s', titre))
    tikzfigure(sprintf('%s-impulsionnelle', fichier_tikz))
    
    plot(f_filtres, reponse_frequentielle);
    xlabel("fréquence [Hz]")
    ylabel("amplitude")
    title(sprintf('Réponse fréquentielle du %s', titre))
    tikzfigure(sprintf('%s-frequentielle', fichier_tikz))
end

function tikzfigure(name)
	matlab2tikz(sprintf('figures/%s.tex', name));
end
