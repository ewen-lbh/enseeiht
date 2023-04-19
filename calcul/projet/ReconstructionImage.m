%%  Application de la SVD : compression d'images
 
close all

% Lecture de l'image
I = imread('BD_Asterix_Colored.jpg');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(200+40);
inter(end) = 200;
differenceSVD = zeros(size(inter,2), 1);

% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;

    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
end

figure(ti)
colormap('gray')
imagesc(Im_k)

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause

%}
% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;

% taille de l'espace de recherche (m)
search_space = 400;

% pourcentage que l'on se fixe
percentage = 0.995;

% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%


%%eig

VP(I,eps,maxit,search_space,percentage,puiss,"eig")
%VP(I,eps,maxit,search_space,percentage,puiss,"power method")
VP(I,eps,maxit,search_space,percentage,puiss,"sub_space_0")
VP(I,eps,maxit,search_space,percentage,puiss,"sub_space_1")
VP(I,eps,maxit,search_space,percentage,puiss,"sub_space_2")
VP(I,eps,maxit,search_space,percentage,puiss,"sub_space_3")

%%Couleurs

I=imread('minirgb.jpg');
%imshow(I)
Im_final = zeros(size(I));
I=double(I);

[q,p]=size(I);
size(I)
taillechoisi=1
for color=1:3

M=I(:,:,color)*I(:,:,color)';
[q, p] = size(I(:,:,color))
[U,D]=eig(M);
D=diag(D);
[D,perm]=sort(D,'descend');
U=U(:,perm);
D_200 = D(1:taillechoisi);
U_200 = U(:, 1:taillechoisi);
% calcul des valeurs singulières
Sigma200 = sqrt(D_200);
Sigma200 = diag(Sigma200);
% calcul de l'autre ensemble de vecteurs
V_200 = zeros(p,taillechoisi);
tic
for i=1:taillechoisi
V_200(:,i) = (1/Sigma200(i,i))*(I(:,:,color)'*U_200(:,i));
end
toc
size(U_200)
size(V_200)
% calcul des meilleures approximations de rang faible
% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(taillechoisi+40);
inter(end) = taillechoisi;
differenceSVD = zeros(size(inter,2), 1);

ti = 0;
Im_k = zeros(q,p);
Im_k = U_200(:, 1:taillechoisi)*Sigma200(1:taillechoisi, 1:taillechoisi)*V_200(:, 1:taillechoisi)';
if color == 1
    Im_red = Im_k;
elseif color == 2
    Im_green = Im_k;
else
    Im_blue = Im_k;
end
Im_final(:,:,color) = Im_k;
colormap('gray')
imagesc(Im_k)

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause

end

figure(1)


Im_final= cat(3,Im_red,Im_green,Im_blue);
%subplot red green blue final (4 images)
subplot(2,2,1)
colormap('gray')
imagesc(Im_red)
subplot(2,2,2)
imagesc(Im_green)
subplot(2,2,3)
imagesc(Im_blue)
subplot(2,2,4)
imshow(Im_final)