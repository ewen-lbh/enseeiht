-- D�finition de structures de donn�es associatives sous forme d'une liste
-- cha�n�e associative (LCA).
generic
	type T_Cle is private;
	type T_Ip is private;
	type T_Masque is private;
	type T_Eth is private;

package LCA is

	--  type T_LCA is limited private;

	type T_Cellule;

	type T_LCA is access T_Cellule;
	-- Initialiser une Sda.  La Sda est vide.
	procedure Initialiser(Sda: out T_LCA) with
		Post => Est_Vide (Sda);


	-- Est-ce qu'une Sda est vide ?
	function Est_Vide (Sda : T_LCA) return Boolean;


	-- Obtenir le nombre d'�l�ments d'une Sda. 
	function Taille (Sda : in T_LCA) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);


	-- Enregistrer une Donn�e associ�e � une Cl� dans une Sda.
	-- Si la cl� est d�j� pr�sente dans la Sda, sa donn�e est chang�e.
	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Ip : in T_Ip; Masque: in T_Masque; Eth: in T_Eth) with
		Post => Cle_Presente (Sda, Cle)   -- donn�e ins�r�e
				and (not (Cle_Presente (Sda, Cle)'Old) or Taille (Sda) = Taille (Sda)'Old)
				and (Cle_Presente (Sda, Cle)'Old or Taille (Sda) = Taille (Sda)'Old + 1);

	-- Supprimer la Donn�e associ�e � une Cl� dans une Sda.
	-- Exception : Cle_Absente_Exception si Cl� n'est pas utilis�e dans la Sda
	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1 -- un �l�ment de moins
			and not Cle_Presente (Sda, Cle);         -- la cl� a �t� supprim�e


	-- Savoir si une Cl� est pr�sente dans une Sda.
	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean;
   
   function L_ip(T: in T_LCA) return T_Ip;

   function Le_Masque(T: in T_LCA) return T_Masque;

   function L_interface(T: in T_LCA) return T_Eth;

   function Le_suivant(T: in T_LCA) return T_LCA;
	


	-- Obtenir la donn�e associ�e � une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Cl� n'est pas utilis�e dans l'Sda
	procedure La_Donnee (Sda : in T_LCA ; Cle : in T_Cle; Ip: out T_Ip; Masque: out T_Masque; Eth: out T_Eth);


	-- Supprimer tous les �l�ments d'une Sda.
	procedure Vider (Sda : in out T_LCA) with
		Post => Est_Vide (Sda);


	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traiter (Cle : in T_Cle; Ip: in T_Ip; Masque: in T_Masque; Eth: in T_Eth);
	procedure Pour_Chaque (Sda : in T_LCA);


--  private

	type T_Cellule is
		record
			Cle : T_Cle;
			Ip : T_Ip;
			Masque: T_Masque;
			Eth: T_Eth;
			Suivant : T_LCA;
		end record;

end LCA;
