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
tebs = zeros(0, length(Eb_N0_dB))

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
    tebs_theorique(index) = qfunc(sqrt(2 .* Eb_N0_lineaire(index)));
    tebs(index) = length(find((unmapped ~= bits_non_map)))/length(bits_non_map)
end


figure
semilogy(Eb_N0_dB, tebs,'b')
hold on
semilogy(Eb_N0_dB, tebs_theorique,'r')


tebs = zeros(0, length(Eb_N0_dB))

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
    tebs_theorique(index) = qfunc(sqrt(Eb_N0_lineaire(index)));
    tebs(index) = length(find((unmapped ~= bits_non_map)))/length(bits_non_map)
end


figure
semilogy(Eb_N0_dB, tebs,'b')
hold on
semilogy(Eb_N0_dB, tebs_theorique,'r')
