function VP(I,eps,maxit,search_space,percentage,puiss,method)
    M=I*I';
    [q, p] = size(I)
    %case 
    switch method
    case "eig" 
        [U,D]=eig(M);
    case "power method"
        [U,D]=power_v12(M,search_space,percentage,eps,maxit);
    case "sub_space_0"
        [U,D]=subspace_iter_v0(M,search_space,eps,maxit);
    case "sub_space_1"
        [U,D]=subspace_iter_v1(M,search_space,percentage,eps,maxit);
    case "sub_space_2"
        [U,D]=subspace_iter_v2(M,search_space,percentage,puiss,eps,maxit);
    case "sub_space_3"
        [U,D]=subspace_iter_v3(M,search_space,percentage,puiss,eps,maxit);
    end
    D=diag(D);
    if strcmp(method,"eig")
        
        [D,perm]=sort(D,'descend');
        U=U(:,perm);
    end
    

    size(U)


D_200 = D(1:200);
U_200 = U(:, 1:200);
% calcul des valeurs singulières
Sigma200 = sqrt(D_200);
Sigma200 = diag(Sigma200);
% calcul de l'autre ensemble de vecteurs
V_200 = zeros(p,200);
tic
for i=1:200
    V_200(:,i) = (1/Sigma200(i,i))*(I'*U_200(:,i));
end
toc
size(U_200)
size(V_200)
% calcul des meilleures approximations de rang faible
% vecteur pour stocker la différence entre l'image et l'image reconstuite
    inter = 1:40:(200+40);
    inter(end) = 200;
    differenceSVD = zeros(size(inter,2), 1);
    
    ti = 0;
    td = 0;
    for k = inter
        Im_k = U_200(:, 1:k)*Sigma200(1:k, 1:k)*V_200(:, 1:k)';
        ti = ti+1;
    
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
    