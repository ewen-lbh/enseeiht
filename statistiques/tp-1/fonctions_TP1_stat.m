
% TP1 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom :
% Prénom : 
% Groupe : 1SN-

function varargout = fonctions_TP1_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'tirages_aleatoires_uniformes'
            varargout{1} = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_Dyx_MV'
            [varargout{1},varargout{2}] = estimation_Dyx_MV(varargin{:});
        case 'estimation_Dyx_MC'
            [varargout{1},varargout{2}] = estimation_Dyx_MC(varargin{:});
        case 'estimation_Dorth_MV'
            [varargout{1},varargout{2}] = estimation_Dorth_MV(varargin{:});
        case 'estimation_Dorth_MC'
            [varargout{1},varargout{2}] = estimation_Dorth_MC(varargin{:});
    end

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)
     
   x_G = mean(x_donnees_bruitees);
   y_G = mean(y_donnees_bruitees);
   x_donnees_bruitees_centrees = x_donnees_bruitees - x_G;
   y_donnees_bruitees_centrees = y_donnees_bruitees - y_G;
end

% Fonction tirages_aleatoires (exercice_1.m) ------------------------------
function tirages_angles = tirages_aleatoires_uniformes(n_tirages)
    tirages_angles = -pi/2 + rand(n_tirages, 1) .* (pi/2);
end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)
        
        [x_G, y_G, x_centres, y_centres] = centrage_des_donnees(x_donnees_bruitees, y_donnees_bruitees);
        
        phi_fois_x = tan(tirages_psi) * x_centres;
        residus = repmat(y_centres, size(phi_fois_x, 1), 1) - phi_fois_x;
        
        [~, indice_minimum] = min(sum(residus.^2, 2));
        
        a_Dyx = tan(tirages_psi(indice_minimum));
        b_Dyx = y_G - a_Dyx * x_G;
end

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
           A = [x_donnees_bruitees; ones(1, length(x_donnees_bruitees))]';
           B = y_donnees_bruitees';
           solution = A\B;
           a_Dyx = solution(1)
           b_Dyx = solution(2)
end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_theta)

                 
        [x_G, y_G, x_centres, y_centres] = centrage_des_donnees(x_donnees_bruitees, y_donnees_bruitees);
        
        residus = cos(tirages_theta) * x_centres + sin(tirages_theta) * y_centres;
        
        [~, indice_minimum] = min(sum(residus.^2, 2));
        
        theta_Dorth = tirages_theta(indice_minimum);
        rho_Dorth = x_G * cos(theta_Dorth) + y_G * sin(theta_Dorth)
end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)
           A = [x_donnees_bruitees; ones(1, length(x_donnees_bruitees))]';
           B = y_donnees_bruitees';
           solution = A\B;
           a_Dyx = solution(1)
           b_Dyx = solution(2)

end
