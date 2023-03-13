%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% cgs.m
%--------------------------------------------------------------------------

function Q = cgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    % Normalisation du premier vecteur
    Q(:, 1) = Q(:, 1) / norm(Q(:, 1))

    % Orthonormalisation des suivants
    for i=2:m
        for j=1:i
            Q(:, i) = Q(:, i) - A(:, i)' * Q(:, j) * Q(:, j)
        end
        %Q(:, i) = Q(:, i) - sum(repmat(A(:, i)', i, 1) * Q(:, 1:i) * Q(:, 1:i))
        Q(:, i) = Q(:, i) / norm(Q(:, i))
    end
end