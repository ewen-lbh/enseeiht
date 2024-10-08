close all
clear all

N = 100;
Fe = 10000;
Te = 1/Fe;
t = 0:Te:(N-1)*Te;

x_1 = cos(2*pi*1000*t);
x_2 = cos(2*pi*3000*t);

x = x_1 + x_2;

figure; plot(t, x)
X = fftshift(fft(x, 4096));
f = linspace(-Fe/2, Fe/2, 4096);
figure; semilogy(f, abs(X))

% /!\ matlab's sinc (x) = math's sinc (pi x) /!\ %

fc = (1000 + 3000) / 2
ordre_1 = 11;
t_ordre_1 = -(ordre_1 - 1) / 2 * Te : Te : (ordre_1 - 1)/2 * Te
h_1 = 2 * fc * sinc(2* fc* t_ordre_1) % TF inverse(porte largeur 2fc ie filtre passe bas coupure à fc)


ordre_2 = 61;
t_ordre_2 = -(ordre_2 - 1) / 2 * Te : Te : (ordre_2 - 1)/2 * Te
h_2 = 2 * fc * sinc(2* fc* t_ordre_2) % TF inverse(porte largeur 2fc ie filtre passe bas coupure à fc)

H_1 = fftshift(fft(h_1, 4096))
H_2 = fftshift(fft(h_2, 4096))
f = linspace(-Fe/2, Fe/2, 4096)

figure;
subplot(2,2,1)
plot(h_1)
subplot(2,2,2)
plot(h_2)
subplot(2, 2, 3)
semilogy(f, H_1)
subplot(2, 2, 4)
semilogy(f, H_2)


