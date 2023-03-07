% Chaine 1

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


figure;
plot(signal_1_map)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal aléatoire")

figure;
%x=filter(signal_1, 1, ones(1,Ns));
x=filter(h_2,1 , signal_1_map);
t = 0:Te:(length(x)-1)*Te;
plot(t, x)
title("(1) Signal filtré")

figure;

dsp_1 = fftshift(pwelch(x, [], [], [], Fe, 'twosided'));
f=linspace(-Fe/2, Fe/2, length(dsp_1));
%semilogy(f, dsp_1)
%xlabel("fréquence [Hz]")
%ylabel("Densité spectrale de puissance")
%title("(1) Densité spectrale de puissance théorique")

h = ones(1, Ns); 

filtered = filter(h, 1, signal_1_map)

P = (mean(abs(filtered).^2)
M = 2^n
Eb = P / Nbits
N0 = Nbits / B

sigma = sqrt(P * Ns) / (2 * log2(M) * (Eb / N0)))

bruit = sigma * randn(1, length(filtered))