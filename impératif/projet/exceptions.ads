-- Définition d'exceptions commune à toutes les SDA.
package Exceptions is

	Cle_Absente_Exception  : Exception;	-- une clé est absente d'un SDA
	Borne_inf_1_Exception : Exception; -- Borne inférieur à 1
	Taille_inf_1_Exception : Exception; -- Taille inférieur à 1
	Table_Vide_Exception : Exception; -- Table vide
	Table_Fichier_Incorrect_Exception : Exception; -- Table fichier incorrect

end Exceptions;
