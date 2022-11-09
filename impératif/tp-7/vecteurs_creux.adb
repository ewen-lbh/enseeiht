with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Ada.Unchecked_Deallocation;

package body Vecteurs_Creux is

	--  procedure Afficher(V: in T_Vecteur_Creux) is 
	--  	element: T_Vecteur_Creux;
	--  begin
	--  	Put("[ ");
	--  	while element.Suivant /= Null loop
	--  		Put(element.Valeur);
	--  		Put("@");
	--  		Put(element.Indice);
	--  		Put(" ");
	--  	end loop;
	--  	Put("]");
	--  end Afficher;

    procedure Free is new Ada.Unchecked_Deallocation
       (T_Cellule, T_Vecteur_Creux);

    procedure Initialiser (V : out T_Vecteur_Creux) is
    begin
        V := null;
    end Initialiser;

    procedure Detruire (V : in out T_Vecteur_Creux) is
    begin
        Free (V);
    end Detruire;

    function Est_Nul (V : in T_Vecteur_Creux) return Boolean is
    begin
        return V = null;
    end Est_Nul;

    function Composante_Iteratif
       (V : in T_Vecteur_Creux; Indice : in Integer) return Float
    is
        Cellule : T_Vecteur_Creux;
    begin
        Cellule := V;
        while Indice > Cellule.Indice loop
			if Cellule.Suivant = Null then
				return 0.0;
			end if;
            Cellule := Cellule.Suivant;
        end loop;
        return Cellule.Valeur;
    end Composante_Iteratif;

    function Composante_Recursif
       (V : in T_Vecteur_Creux; Indice : in Integer) return Float
    is
    begin
        if Indice > V.Indice then
			if V.Suivant = Null then return 0.0; end if;
            return Composante_Recursif (V.Suivant, Indice);
        end if;
        return V.Valeur;
    end Composante_Recursif;

    procedure Modifier
       (V : in out T_Vecteur_Creux; Indice : in Integer; Valeur : in Float)
    is
		new_V : T_Vecteur_Creux;
    begin
		Afficher(V);
		Put_Line("");
		-- créer
		if V = null then
			V := new T_Cellule;
			V.all := (Indice => Indice, Valeur => Valeur, Suivant => null);
		-- modifier
		elsif V.Indice = Indice then
			V.all.Valeur := Valeur;
		-- insérer à la fin
		elsif V.Suivant = null and V.Indice < Indice then
			V.all.Suivant := new_v;
		-- insérer au début
		elsif V.Suivant = null and V.Indice > Indice then
			new_v := new T_Cellule;
			new_v.all := (Indice => V.Indice, Valeur => V.Valeur, Suivant => null);
			V.all.Indice := Indice;
			V.all.Valeur := Valeur;
			V.all.Suivant := new_v;
		-- insertion au milieu
		elsif V.Suivant.Indice > Indice and V.Indice < Indice then
			new_v := new T_Cellule;
			new_v.all := (Indice => Indice, Valeur => Valeur, Suivant => V.Suivant);
			V.Suivant := new_v;
		-- on continue
		else	
			Modifier(V.Suivant, Indice => Indice, Valeur => Valeur);
		end if;
    end Modifier;

    function Sont_Egaux_Recursif (V1, V2 : in T_Vecteur_Creux) return Boolean
    is
    begin
        return False;   -- TODO : à changer
    end Sont_Egaux_Recursif;

    function Sont_Egaux_Iteratif (V1, V2 : in T_Vecteur_Creux) return Boolean
    is
    begin
        return False;   -- TODO : à changer
    end Sont_Egaux_Iteratif;

    procedure Additionner
       (V1 : in out T_Vecteur_Creux; V2 : in T_Vecteur_Creux)
    is
    begin
        null;   -- TODO : à changer
    end Additionner;

    function Norme2 (V : in T_Vecteur_Creux) return Float is
    begin
        return 0.0;     -- TODO : à changer
    end Norme2;

    function Produit_Scalaire (V1, V2 : in T_Vecteur_Creux) return Float is
    begin
        return 0.0;     -- TODO : à changer
    end Produit_Scalaire;

    procedure Afficher (V : T_Vecteur_Creux) is
    begin
        if V = null then
            Put ("--E");
        else
            -- Afficher la composante V.all
            Put ("-->[ ");
            Put (V.all.Indice, 0);
            Put (" | ");
            Put (V.all.Valeur, Fore => 0, Aft => 1, Exp => 0);
            Put (" ]");

            -- Afficher les autres composantes
            Afficher (V.all.Suivant);
        end if;
    end Afficher;

    function Nombre_Composantes_Non_Nulles
       (V : in T_Vecteur_Creux) return Integer
    is
    begin
        if V = null then
            return 0;
        else
            return 1 + Nombre_Composantes_Non_Nulles (V.all.Suivant);
        end if;
    end Nombre_Composantes_Non_Nulles;

end Vecteurs_Creux;
