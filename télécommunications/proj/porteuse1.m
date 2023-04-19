clear all;
close all;

Fp = 2000;
Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;
rolloff = 0.35;

n=4;
Ts = n*Tb;
Nbits = 100;
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
h_retard_compense = h(retard:end);
enveloppe_complexe = filter(h_retard_compense, 1, symboles_surech);

dsp(enveloppe_complexe, Fe, "DSP enveloppe complexe")

% TRANSPOSITION EN FREQUENCE
apres_transposition = real(enveloppe_complexe .* exp(1i * 2 * pi * Fp * t));

figure

plot(t, apres_transposition)

title("Transposition en fréquence")


dsp(apres_transposition, Fe, "DSP transposé en fréquence");

% RETOUR BORNE DE BASE
real_part = apres_transposition .* cos(2 * pi * Fp * t);
imag_part = apres_transposition .* sin(2 * pi * Fp * t);
retour_bande_base = real_part + 1i*imag_part;

scatterplot(retour_bande_base)
plot_complex(retour_bande_base)

% FILTRAGE DE RECEPTION
% h_r = h
% apres_filtre_reception



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



