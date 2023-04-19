function VP(I,eps,maxit,search_space,percentage,puiss,method,U, S, V)
    M=I*I';
    %case 
    switch method
    case "eig" 
        [V,D]=eig(M);
    case "power method"
        [V,D]=power_v12(M,search_space,percentage,eps,maxit);
    case "sub_space_0"
        [V,D]=subspace_iter_v0(M,search_space,eps,maxit);
    case "sub_space_1"
        [V,D]=subspace_iter_v1(M,search_space,percentage,eps,maxit);
    case "sub_space_2"
        [V,D]=subspace_iter_v2(M,search_space,percentage,puiss,eps,maxit);
    case "sub_space_3"
        [V,D]=subspace_iter_v3(M,search_space,percentage,puiss,eps,maxit);
    end
    D=diag(D);
    [D,perm]=sort(D,'descend');
    D=diag(D);
    V=V(:,perm);
    %%
    % calcul des valeurs singulières
    %%
    Sigma200=sqrt(D(1:200,1:200));
    U_200=U(:,1:200);
    %%
    % calcul de l'autre ensemble de vecteurs
    %%
    for i=1:200
        V_200(:,i)=(I'*U_200(:,i))/(Sigma200(i,i));
    end
    toc
    
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
    