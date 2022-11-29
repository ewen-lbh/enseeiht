with LCA;

-- D�finition de structures de donn�es associatives sous forme d'une liste
-- cha�n�e associative (LCA).
generic
    type T_Cle is private;
    type T_Donnee is private;
    Borne : Integer;
    with function Hash (Cle : T_Cle) return Integer;

package TH is

    package TH_LCA is new LCA (T_Cle => T_Cle, T_Donnee => T_Donnee);

    type T_TH is limited private;

    -- Initialiser une Th.  La Th est vide.
    procedure Initialiser (Th : out T_TH) with
       Post => Est_Vide (Th);

    -- Est-ce qu'une Th est vide ?
    function Est_Vide (Th : T_TH) return Boolean;

    -- Obtenir le nombre d'�l�ments d'une Th.
    function Taille (Th : in T_TH) return Integer with
       Post => Taille'Result >= 0 and (Taille'Result = 0) = Est_Vide (Th);

    -- Enregistrer une Donn�e associ�e � une Cl� dans une Th.
    -- Si la cl� est d�j� pr�sente dans la Th, sa donn�e est chang�e.
    procedure Enregistrer
       (Th : in out T_TH; Cle : in T_Cle; Donnee : in T_Donnee) with
       Post =>
        Cle_Presente
           (Th, Cle) and
        (La_Donnee (Th, Cle) =
         Donnee)   -- donn�e ins�r�e
       and
        (not (Cle_Presente (Th, Cle)'Old) or Taille (Th) = Taille (Th)'Old) and
        (Cle_Presente (Th, Cle)'Old or Taille (Th) = Taille (Th)'Old + 1);

    -- Supprimer la Donn�e associ�e � une Cl� dans une Th.
    -- Exception : Cle_Absente_Exception si Cl� n'est pas utilis�e dans la Th
    procedure Supprimer (Th : in out T_TH; Cle : in T_Cle) with
       Post =>
        Taille
           (Th) = Taille (Th)'Old -
           1 -- un �l�ment de moins
       and not Cle_Presente (Th, Cle);         -- la cl� a �t� supprim�e

    -- Savoir si une Cl� est pr�sente dans une Th.
    function Cle_Presente (Th : in T_TH; Cle : in T_Cle) return Boolean;

    -- Obtenir la donn�e associ�e � une Cle dans la Th.
    -- Exception : Cle_Absente_Exception si Cl� n'est pas utilis�e dans l'Th
    function La_Donnee (Th : in T_TH; Cle : in T_Cle) return T_Donnee;

    -- Supprimer tous les �l�ments d'une Th.
    procedure Vider (Th : in out T_TH) with
       Post => Est_Vide (Th);

    -- Appliquer un traitement (Traiter) pour chaque couple d'une Th.
    generic
        with procedure Traiter (Cle : in T_Cle; Donnee : in T_Donnee);
    procedure Pour_Chaque (Th : in T_TH);

private
    type T_TH is array (1 .. Borne) of TH_LCA.T_LCA;
end TH;
