clear all;
close all;

Fp = 2000;
Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;
rolloff = 0.35;

n=2;
M = 2^n;
Ts = n*Tb;
Nbits = 100000;
Ns = floor(Ts/Te);


% BITS
bits = randi([0, 1], 1, Nbits);

figure;
plot(bits(1:30))
title("30 premières Bits en entrée")


% MAPPING
symboles_en_phase = 2*bits(1:2:end) - 1;
symboles_en_quadrature = 2*bits(2:2:end) - 1;
symboles = symboles_en_phase + 1i * symboles_en_quadrature;

scatterplot(symboles)
title("Symboles")

% SURECHANTILLONAGE
symboles_surech = kron(symboles, [1 zeros(1, Ns-1)]);
t = 0:Te:(length(symboles_surech)-1)*Te;

plot_complex(symboles_surech, t,"Symboles surechantillonés")


% FILTRAGE
h = rcosdesign(rolloff, 100, Ns);
% Gestion du retard
ordre_filtre = 100*Ns;
retard = (ordre_filtre + mod(ordre_filtre, 2)) / 2;
enveloppe_complexe1 = filter(h, 1, [symboles_surech zeros(1,retard)]);
enveloppe_complexe = enveloppe_complexe1(retard+1:end);
dsp(enveloppe_complexe, Fe, "DSP enveloppe complexe")

% TRANSPOSITION EN FREQUENCE
apres_transposition = real(enveloppe_complexe .* exp(1i * 2 * pi * Fp * t));

figure
plot(t, apres_transposition)
title("Transposition en fréquence")

dsp(apres_transposition, Fe, "DSP transposé en fréquence");

Eb_N0_dBs = 0:1:6;
tebs_exp_manuel = zeros(1, length(Eb_N0_dBs));
tebs_exp_equiv = zeros(1, length(Eb_N0_dBs));
tebs_theo = zeros(1, length(Eb_N0_dBs));
    
for i = 1:length(Eb_N0_dBs)
    % BRUITAGE (plus PASSE-BAS ÉQUIVALENT askip)
    apres_bruitage = bruitage(apres_transposition, Eb_N0_dBs(i), Ns, M, 0);
    apres_bruitage_equiv = bruitage(enveloppe_complexe, Eb_N0_dBs(i), Ns, M, 1);

    % RETOUR BANDE DE BASE
    real_part = apres_bruitage .* cos(2 * pi * Fp * t);
    imag_part = apres_bruitage .* sin(2 * pi * Fp * t);
    retour_bande_base = real_part - 1i*imag_part;
    
    %scatterplot(retour_bande_base)
    %plot_complex(retour_bande_base, t, "Signal après retour en bande de base")
    
    % FILTRAGE DE RECEPTION
    % On reprend un filtre avec retard géré
    h_r = h;
    apres_filtre_reception1 = filter(h_r, 1, [retour_bande_base zeros(1, retard)]);
    apres_filtre_reception = apres_filtre_reception1(retard+1:end);

    apres_filtre_reception_equiv1 = filter(h_r, 1, [apres_bruitage_equiv zeros(1, retard)]);
    apres_filtre_reception_equiv = apres_filtre_reception_equiv1(retard+1:end);
    
    %plot_complex(apres_filtre_reception, t, "Signal après filtrage à la réception")

    
    
    % ÉCHANTILLONNAGE
    n_0 = 1;
    apres_echantillonage = apres_filtre_reception(n_0:Ns:end);

    apres_echantillonage_equiv = apres_filtre_reception(n_0:Ns:end);

    scatterplot(apres_echantillonage)
    title(sprintf("Signal après échantillonage avec Eb/N0 = %d dB", Eb_N0_dBs(i)))
    
    % DÉCISION
    apres_decision = zeros(1, length(apres_echantillonage) * 2);
    apres_decision(1:2:end) = sign(real(apres_echantillonage));
    apres_decision(2:2:end) = sign(imag(apres_echantillonage));

    apres_decision_equiv = zeros(1, length(apres_echantillonage_equiv) * 2);
    apres_decision_equiv(1:2:end) = sign(real(apres_echantillonage_equiv));
    apres_decision_equiv(2:2:end) = sign(imag(apres_echantillonage_equiv));

    % DEMAPPING
    apres_demapping = floor((apres_decision + 1) / 2);

    apres_demapping_equiv = floor((apres_decision_equiv + 1) / 2);

    % TEB
    Eb_N0_lineaire = 10.^(Eb_N0_dBs(i)/10);

    tebs_exp_manuel(i) = teb(bits, apres_demapping);
    tebs_exp_equiv(i) = teb(bits, apres_demapping_equiv);
    tebs_theo(i) = qfunc(sqrt(2 * Eb_N0_lineaire));
end

figure
semilogy(Eb_N0_dBs, tebs_theo)
hold on
semilogy(Eb_N0_dBs, tebs_exp_manuel)
hold on
semilogy(Eb_N0_dBs, tebs_exp_equiv)
hold on
legend("Théoriques", "Expérimentaux manuel", "Expérimentaux équivalents")
title("Comparaison des TEBs") 

function bruite = bruitage(signal, Eb_N0_dB, Ns, M, complexe)
    Eb_N0_lineaire = 10.^(Eb_N0_dB/10);
    P = mean(abs(signal).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire)));
    bruit_reel = sigma .* randn(1, length(signal));
    bruit_imaginaire = sigma .* randn(1, length(signal)); % 
    bruite = signal+(bruit_reel + complexe * 1i * bruit_imaginaire );
end



function ret = teb(in, out)
    ret = length(find((in ~= out)))/length(out);
end

function dsp (signal, Fe, titre)
    dddd = fftshift(pwelch(signal, [], [], [], Fe, "twosided"));
    f=linspace(-Fe/2, Fe/2, length(dddd));
    semilogy(f, dddd)
    title(titre)
end

function plot_complex(signal,t, titre)
    figure
    hold on
    plot(t, real(signal))
    plot(t, imag(signal))
    hold off
    title(titre)
    legend("Partie réelle", "Partie imaginaire")
end



