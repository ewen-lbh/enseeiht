% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Le Bihan
% Prénom : Ewen
% Groupe : 1SN-F

function varargout = fonctions_TP2_stat(nom_fonction, varargin)

    switch nom_fonction
        case 'tirages_aleatoires_uniformes'
            [varargout{1}, varargout{2}] = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_Dyx_MV'
            [varargout{1}, varargout{2}] = estimation_Dyx_MV(varargin{:});
        case 'estimation_Dyx_MC'
            [varargout{1}, varargout{2}] = estimation_Dyx_MC(varargin{:});
        case 'estimation_Dyx_MV_2droites'
            [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = estimation_Dyx_MV_2droites(varargin{:});
        case 'probabilites_classe'
            [varargout{1}, varargout{2}] = probabilites_classe(varargin{:});
        case 'classification_points'
            [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = classification_points(varargin{:});
        case 'estimation_Dyx_MCP'
            [varargout{1}, varargout{2}] = estimation_Dyx_MCP(varargin{:});
        case 'iteration_estimation_Dyx_EM'
            [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}] = ...
                iteration_estimation_Dyx_EM(varargin{:});
    end

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
    centrage_des_donnees(x_donnees_bruitees, y_donnees_bruitees)

    x_G = mean(x_donnees_bruitees);
    y_G = mean(y_donnees_bruitees);
    x_donnees_bruitees_centrees = x_donnees_bruitees - x_G;
    y_donnees_bruitees_centrees = y_donnees_bruitees - y_G;

end

% Fonction tirages_aleatoires (exercice_1.m) ------------------------------
function [tirages_angles, tirages_G] = tirages_aleatoires_uniformes(n_tirages, taille)
    tirages_angles = -pi / 2 + rand(n_tirages, 1) .* (pi / 2);
    tirages_G = -taille + rand(n_tirages, 2) * taille;

end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx, b_Dyx] = ...
    estimation_Dyx_MV(x_donnees_bruitees, y_donnees_bruitees, tirages_psi)

    [x_G, y_G, x_centres, y_centres] = centrage_des_donnees(x_donnees_bruitees, y_donnees_bruitees);

    residus = y_centres - tan(tirages_psi) * x_centres;

    [~, indice_minimum] = min(sum(residus .^ 2, 2));

    a_Dyx = tan(tirages_psi(indice_minimum));
    b_Dyx = y_G - a_Dyx * x_G;

end

% Fonction estimation_Dyx_MC (exercice_1.m) -------------------------------
function [a_Dyx, b_Dyx] = ...
    estimation_Dyx_MC(x_donnees_bruitees, y_donnees_bruitees)
    %A = [x_donnees_bruitees; ones(1, length(x_donnees_bruitees))]';
    %B = y_donnees_bruitees';
    A = transpose(cat(1, x_donnees_bruitees, ones(1, size(x_donnees_bruitees, 2))));
    B = transpose(y_donnees_bruitees);
    solution = (inv(transpose(A) * A)) * transpose(A) * B;
    a_Dyx = solution(1);
    b_Dyx = solution(2);

end

% Fonction estimation_Dyx_MV_2droites (exercice_2.m) -----------------------------------
function [a_Dyx_1, b_Dyx_1, a_Dyx_2, b_Dyx_2] = ...
    estimation_Dyx_MV_2droites(x_donnees_bruitees, y_donnees_bruitees, sigma, ...
        tirages_G_1, tirages_psi_1, tirages_G_2, tirages_psi_2)

    n_tirages = length(tirages_G_1);
    n_points = length(x_donnees_bruitees);

    X_i = repmat(x_donnees_bruitees, n_tirages, 1);
    Y_i = repmat(y_donnees_bruitees, n_tirages, 1);
    G_1_X = repmat(tirages_G_1(:, 1), 1, n_points);
    G_1_Y = repmat(tirages_G_1(:, 2), 1, n_points);
    G_2_X = repmat(tirages_G_2(:, 1), 1, n_points);
    G_2_Y = repmat(tirages_G_2(:, 2), 1, n_points);
    PSI_1 = repmat(tirages_psi_1, 1, n_points);
    PSI_2 = repmat(tirages_psi_2, 1, n_points);

    residus_1 = (Y_i - G_1_Y) - tan(PSI_1) .* (X_i - G_1_X);
    residus_2 = (Y_i - G_2_Y) - tan(PSI_2) .* (X_i - G_2_X);

    log_vraisemblance = log(exp(- (residus_2 .^ 2) / (2 * sigma ^ 2)) + exp(- (residus_1 .^ 2) / (2 * sigma ^ 2)));

    [~, indice_max] = max(sum(log_vraisemblance, 2));

    a_Dyx_1 = tan(tirages_psi_1(indice_max));
    a_Dyx_2 = tan(tirages_psi_2(indice_max));

    b_Dyx_1 = tirages_G_1(indice_max, 2) - a_Dyx_1 * tirages_G_1(indice_max, 1);
    b_Dyx_2 = tirages_G_2(indice_max, 2) - a_Dyx_1 * tirages_G_2(indice_max, 1);
end

% Fonction probabilites_classe (exercice_3.m) ------------------------------------------
function [probas_classe_1, probas_classe_2] = probabilites_classe(x_donnees_bruitees, y_donnees_bruitees, sigma, ...
    a_1, b_1, proportion_1, a_2, b_2, proportion_2)

    residus_1 = y_donnees_bruitees - (a_1 * x_donnees_bruitees + b_1);
    residus_2 = y_donnees_bruitees - (a_2 * x_donnees_bruitees + b_2);

    probas_classe_1_before = proportion_1 * exp(- (residus_1 .^ 2) / (2 * sigma ^ 2));
    probas_classe_2_before = proportion_2 * exp(- (residus_2 .^ 2) / (2 * sigma ^ 2));
    somme = probas_classe_1_before + probas_classe_2_before;

    probas_classe_1 = probas_classe_1_before ./ somme;
    probas_classe_2 = probas_classe_2_before ./ somme;
end

% Fonction classification_points (exercice_3.m) ----------------------------
function [x_classe_1, y_classe_1, x_classe_2, y_classe_2] = classification_points ...
    (x_donnees_bruitees, y_donnees_bruitees, probas_classe_1, probas_classe_2)

    x_classe_1 = x_donnees_bruitees(probas_classe_1 > 0.5);
    y_classe_1 = y_donnees_bruitees(probas_classe_1 > 0.5);
    x_classe_2 = x_donnees_bruitees(probas_classe_2 >= 0.5);
    y_classe_2 = y_donnees_bruitees(probas_classe_2 >= 0.5);
end

% Fonction estimation_Dyx_MCP (exercice_4.m) -------------------------------
function [a_Dyx, b_Dyx] = estimation_Dyx_MCP(x_donnees_bruitees, y_donnees_bruitees, probas_classe)
    B = y_donnees_bruitees .* probas_classe;
    A = [x_donnees_bruitees; ones(1, size(x_donnees_bruitees, 2))] .* probas_classe;
    solution = A' \ B';
    a_Dyx = solution(1);
    b_Dyx = solution(2);
end

% Fonction iteration_estimation_Dyx_EM (exercice_4.m) ---------------------
function [probas_classe_1, proportion_1, a_1, b_1, probas_classe_2, proportion_2, a_2, b_2] = ...
    iteration_estimation_Dyx_EM(x_donnees_bruitees, y_donnees_bruitees, sigma, ...
        proportion_1, a_1, b_1, proportion_2, a_2, b_2)

    % Etape E
    [probas_classe_1, probas_classe_2] = probabilites_classe(x_donnees_bruitees, y_donnees_bruitees, sigma, a_1, b_1, proportion_1, a_2, b_2, proportion_2);

    % Etape M
    proportion_1 = mean(probas_classe_1);
    proportion_2 = mean(probas_classe_2);

    % Estimation de a et b
    [a_1, b_1] = estimation_Dyx_MCP(x_donnees_bruitees, y_donnees_bruitees, probas_classe_1);
    [a_2, b_2] = estimation_Dyx_MCP(x_donnees_bruitees, y_donnees_bruitees, probas_classe_2);
end
