close all
clear all

n=1;
M=2^n;

Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 500;
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
apres_filtrage = filter(h, 1, apres_surechantillonage)

figure
plot(t, apres_filtrage)
title("Apres filtrage")

Eb_N0_dBs = 0:0.5:8;
Eb_N0_lineaires = 10.^(Eb_N0_dBs/10);

teb_exp = zeros(size(Eb_N0_dBs));
teb_theo = zeros(size(Eb_N0_dBs));

for index = 1:length(Eb_N0_dBs)
% INTRODUCTION ERREUR DE PHASE
erreur_phase = 0 % deg

apres_erreur_phase = apres_filtrage .* exp(1j * deg2rad(erreur_phase));

% BRUITAGE
% TODO le bruit est complexe!!!!
P = mean(abs(apres_surechantillonage).^2);
sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaires(index))));
bruit = 0; % sigma .* randn(1, length(apres_mapping));
apres_bruitage = apres_erreur_phase + bruit;

% FILTRAGE RECEPTION
h_r = h;
apres_filtrage_reception = filter(h_r, 1, apres_bruitage);

% CORRECTION ERREUR DE PHASE
estimation_erreur_phase = 0 % deg
apres_correction_erreur_phase = apres_filtrage_reception .* exp(1j * estimation_erreur_phase);

% ECHANTILLONAGE
apres_echantillonage = apres_correction_erreur_phase(Ns:Ns:end);

% DEMAPPING
apres_demapping = (apres_echantillonage+1)/2;

% TEB
teb_theo(index) = qfunc(sqrt(2 * Eb_N0_lineaires(index)))
teb_exp(index) = length(find((apres_demapping ~= bits))) / length(bits)
end
figure
plot(teb_theo)
hold on
plot(teb_exp)
legend("Théorique","Expérimental")
title("Comparaison des TEBs")