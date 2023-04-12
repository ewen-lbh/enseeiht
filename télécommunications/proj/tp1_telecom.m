% PARTIE 1
clc;
clear all;
close all;


% modulateur 1

n=1;

Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 10000;
Ns = floor(Ts/Te);

bits_non_map = randi([0, 1], 1, Nbits); %Nbits
bits_non_map2 = randi([0, 1], 1, 15*Nbits);

signal_1 = 2*bits_non_map - ones(1, length(bits_non_map));
signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);
f = linspace(-Te/2, Te/2, Ns);
h_2 = ones(1, Ns); 

dsp_1_theorique = 0;
dsp_1_exp = figures_modulateur(1, signal_1_map, h_2, Te, Fe, dsp_1_theorique);



% modulateur 2

n=2;
Ts = n*Tb;
Ns = floor(Ts/Te);

% TODO à voir
signal_2 = reshape(bits_non_map2, 2, [])';%bit_non_map, 2, []
signal_2_kron = (2*bi2de(signal_2)-3)';
%signal_2_kron = kron(signal_2_map, [1 zeros(1, Ns-1)]);

h_2 = ones(1, Ns);

dsp_2_theorique = 0;
dsp_2_exp = figures_modulateur(2, signal_2_kron, h_2, Te, Fe, dsp_2_theorique);


%modulateur 3
n=1; % # bits / symbole
Ts = n*Tb;
Ns = floor(Ts/Te);

bits_non_map = randi([0, 1], 1, Nbits);

signal_1 = 2*bits_non_map - 1;

signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);

alpha = 0.5;
L = 20;figure(99);
t = 0:Te:(length(signal_1_map)-1)*Te;
plot(t, signal_1_map)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal aléatoire")
h_3 = rcosdesign(alpha,L ,Ns);

sigma_a = std(signal_1_map);
f = linspace(-Te/2, Te/2, length(dsp_2_exp));
dsp_3_theorique = zeros(1, length(f));
for i = 1:length(f)
    freq = f(i)
    if abs(freq) <= (1-alpha) / (2*Ts)
        dsp_3_theorique(i) = sigma_a^2;
    elseif abs(freq) <= (1+alpha) / (2*Ts)
        dsp_3_theorique(i) = sigma_a^2 / 2 * (1+cos((pi * Ts)/alpha * (abs(f) - (1-alpha)/(2*Ts))));
    end
end
dsp_3_exp = figures_modulateur(3, signal_1_map, h_3, Te, Fe, dsp_3_theorique);


f = linspace(-Te/2, Te/2, length(dsp_1_exp));
figure;
semilogy(f, dsp_1_exp)
hold on
semilogy(f, dsp_2_exp)
hold on
semilogy(f, dsp_3_exp)
hold off
xlabel("Fréquence [Hz]")
ylabel("DSP")
title("Comparaison des DSPs expérimentales des trois modulateurs")
legend("Modulateur 1", "Modulateur 2", "Modulateur 3")
tikzfigure("comparaison_dsps_expérimentales_trois_modulateurs")


function dsp_exp = figures_modulateur(modulateur_no, nrz, h, Te, Fe, dsp_theo)

figure;
plot(nrz)
xlabel("temps [s]")
ylabel("m_i(t)")
title(strcat("Modulateur ", int2str(modulateur_no), ": Signal généré"))
tikzfigure(strcat("modulateur_", int2str(modulateur_no), "_signal_généré"))

figure;
%x=filter(signal_1, 1, ones(1,Ns));
x=filter(h,1 , nrz);
t = 0:Te:(length(x)-1)*Te;
plot(t, x)
title(strcat("Modulateur ", int2str(modulateur_no), ": Signal filtré"))
tikzfigure(strcat("modulateur_", int2str(modulateur_no), "_signal_filtré"))

figure;

dsp_exp = fftshift(pwelch(x, [], [], [], Fe, 'twosided'));
f=linspace(-Fe/2, Fe/2, length(dsp_exp));
semilogy(f, dsp_exp)
xlabel("Fréquence [Hz]")
ylabel("Densité spectrale de puissance")
title(strcat("Modulateur ", int2str(modulateur_no), ": DSP Expérimentale"))
tikzfigure(strcat("modulateur_", int2str(modulateur_no), "_dsp_expérimentale"))

figure;

semilogy(f, dsp_exp)
hold on
semilogy(f, dsp_theo)
xlabel("Fréquence [Hz]")
ylabel("Densité spectrale de puissance")
title(strcat("Modulateur ", int2str(modulateur_no), ": Comparaison des DSPs"))
tikzfigure(strcat("modulateur_", int2str(modulateur_no), "_comparaison_dsps"))
legend("Expérimentale", "Théorique")
hold off
end


function tikzfigure(name)
    if exist('cleanfigure', 'file') & exist('matlab2tikz', 'file')
        % cleanfigure;
	    matlab2tikz(sprintf('figures/%s.tex', name));
    end
end
