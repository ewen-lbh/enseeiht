% PARTIE 2
clear all;
close all;

n=1;

Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

Ts = n*Tb;
Nbits = 500;
Ns = floor(Ts/Te);

bits_non_map = randi([0, 1], 1, Nbits); %Nbits
bits_non_map2 = randi([0, 1], 1, 15*Nbits);

signal_1 = 2*bits_non_map - ones(1, length(bits_non_map));
signal_1_map = kron(signal_1, [1 zeros(1, Ns-1)]);
f = linspace(-Te/2, Te/2, Ns);
h = ones(1, Ns); 


figure;
plot(signal_1_map)
xlabel("temps [s]")
ylabel("m_i(t)")
title("Signal aléatoire")

figure;
%x=filter(signal_1, 1, ones(1,Ns));
x=filter(h,1 , signal_1_map);
t = 0:Te:(length(x)-1)*Te;
plot(t, x)
title("Signal filtré")

bw = 8000;
H = fft(h, 4096)
ordre = 131
h_c = 2*(bw/Fe) * sinc(2*(bw/Fe) * -(ordre-1)/2:(ordre-1)/2);
H_c = fft(h_c, 4096)
h_r = h
H_r = fft(h_r, 4096)

unfiltered = filter(conv(h_c, h_r), 1, x);
figure(888);
plot(unfiltered)
title("Signal défiltré")

n_0 = 8; % TEB = 0.472 pour n_0 = 3
unfiltered_ech = unfiltered(n_0:Ns:end);



g=conv(h,conv(h_c,h_r));
figure (444)

plot(g)
title("Réponse impultionnelle filtre")

unmapped = (sign(unfiltered_ech)+1)/2;

figure;
plot(unmapped)
title("Signal démapé")
axis([ 0 10 -1 1.5 ])

g=conv(h,h);

figure;
abs_h_hr = abs(fftshift(H .* H_r))
f = linspace(-Fe/2, Fe/2, 4096)
plot(f, abs_h_hr / max(abs_h_hr))
hold on
abs_hc = abs(fftshift(H_c))
plot(f, abs_hc / max(abs_hc))
hold off
legend("|H . H_r|", "|H_c|")
title("Réponses fréquentielles")

teb = length(find((unmapped - bits_non_map ~= 0)))/length(bits_non_map)

oeil = reshape(unfiltered, Ns, length(unfiltered)/Ns);

figure;
plot(oeil)