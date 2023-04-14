% Chaine 1
clear all;
close all;
n=1;

Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 100000;
Ns = floor(Ts/Te);
Eb_N0_dB = 0:0.5:8;
Eb_N0_lineaire = 10.^(Eb_N0_dB/10);

% Chaine 1

tebs_1 = zeros(0, length(Eb_N0_dB));

for index = 1:length(Eb_N0_dB)

    bits_non_map = randi([0, 1], 1, Nbits);
    
    signal_1 = 2*bits_non_map - 1;
    signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);
    h = ones(1,Ns);
    hr = ones(1,Ns);
    x = filter(h,1,signal_1_map);
    M = 2^n;
    n_0 = 8;
    
    P = mean(abs(x).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire(index))));
    bruit = sigma .* randn(1, length(signal_1_map));
    r = x+bruit;
    z = filter(hr,1,r);
    unmapped_ech = z(n_0:Ns:end);

    unmapped = (sign(unmapped_ech ) + 1)/ 2;
    tebs_theorique_1(index) = qfunc(sqrt(2 .* Eb_N0_lineaire(index)));
    tebs_1(index) = length(find((unmapped ~= bits_non_map)))/length(bits_non_map);
end


figure
semilogy(Eb_N0_dB, tebs_1,'b')
hold on
semilogy(Eb_N0_dB, tebs_theorique_1,'r')
title("Chaîne 1")
legend("TEB Simulé", "TEB Théorique")
tikzfigure("comparaison_teb_simule_theorique_chaine_1")

% Chaine 2

tebs_2 = zeros(0, length(Eb_N0_dB));

for index = 1:length(Eb_N0_dB)
    bits_non_map = randi([0, 1], 1, Nbits);
    
    signal_1 = 2*bits_non_map - 1;
    signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);
    h = ones(1,Ns);
    hr = ones(1,Ns/2);
    x = filter(h,1,signal_1_map);
    M = 2^n;
    n_0 = 8;
    
    P = mean(abs(x).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire(index))));
    bruit = sigma .* randn(1, length(signal_1_map));
    r = x+bruit;
    z = filter(hr,1,r);
    unmapped_ech = z(n_0:Ns:end);

    unmapped = (sign(unmapped_ech ) + 1)/ 2;
    tebs_theorique_2(index) = qfunc(sqrt(Eb_N0_lineaire(index)));
    tebs_2(index) = length(find((unmapped ~= bits_non_map)))/length(bits_non_map);
end


figure
semilogy(Eb_N0_dB, tebs_2,'b')
hold on
semilogy(Eb_N0_dB, tebs_theorique_2,'r')
title("Chaîne 2")
legend("TEB Simulé", "TEB Théorique")
tikzfigure("comparaison_teb_simule_theorique_chaine_1")

% Chaine 3

% /!\ C'est pas demandé dans le rapport mais faut aussi calculer le TES
% (taux d'err symbole)

n=2;

Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 100000;
Ns = floor(Ts/Te);
Eb_N0_dB = 0:0.5:8;
Eb_N0_lineaire = 10.^(Eb_N0_dB/10);

tebs_3 = zeros(0, length(Eb_N0_dB));
tess_3 = zeros(0, length(Eb_N0_dB));
tebs_theorique_3 = zeros(0, length(Eb_N0_dB));
tess_theorique_3 = zeros(0, length(Eb_N0_dB));

for index = 1:length(Eb_N0_dB)
    bits_non_map = randi([0, 1], 1, Nbits);
    
    signal_1 = reshape(bits_non_map, 2, [])';
    signal_1_kron = (2*bi2de(signal_1)-3)';
    signal_1_map = kron(signal_1_kron, [1 zeros(1, Ns-1)]);

    h = ones(1,Ns);
    hr = ones(1,Ns);
    x = filter(h,1,signal_1_map);
    M = 2^n;
    n_0 = 16;
    
    P = mean(abs(x).^2);
    sigma = sqrt((P * Ns) ./ (2 * log2(M) .* (Eb_N0_lineaire(index))));
    bruit = sigma .* randn(1, length(signal_1_map));
    r = x+bruit;
    z = filter(hr,1,r);
    unmapped_ech = z(n_0:Ns:end);

    apres_decision = zeros(1, length(unmapped_ech));
    apres_decision(find(unmapped_ech <= -2 * Ns)) = -3;
    apres_decision(find((-2 * Ns < unmapped_ech) & (unmapped_ech <= 0))) = -1;
    apres_decision(find((0 < unmapped_ech) & (unmapped_ech <= 2 * Ns))) = +1;
    apres_decision(find(unmapped_ech >= 2 * Ns)) = +3;

    tess_3(index) = length(find(apres_decision ~= signal_1_kron)) / length(signal_1_kron);
    tess_theorique_3(index) = (3/2) * qfunc(sqrt((4/5) * Eb_N0_lineaire(index)));

    unmapped = reshape(de2bi(((apres_decision)+3)/2)', 1, []);

    tebs_theorique_3(index) = tess_theorique_3(index) / log2(M);
    tebs_3(index) = length(find((unmapped ~= bits_non_map)))/length(bits_non_map);
end



figure
semilogy(Eb_N0_dB, tebs_3,'b')
hold on
semilogy(Eb_N0_dB, tebs_theorique_3,'b--')
hold on
semilogy(Eb_N0_dB, tess_3,'r')
hold on
semilogy(Eb_N0_dB, tess_theorique_3,'r--')

legend('TEB Simulé', 'TEB Théorique', "TES Simulé", "TES Théorique")
title("Chaîne 3")
tikzfigure("comparaison_teb_tes_simules_theoriques_chaine_3")

figure
semilogy(Eb_N0_dB, tebs_1, 'b')
hold on
semilogy(Eb_N0_dB, tebs_2, 'r')
legend('Chaîne 1: TEB Simulé', 'Chaîne 2: TEB Simulé')
tikzfigure("comparaison_teb_simules_chaines_1_2")

figure
semilogy(Eb_N0_dB, tebs_1, 'b')
hold on
semilogy(Eb_N0_dB, tebs_3, 'g')
legend('Chaîne 1: TEB Simulé', 'Chaîne 3: TEB Simulé')
tikzfigure("comparaison_teb_simules_chaines_1_3")

function tikzfigure(name)
    fprintf("Rendering %s\n", name)
    saveas(gcf, sprintf('figures/%s.png', name))
    % if exist('cleanfigure', 'file') & exist('matlab2tikz', 'file')
    %    % cleanfigure;
    %    fprintf("Rendering %s\n", name);
	%    matlab2tikz(sprintf('figures/%s.tex', name));
    % end
end

