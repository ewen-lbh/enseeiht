
% TP3 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom :
% Prénom : 
% Groupe : 1SN-

function varargout = fonctions_TP3_proba(nom_fonction,varargin)

    switch nom_fonction
        case 'ensemble_E_recursif'
            [varargout{1},varargout{2},varargout{3}] = ensemble_E_recursif(varargin{:});
        case 'matrice_inertie'
            [varargout{1},varargout{2}] = matrice_inertie(varargin{:});
        case 'calcul_proba'
            [varargout{1},varargout{2},varargout{3}] = calcul_proba(varargin{:});
    end
    
end

% Fonction ensemble_E_recursif (exercie_1.m) ------------------------------
function [E,contour,G_somme] = ...
    ensemble_E_recursif(E,contour,G_somme,i,j,voisins,G_x,G_y,card_max,cos_alpha,itdpth)
    % Mise à 0 de la valeur contour du pixel courant pour ne pas retourner dessus
    contour(i,j) = 0;
    % Nombre de voisins (ici 8)
    nb_voisins = size(voisins,1);
    % Initialisation du comptage des 8 voisins a parcourir
    k = 1;
    % Parcours des differents voisins si E n'est pas deja trop grand
    while length(E) <= card_max && k <= nb_voisins && (1 < i) && (i < size(G_x, 1)) && (1 < j) && (j < size(G_x, 2))
        i_voisin = i+voisins(k, 1);
        j_voisin = j+voisins(k, 2);
        if contour(i_voisin, j_voisin)
            voisin = [G_x(i_voisin, j_voisin) G_y(i_voisin, j_voisin)];
            if (voisin / norm(voisin)) * (G_somme / norm(G_somme))' > cos_alpha
                E = [E; i_voisin j_voisin];
                G_somme = G_somme + voisin;
                [E, contour, G_somme] = ensemble_E_recursif( ...
                    E, contour, G_somme, ...
                    i_voisin, j_voisin, ...
                    voisins, G_x, G_y, card_max, cos_alpha, itdpth+1 ...
                );
            end
        end
        k=k+1;
    end

end

% Fonction matrice_inertie (exercice_2.m) ---------------------------------
function [M_inertie,C] = matrice_inertie(E,G_norme_E) 
    Pi = sum(G_norme_E);
    x_bar = 1/Pi * sum(G_norme_E .* E(:, 2));
    y_bar = 1/Pi * sum(G_norme_E .* E(:, 1));
    m_11 = 1/Pi * sum(G_norme_E .* (E(:, 2) - x_bar).^2);
    m_12 = 1/Pi * sum(G_norme_E .* (E(:, 2) - x_bar).*(E(:, 1) - y_bar));
    m_22 = 1/Pi * sum(G_norme_E .* (E(:, 1) - y_bar).^2);
    M_inertie = [m_11 m_12 ; m_12 m_22];
    C = [x_bar y_bar];
end

% Fonction calcul_proba (exercice_2.m) ------------------------------------
function [x_min,x_max,probabilite] = calcul_proba(E_nouveau_repere,p)
    x_min = min(E_nouveau_repere(:, 1));
    x_max = max(E_nouveau_repere(:, 1));
    y_min = min(E_nouveau_repere(:, 2));
    y_max = max(E_nouveau_repere(:, 2));
    probabilite = 1 - sum(binocdf(0:x_max-x_min-1, (y_max-y_min)*(x_max-x_min), p));
end
