
% TP2 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : Le Bihan, Puy
% Prenom : Ewen, Florent
% Groupe : 1SN-F

function varargout = fonctions_TP2_proba(nom_fonction,varargin)

    switch nom_fonction
        case 'calcul_histogramme_image'
            [varargout{1},varargout{2},varargout{3}] = calcul_histogramme_image(varargin{:});
        case 'vectorisation_par_colonne'
            [varargout{1},varargout{2}] = vectorisation_par_colonne(varargin{:});
        case 'calcul_parametres_correlation'
            [varargout{1},varargout{2},varargout{3}] = calcul_parametres_correlation(varargin{:});
        case 'decorrelation_colonnes'
            varargout{1} = decorrelation_colonnes(varargin{:});
        case 'encodage_image'
            varargout{1} = encodage_image(varargin{:});
        case 'coeff_compression'
            varargout{1} = coeff_compression(varargin{:});
        case 'gain_compression'
            varargout{1} = gain_compression(varargin{:});
    end

end

% Fonction calcul_histogramme_image (exercice_1.m) ------------------------
function [histogramme, I_min, I_max] = calcul_histogramme_image(I)
    I_min = min(min(I));
    I_max = max(max(I));
    histogramme = histcounts(I(:), I_min:I_max+1);
end

% Fonction vectorisation_par_colonne (exercice_1.m) -----------------------
function [Vg,Vd] = vectorisation_par_colonne(I)
    gauche=I(:, 1:end-1);
    droite=I(:, 2:end);
    Vg=gauche(:);
    Vd=droite(:);
end

% Fonction calcul_parametres_correlation (exercice_1.m) -------------------
function [r,a,b] = calcul_parametres_correlation(Vd,Vg)
    a=Vg\Vd;
    c=cov(Vg,Vd);
    r=c(1, 2)/(std(Vd)*std(Vg));
    xb=mean(Vd);
    yb=mean(Vg);
    b=yb-xb*c(1,2)/(std(Vd)^2);
end

% Fonction decorrelation_colonnes (exercice_2.m) --------------------------
function I_decorrelee = decorrelation_colonnes(I)
    I_decorrelee=I-[zeros(size(I,1), 1),I(:,1:end-1)];
end

% Fonction encodage_image (exercice_3.m) ----------------------------------
function I_encodee = encodage_image(I)
    [histogramme, I_min, I_max] = calcul_histogramme_image(I);
    frequences = histogramme/max(max(histogramme));
    vecteur_min_a_max = I_min:I_max;
    I_encodee = huffman_encodage(I(:), huffman_dictionnaire(vecteur_min_a_max, frequences));
end

% Fonction coeff_compression (exercice_3.m) -------------------------------
function coeff_comp = coeff_compression(signal_non_encode,signal_encode) 
    coeff_comp = 8*length(signal_non_encode) / length(signal_encode) 
end

% Fonction coeff_compression (exercice_3.m) -------------------------------
function gain_comp = gain_compression(coeff_comp_avant,coeff_comp_apres)



end

