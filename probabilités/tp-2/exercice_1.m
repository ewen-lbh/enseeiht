clear;
close all;
clc; 

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture d'une image interne a Matlab et conversion en doubles :
I = rgb2gray(imread('autumn.tif'));
I = double(I);

% Affichage de l'image :
figure('Position',[0.1*L,0.05*H,0.8*L,0.7*H]);
subplot(2,2,1)
    imagesc(I);
    axis image off;
    colormap gray;
    set(gca,'FontSize',20);
    title('Exemple d''image interne a Matlab')

% Affichage de l'histogramme de l'image :
[histogramme, I_min, I_max] = fonctions_TP2_proba('calcul_histogramme_image',I);
subplot(2,2,3)
    plot(I_min:I_max,histogramme,'r');
    axis([0 255 0 1.1*max(histogramme)]);
    xlabel('Niveau de gris','FontSize',15);
    ylabel('Frequence','FontSize',15);
    set(gca,'FontSize',20);
    title('Histogramme des niveaux de gris')

% Calcul de vecteurs contenant les niveaux de gris de gauche (de droite) d'une paire de pixels :
[Vd,Vg] = fonctions_TP2_proba('vectorisation_par_colonne',I);

% Affichage des paires de niveaux de gris sous la forme d'un nuage de points :
subplot(1,2,2)
    plot(Vd,Vg,'b+');
    axis([0 255 0 255]);
    xlabel('Niveau de gris du pixel de droite','FontSize',15);
    ylabel('Niveau de gris du pixel de gauche','FontSize',15);
    hold on;
    set(gca,'FontSize',20);
    axis equal;
    title('Mise en evidence de la correlation entre pixels voisins')

% Calcul des parametres de la droite de regression :
[r,a,b] = fonctions_TP2_proba('calcul_parametres_correlation',Vd,Vg);
fprintf('Coefficient de correlation lineaire : %.4f\n',r);

% Affichage de la droite de regression (d'equation y = a*x+b) :
x = 0:255;
y = a*x+b;
plot(x,y,'r','LineWidth',3);
