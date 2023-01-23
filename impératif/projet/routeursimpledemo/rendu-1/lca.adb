with Exceptions;         use Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);

	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := null;
	end Initialiser;


	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda = null;
	end;


	function Taille (Sda : in T_LCA) return Integer is

	begin
		if Est_Vide(Sda) then
			return 0;
		else
			return 1 + Taille(Sda.All.Suivant);
		end if;
	end Taille;


	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Ip : in T_Ip; Masque: in T_Masque; Eth: in T_Eth) is
	begin
		if Est_Vide(Sda) then
			Sda := new T_Cellule'(Cle, Ip, Masque, Eth, null);
		else
			if Sda.All.Cle = Cle then
				Sda.All.Ip := Ip;
				Sda.All.Masque := Masque;
				Sda.All.Eth := Eth;
			else
				Enregistrer(Sda.all.Suivant, Cle, Ip, Masque, Eth);
			end if;
		end if;
	end Enregistrer;


	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
	begin
		if Est_Vide(Sda) then
			return false;
		else
			if Sda.All.Cle = Cle then
				return true;
			else
				return Cle_Presente(Sda.All.Suivant, Cle);
			end if;
		end if;
	end;


	procedure La_Donnee (Sda : in T_LCA ; Cle : in T_Cle; Ip: out T_Ip; Masque: out T_Masque; Eth: out T_Eth) is
	begin
		if Est_Vide(Sda) then
			raise Cle_Absente_Exception with "Cle absente pour la donnée";
		else
			if Sda.All.Cle = Cle then
				Ip := Sda.All.Ip;
				Masque := Sda.All.Masque;
				Eth := Sda.All.Eth;
			else
				La_Donnee(Sda.All.Suivant, Cle, Ip, Masque, Eth);
			end if;
		end if;
	end La_Donnee;


	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
        Sda1 : T_LCA;
    begin
		if Est_Vide(Sda) then
			raise Cle_Absente_Exception with "Cle absente pour suppression";
		elsif Sda.All.Cle = Cle then
			Sda1 := Sda;
			Sda := Sda.All.Suivant;
			Free(Sda1);
		else
			Supprimer(Sda.All.Suivant, Cle);
		end if;
    end Supprimer;

	function L_ip(T: in T_LCA) return T_Ip is
		begin
			if not Est_Vide(T) then
				return(T.All.Ip);
			else
				raise Table_Vide_Exception with "Table vide";
         end if;
		end L_ip;

	function Le_Masque(T: in T_LCA) return T_Masque is
		begin
			if not Est_Vide(T) then
				return(T.All.Masque);
			else
				raise Table_Vide_Exception with "Table vide";
			end if;
		end Le_Masque;

	function L_interface(T: in T_LCA) return T_Eth is
		begin
			if not Est_Vide(T) then
				return(T.All.Eth);
			else
				raise Table_Vide_Exception with "Table vide";
			end if;
		end L_interface;
	
	function Le_suivant(T: in T_LCA) return T_LCA is
		begin
			if not Est_Vide(T) then
				return(T.All.Suivant);
			else
				raise Table_Vide_Exception with "Table vide";
			end if;
		end Le_suivant;

	procedure Vider (Sda : in out T_LCA) is
	begin
		if Sda /= null then
			Vider (Sda.All.Suivant);
			Free (Sda);
		end if;
	end Vider;


	procedure Pour_Chaque (Sda : in T_LCA) is
	begin
		if not Est_Vide(Sda) then
			Traiter (Sda.All.Cle, Sda.All.Ip, Sda.All.Masque, Sda.All.Eth);
			Pour_Chaque (Sda.All.Suivant);
		else
			null;
		end if;
		exception
			when others =>
				Pour_Chaque (Sda.All.Suivant);
	end Pour_Chaque;


end LCA;
