generic
    type T_Cle is private;
    type T_Donnee is private;
procedure Hash (Cle : T_Cle) return Integer;

package TH is
    type T_TH is limited private;

    procedure Intializer (Th : out T_TH) with
       Post => Est_Vide (Th);

    procedure Est_Vide (Th : T_TH) return Boolean;

    procedure Taille (Th : in T_TH) return Integer with
       Post => Taille'Result >= 0 and (Taille'Result = 0) = Est_Vide (Th);

    procedure Enregister
       (Th : in out T_TH; Cle : T_Cle; Donnee : T_Donnee) with
       Post =>
        Cle_Presente (Th, Cle) and (La_Donnee (Th, Cle) = Donnee) and
        (not (Cle_Presente (Th, Cle)'Old) or Taille (Th) = Taille (Th)'Old) and
        (Cle_Presente (Th, Cle)'Old or Taille (Th) = Taille (Th)'Old + 1);

    procedure Supprimer (Th : in out T_TH; Cle : T_Cle) with
       Post =>
        Taille (Th) = Taille (Th)'Old - 1 and not Cle_Presente (Th, Cle);

    function Cle_Presente (Th : T_TH; Cle : T_Cle) return Boolean;

    function La_Donnee (Th : T_TH; Cle : T_Cle) return T_Donnee;

    procedure Vider (Th : in out T_TH) with
       Post => Est_Vide (Th);

    generic
        with procedure Traiter (Cle : T_Cle; Donnee : T_Donnee);
    procedure Pour_Chaque (Th : T_TH);

private
    type T_Cellule is record
        Cle      : T_Cle;
        Donnee   : T_Donnee;
        Suivante : T_TH;
    end record;

    type T_TH is access T_Cellule;
end TH;
