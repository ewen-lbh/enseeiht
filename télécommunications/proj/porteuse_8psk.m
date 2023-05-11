clear all;
close all;
clc;
Fp = 2000;
Fe = 6000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;
rolloff = 0.2;

n=3;
M = 2^n;
Ts = n*Tb;
Nbits = 1000002;
Ns = floor(Ts/Te);


% BITS
bits = randi([0, 1], 1, Nbits);

% figure;
% plot(bits(1:30))
% title("30 premières Bits en entrée")


% MAPPING
symboles = pskmod(bits', M, pi/M, "gray", "InputType", "bit")';
% apres_demapping = reshape(de2bi(pskdemod(apres_decision, M, pi/8, 'gray')), 1, []);

scatterplot(symboles)
% title("Symboles")

% SURECHANTILLONAGE
symboles_surech = (kron(symboles, [1 zeros(1, Ns-1)]));
t = 0:Te:(length(symboles_surech)-1)*Te;

% plot_complex(symboles_surech, t,"Symboles surechantillonés")


% FILTRAGE
span = 100;
h = rcosdesign(rolloff, span, Ns);
% Gestion du retard
ordre_filtre = span*Ns;
retard = (ordre_filtre + mod(ordre_filtre, 2)) / 2;
enveloppe_complexe1 = filter(h, 1, [symboles_surech zeros(1,retard)]);
enveloppe_complexe = enveloppe_complexe1(retard+1:end);
% dsp(enveloppe_complexe, Fe, "DSP enveloppe complexe")

Eb_N0_dBs = 0:1:6;
Eb_N0_lin= 10.^(Eb_N0_dBs);
tebs_exp = zeros(1, length(Eb_N0_dBs));
tebs_theo = zeros(1, length(Eb_N0_dBs));

for i = 1:length(Eb_N0_dBs)
    % BRUITAGE (plus PASSE-BAS ÉQUIVALENT askip)
    apres_bruitage = bruitage(enveloppe_complexe, Eb_N0_dBs(i), Ns, M);
    
    % FILTRAGE DE RECEPTION
    % On reprend un filtre avec retard géré
    h_r = h;
    apres_filtre_reception1 = filter(h_r, 1, [apres_bruitage zeros(1, retard)]);
    apres_filtre_reception = apres_filtre_reception1(retard+1:end);
    
    % plot_complex(apres_filtre_reception, t, "Signal après filtrage à la réception")
    
    % ÉCHANTILLONNAGE
    n_0 = 1;
    apres_echantillonage = apres_filtre_reception(n_0:Ns:end);
    
    
       
    % DÉCISION
    apres_decision = zeros(1, length(apres_echantillonage));
    angles = (-(M-1):2:M).*(pi/M);
    
    for k = 1:length(apres_decision)
        [~, indice_angle_plus_proche] = min(abs(angles - angle(apres_echantillonage(k))));
        apres_decision(k) = 1 * exp(1i * angles(indice_angle_plus_proche));
        %rad2deg(angle(apres_echantillonage(k)))
        %abs(angles - angle(apres_echantillonage(k)))
        %rad2deg(angle(apres_decision(k)))
    end

    if mod(Eb_N0_dBs(i), 5) == 0
        figure
        scatterplot(apres_echantillonage)
        hold on 
        scatterplot(apres_decision)
        title(sprintf("Signal avec Eb/N0 = %d dB", Eb_N0_dBs(i)))
        legend("Après échantillonage", "Après décision")
    end
    
    
    if Eb_N0_dBs(i) == 20
        figure
        %plot(t(1:200), symboles_surech(1:200))
        plot(t(1:200), imag(symboles_surech(1:200)))
        hold on
        %plot(t(1:200), apres_filtre_reception(1:200))
        plot(t(1:200), imag(apres_filtre_reception(1:200)))
        title("Signaux")
        legend("Symboles suréchantillonés", "Après filtre de réception")
        saveas(gcf, "8psk_comparaison_surech_filtre_reception.png")
    end


    % DEMAPPING    
%    apres_demapping = reshape(pskdemod(apres_decision, M, pi/M, 'gray', 'OutputType', 'bit'), 1, []);
   apres_demapping = (pskdemod(apres_echantillonage', M, pi/M, 'gray', 'OutputType', 'bit'))';

    %figure
    %title("Comparaison bits au début et à la fin de la chaîne")
    %plot(bits(1:20))
    %hold on
    %plot(apres_demapping(1:20))
    %legend("Début" ,"Fin")
    
    % TEB
    teb_exp = teb(bits, apres_demapping);
    Eb_N0_lineaire = 10.^(Eb_N0_dBs/10);
    P = mean(abs(enveloppe_complexe).^2);
    sigma_a = sqrt((P * Ns) ./ (2 * log2(M) * ( Eb_N0_lineaire(i))));
    teb_theo = 2*qfunc(sqrt(6*Eb_N0_lineaire)*sin(pi/M))/log2(M);
%     teb_theo = 2*(1-1/M)*qfunc((1/sigma_a)*sqrt(2* Eb_N0_dBs(i)))/log2(M);
    tebs_exp(i) = teb_exp;
    tebs_theo = teb_theo;
end

figure
semilogy(Eb_N0_dBs, tebs_theo)
hold on
semilogy(Eb_N0_dBs, tebs_exp)
legend("Théoriques", "Expérimentaux")
title("Comparaison des TEBs pour une chaîne avec passe-bas équivalent") 

function bruite = bruitage(signal, Eb_N0_dBs, Ns, M)
    Eb_N0_lineaire = 10.^(Eb_N0_dBs/10);
    P = mean(abs(signal).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire)));
    bruit_reel = sigma .* randn(1, length(signal));
    bruit_imaginaire = sigma .* randn(1, length(signal)); % 
    bruite = signal+(bruit_reel + 1i * bruit_imaginaire);
end

function ret = teb(in, out)
    ret = length(find((in ~= out)))/length(out);
end

function dsp (signal, Fe, titre)
    figure
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







