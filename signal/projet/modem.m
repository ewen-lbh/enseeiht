clear all;
close all;

Fe = 48000;
Te = 1/Fe;
Ts = 1/300; % 1 / débit en bits/sec
Ns = floor(Ts/Te);
Nbits = 10;
phi0=rand*2*pi;
phi1=rand*2*pi;


% 3.1.1

bits = randi([0, 1], 1, Nbits);
nrz = kron(bits, ones(1, Ns));

% 3.1.2

figure(1)
plot(nrz)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal NRZ aléatoire")

% 3.1.3


figure(2)
dsp = pwelch(nrz, [], [], [], Fe, 'twosided');
f=linspace(-Fe/2, Fe/2, length(dsp));
semilogy(f, fftshift(dsp))
xlabel("fréquence [Hz]")
ylabel("Densité spectrale de puissance")
title("Densité spectrale de puissance")

% 3.1.4

hold on;

dsp2=0.25*Ts*(sinc(pi*f*Ts).^2)+0.25*dirac(f);
semilogy(f, dsp2, 'r')
legend("Pratique", "Théorique")

% 3.2.1
figure(3)

t = linspace(1, Nbits*Ts, Nbits*Ns);
size(t)
size(nrz)
frequence_0 = 6000; % 1180;
frequence_1 = 2000; % 980;
module = nrz .* cos(2*pi.*frequence_1.*t+phi1) + (1-nrz) .* cos(2*pi.*frequence_0.*t+phi0);
size(module)

% 3.2.2

plot(t, module);
xlabel("Temps [s]")
ylabel("Amplitude")
title("NRZ modulé en fréquence")

figure(4)

% 3.2.3

dsp4=%TODO
f=linspace(-Fe/2, Fe/2, length(dsp4));
semilogy(f, fftshift(dsp4))

hold on;

% 3.2.4
dsp3=pwelch(module, [], [], [], Fe, 'twosided');
f=linspace(-Fe/2, Fe/2, length(dsp3));
semilogy(f, fftshift(dsp3))

