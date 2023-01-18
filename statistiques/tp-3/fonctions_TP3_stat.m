
% TP3 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Le Bihan
% Prenom : Ewen
% Groupe : 1SN-F

function varargout = fonctions_TP3_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'estimation_F'
            [varargout{1},varargout{2},varargout{3}] = estimation_F(varargin{:});
        case 'choix_indices_points'
            [varargout{1}] = choix_indices_points(varargin{:});
        case 'RANSAC_2'
            [varargout{1},varargout{2}] = RANSAC_2(varargin{:});
        case 'G_et_R_moyen'
            [varargout{1},varargout{2},varargout{3}] = G_et_R_moyen(varargin{:});
        case 'estimation_C_et_R'
            [varargout{1},varargout{2},varargout{3}] = estimation_C_et_R(varargin{:});
        case 'RANSAC_3'
            [varargout{1},varargout{2}] = RANSAC_3(varargin{:});
    end

end

% Fonction estimation_F (exercice_1.m) ------------------------------------
function [rho_F,theta_F,ecart_moyen] = estimation_F(rho,theta)
    X = [cos(theta) sin(theta)] \ rho;
    x_F = X(1);
    y_F = X(2);
    rho_F = sqrt(x_F^2 + y_F^2);
    theta_F = atan2(y_F, x_F);
    ecart_moyen = length(rho) * sum(rho - rho_F* cos(theta - repmat(theta_F, length(theta),1)));
end

% Fonction choix_indice_elements (exercice_2.m) ---------------------------
function tableau_indices_points_choisis = choix_indices_points(k_max,n,n_indices)
    % tableau_indices_points_choisis = zeros(k_max, n_indices);
    for j = 1 : k_max
        tableau_indices_points_choisis(:, j) = randperm(n, n_indices);
    end
end

% Fonction RANSAC_2 (exercice_2.m) ----------------------------------------
function [rho_F_estime,theta_F_estime] = RANSAC_2(rho,theta,parametres,tableau_indices_2droites_choisies)
    ecart_min = Inf;

    k_max = parametres(3);
    s_1 = parametres(1);
    s_2 = parametres(2);

    for i = 1 : k_max
        indices = tableau_indices_2droites_choisies(:, i);

        [rho_F,theta_F,ecart_moyen] = estimation_F(rho(indices), theta(indices));
        
        conformes_ou_pas = s_1 > abs(rho - rho_F * cos(theta - repmat(theta_F, length(theta),1)));
        proportion_donnees_conformes = sum(conformes_ou_pas) / length(tableau_indices_2droites_choisies);
        
        if proportion_donnees_conformes > s_2
            [rho_F_2,theta_F_2, ecart_moyen_2] = estimation_F(rho(conformes_ou_pas),theta(conformes_ou_pas));
        
            if ecart_moyen_2 < ecart_min
                ecart_min = ecart_moyen_2;
                rho_F_estime = rho_F_2;
                theta_F_estime = theta_F_2;
            end
        end
    end
end

% Fonction G_et_R_moyen (exercice_3.m, bonus, fonction du TP1) ------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)



end

% Fonction estimation_C_et_R (exercice_3.m, bonus, fonction du TP1) -------
function [C_estime,R_estime,critere] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,n_tests,C_tests,R_tests)
     


end

% Fonction RANSAC_3 (exercice_3, bonus) -----------------------------------
function [C_estime,R_estime] = ...
         RANSAC_3(x_donnees_bruitees,y_donnees_bruitees,parametres,tableau_indices_3points_choisis)
     


end
