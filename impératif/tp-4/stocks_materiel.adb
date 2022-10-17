with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- Auteur: Ewen Le Bihan
-- Gérer un stock de matériel informatique.
--

package body Stocks_Materiel is

    procedure Creer (Stock : out T_Stock) is
    begin
        Stock :=
           (Valeurs =>
               (others =>
                   (Numero_Serie => -1, Nature => UNITE_CENTRALE,
                    Annee_Achat  => -1, Fonctionne => False)),
            Taille => 0);
    end Creer;

    function Nb_Materiels (Stock : in T_Stock) return Integer is
    begin
        return Stock.Taille;
    end Nb_Materiels;

    function Nb_Materiels_HS (Stock: in T_Stock) return Integer is
        compte : Integer := 0;
    begin 
        for materiel in Stock.Valeurs(1..Stock.Taille) loop
            if not materiel.Fonctionne then
                compte := compte + 1;
            end if;
        end loop;
        return compte;
    end;

    procedure Mettre_A_Jour (Stock: in out T_Stock; Numero_Serie: in Integer; Nature: in T_Nature; Annee_Achat: in Integer; Fonctionne: in Boolean) is
        index_materiel: Integer := 0;
    begin
        for materiel in Stock.Valeurs(1..Stock.Taille) loop
        index_materiel := index_materiel + 1;
            if materiel.Numero_Serie = Numero_Serie then
                Stock.Valeurs(index_materiel).Annee_Achat := Annee_Achat;
                Stock.Valeurs(index_materiel).Nature := Nature;
                Stock.Valeurs(index_materiel).Fonctionne := Fonctionne;
            end if;
        end loop;
    end;

    function Indice_De(Stock: in T_Stock; Numero_Serie: in Integer) return Integer is 
    index: Integer := 0; 
    begin
        for materiel in Stock.Valeurs(1..Stock.Taille) loop
        index_materiel := index_materiel + 1;
        if materiel.Numero_Serie = Numero_Serie then
            return index
        end if;
        end loop;
        return -1;
    end;


    procedure Enregistrer
       (Stock  : in out T_Stock; Numero_Serie : in Integer;
        Nature : in     T_Nature; Annee_Achat : in Integer)
    is
    begin
        Stock.Valeurs (Stock.Taille+1) :=
           (Numero_Serie => Numero_Serie, Nature => Nature,
            Annee_Achat  => Annee_Achat, Fonctionne => True);
        Stock.Taille := Stock.Taille + 1;
    end Enregistrer;

    procedure Supprimer
    (Stock: in out T_Stock; Numero_Serie: in Integer) is 
    index: Integer := 0;
    begin
        Stock.Delete(Indice_De(Stock, Numero_Serie))
    end Supprimer;

end Stocks_Materiel;
