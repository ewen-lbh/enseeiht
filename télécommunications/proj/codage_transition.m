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


Eb_N0_dBs = 0:0.5:8;
Eb_N0_lineaires = 10.^(Eb_N0_dBs/10);

teb_exp_sans_erreur = zeros(size(Eb_N0_dBs));
teb_exp_avec_erreur_sans_correction = zeros(size(Eb_N0_dBs));
teb_exp_avec_erreur = zeros(size(Eb_N0_dBs));
teb_exp_avec_erreur_codage_transition = zeros(size(Eb_N0_dBs));
teb_theo_sans_erreur = zeros(size(Eb_N0_dBs));
teb_theo_avec_erreur = zeros(size(Eb_N0_dBs));

% BITS
bits = randi([0, 1], 1, Nbits);

% MAPPING
apres_mapping = 2*bits - 1;

erreur_de_phase = 100;
for index = 1:length(Eb_N0_dBs)
    for i = [1 2 3]
        if i == 1
            erreur_phase = 0;
        else
            erreur_phase = erreur_de_phase;
        end

        % CODAGE PAR TRANSITION
        if i == 3
            apres_codage = coder_par_transition(apres_mapping);
        else
            apres_codage = apres_mapping;
        end
        
        % SURECHANTILLONAGE
        apres_surechantillonage = kron(apres_codage, [1 zeros(1, Ns-1)]);
        
        % FILTRAGE
        f = linspace(-Te/2, Te/2, Ns);
        h = ones(1, Ns); 
        apres_filtrage = filter(h, 1, apres_surechantillonage);

        
        % INTRODUCTION ERREUR DE PHASE
        apres_erreur_phase = apres_filtrage * exp(1j * deg2rad(erreur_phase));
        
        % BRUITAGE
        apres_bruitage = bruitage(apres_erreur_phase, Eb_N0_dBs(index), Ns, M);
        
        % FILTRAGE RECEPTION
        h_r = h;
        apres_filtrage_reception = filter(h_r, 1, apres_bruitage);
                       
        % ECHANTILLONAGE
        apres_echantillonage = apres_filtrage_reception(Ns:Ns:end);

        % CORRECTION ERREUR DE PHASE
        estimation_erreur_phase = 1/2 * angle(sum(apres_echantillonage .^ 2)); % rad
        apres_correction_erreur_phase = apres_echantillonage .* exp(-1j * estimation_erreur_phase);
       
        % DECISION
        apres_decision = sign(real(apres_correction_erreur_phase));

        % DECODAGE
        if i == 3
            apres_decodage = decoder_par_transition(apres_decision);
        else
            apres_decodage = apres_decision;
        end
        
        % DEMAPPING
        apres_demapping = (apres_decodage+1)/2;
        
        % TEB
        if erreur_phase == 0
            teb_exp_sans_erreur(index) = length(find((apres_demapping ~= bits))) / length(bits);
            teb_theo_sans_erreur(index) = qfunc(sqrt(2 * Eb_N0_lineaires(index)) * cos(deg2rad(erreur_phase)));
        else
            if i == 3
                teb_exp_avec_erreur_codage_transition(index) = length(find((apres_demapping ~= bits))) / length(bits);
            else
                teb_exp_avec_erreur(index) = length(find((apres_demapping ~= bits))) / length(bits);
            end
            teb_theo_avec_erreur(index) = qfunc(sqrt(2 * Eb_N0_lineaires(index)) * cos(deg2rad(erreur_phase)));
            teb_exp_avec_erreur_sans_correction(index) = length(find((sign(real((apres_echantillonage+1)/2)) ~= bits))) / length(bits);
        end
    end
end

figure
semilogy(teb_exp_avec_erreur_sans_correction)
hold on
semilogy(teb_exp_avec_erreur)
hold on
semilogy(teb_exp_avec_erreur_codage_transition)
legend("Expérimental avec erreur de phase", sprintf("Expérimental sans codage par transition", erreur_de_phase), sprintf("Expérimental avec codage par transition", erreur_de_phase))
title(sprintf("Comparaison des TEBs avec \\phi = %d", erreur_de_phase))
xlabel("E_b / n_0")
ylabel("TEB")

function apres_codage = coder_par_transition(apres_mapping)
    apres_codage = zeros(1, length(apres_mapping));
    c_0 = 1;
    apres_codage(1) = c_0 * apres_mapping(1);
    for i = 2:length(apres_mapping)
        apres_codage(i) = apres_codage(i-1) * apres_mapping(i);
    end
end

function apres_decodage = decoder_par_transition(apres_decision)
    apres_decodage = zeros(1, length(apres_decision));
    c_0 = 1;
    apres_decodage(1) = apres_decision(1) / c_0;
    for i = 2:length(apres_decodage)
        apres_decodage(i) = apres_decision(i) / apres_decision(i-1);
    end
end

function bruite = bruitage(signal, Eb_N0_dB, Ns, M)
    Eb_N0_lineaire = 10.^(Eb_N0_dB/10);
    P = mean(abs(signal).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire)));
    bruit_reel = sigma .* randn(1, length(signal));
    bruit_imaginaire = sigma .* randn(1, length(signal)); % 
    bruite = signal+(bruit_reel + 1i * bruit_imaginaire);
end