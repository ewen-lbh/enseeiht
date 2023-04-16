for imat = 1:4
    [A, ~, ~] = matgen_csad(imat,200);
    [~, values] = eig(A, 'vector');
    
    plot(values)
    title(sprintf("Type %d: Distribution des valeurs propres", imat))
    saveas(gcf, sprintf("distribution_type_%d.png", imat))
end