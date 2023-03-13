%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% mgs.m
%--------------------------------------------------------------------------

function Q = mgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    % On normalise le premier vecteur
    Q(:, 1) = Q(:, 1) / norm(Q(:, 1))

    % On orthonormalise les vecteurs suivants
    for i = 2:m
        y = A(:,i)
        for j = 1:(i-1)
            y = y - (y' * Q(:, j))  * Q(:, j)
        end
        Q(:, i) = y/norm(y)
    end
end