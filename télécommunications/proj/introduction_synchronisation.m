close all
clear all

n=1;
M=2^n;

Fe = 24000;
Te = 1/Fe;
Rb = 6000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 100000;
Ns = floor(Ts/Te);

% BITS
bits = randi([0, 1], 1, Nbits);

% MAPPING
apres_mapping = 2*bits - 1;

% SURECHANTILLONAGE
apres_surechantillonage = kron(apres_mapping, [1 zeros(1, Ns-1)]);

% FILTRAGE
f = linspace(-Te/2, Te/2, Ns);
h = ones(1, Ns); 
apres_filtrage = filter(h, 1, apres_surechantillonage);

figure
plot(apres_filtrage(1:50))
title("Apres filtrage")

Eb_N0_dBs = 0:0.5:8;
Eb_N0_lineaires = 10.^(Eb_N0_dBs/10);

teb_exp_sans_erreur = zeros(size(Eb_N0_dBs));
teb_exp_avec_erreur = zeros(size(Eb_N0_dBs));
teb_theo_sans_erreur = zeros(size(Eb_N0_dBs));
teb_theo_avec_erreur = zeros(size(Eb_N0_dBs));

erreur_de_phase = 40;
for index = 1:length(Eb_N0_dBs)
    for erreur_phase = [0 erreur_de_phase]
        % INTRODUCTION ERREUR DE PHASE
        apres_erreur_phase = apres_filtrage * exp(1j * deg2rad(erreur_phase));
        
        % BRUITAGE
        apres_bruitage = bruitage(apres_erreur_phase, Eb_N0_dBs(index), Ns, M);
        
        % FILTRAGE RECEPTION
        h_r = h;
        apres_filtrage_reception = filter(h_r, 1, apres_bruitage);
        
        % CORRECTION ERREUR DE PHASE
        estimation_erreur_phase = 0; % deg
        apres_correction_erreur_phase = apres_filtrage_reception .* exp(-1j * estimation_erreur_phase);
        
        % ECHANTILLONAGE
        apres_echantillonage = apres_correction_erreur_phase(Ns:Ns:end);

        if mod(index, length(Eb_N0_lineaires)/2) == 0
            figure
            scatterplot(apres_echantillonage)
            title(sprintf("Constellation après échantillonage pour \\phi = %d", erreur_phase))
        end
        
        % DECISION
        apres_decision = sign(real(apres_echantillonage));
        
        % DEMAPPING
        apres_demapping = (apres_decision+1)/2;
        
        % TEB
        if erreur_phase == 0
            teb_exp_sans_erreur(index) = length(find((apres_demapping ~= bits))) / length(bits);
            teb_theo_sans_erreur(index) = qfunc(sqrt(2 * Eb_N0_lineaires(index)) * cos(deg2rad(erreur_phase)));
        else
            teb_exp_avec_erreur(index) = length(find((apres_demapping ~= bits))) / length(bits);
            teb_theo_avec_erreur(index) = qfunc(sqrt(2 * Eb_N0_lineaires(index)) * cos(deg2rad(erreur_phase)));
        end
        
    end
end
figure
semilogy(teb_theo_sans_erreur)
hold on
semilogy(teb_theo_avec_erreur)
hold on
semilogy(teb_exp_sans_erreur)
hold on
semilogy(teb_exp_avec_erreur)
legend("Théorique sans erreur", sprintf("Théorique avec \\phi = %d", erreur_de_phase) ,"Expérimental sans erreur", sprintf("Expérimental avec \\phi = %d", erreur_de_phase))
title(sprintf("Comparaison des TEBs avec \\phi = %d", erreur_de_phase))
xlabel("E_b / n_0")
ylabel("TEB")

% Figures à faire
% (comparaison TEBs + constellation) avec phi 0 et 40 puis 0 et 100


function bruite = bruitage(signal, Eb_N0_dB, Ns, M)
    Eb_N0_lineaire = 10.^(Eb_N0_dB/10);
    P = mean(abs(signal).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire)));
    bruit_reel = sigma .* randn(1, length(signal));
    bruit_imaginaire = sigma .* randn(1, length(signal)); % 
    bruite = signal+(bruit_reel + 1i * bruit_imaginaire);
end