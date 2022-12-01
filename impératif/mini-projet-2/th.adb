with Ada.Text_IO;    use Ada.Text_IO;
with SDA_Exceptions; use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body TH is

    procedure Initialiser (Th : out T_TH) is

    begin
        for i in Th'Range loop
            TH_LCA.Initialiser (Sda => Th (i));
        end loop;
    end Initialiser;

    function Est_Vide (Th : T_TH) return Boolean is
        vide : Boolean := True;
    begin
        for i in Th'Range loop
            if not TH_LCA.Est_Vide (Th (i)) then
                vide := False;
            end if;
        end loop;
        return vide;
    end Est_Vide;

    function Taille (Th : in T_TH) return Integer is
        total : Integer := 0;
    begin
        for i in Th'Range loop
            total := total + TH_LCA.Taille (Th (i));
        end loop;
        return total;
    end Taille;

    procedure Enregistrer
       (Th : in out T_TH; Cle : in T_Cle; Donnee : in T_Donnee)
    is
        liste : TH_LCA.T_LCA;
        index : Integer;
    begin
        index := Hash (Cle);
        if TH_LCA.Est_Vide (Th (index)) then
            TH_LCA.Initialiser (Th (index));
        else
            null;
        end if;
        TH_LCA.Enregistrer (Sda => Th (index), Cle => Cle, Donnee => Donnee);
    end Enregistrer;

    function Cle_Presente (Th : in T_TH; Cle : in T_Cle) return Boolean is
        index : Integer;
    begin
        index := Hash (Cle);
        if TH_LCA.Est_Vide (Th (index)) then
            return False;
        else
            return TH_LCA.Cle_Presente (Sda => Th (index), Cle => Cle);
        end if;
    end Cle_Presente;

    function La_Donnee (Th : in T_TH; Cle : in T_Cle) return T_Donnee is
        index : Integer;
    begin
        index := Hash (Cle);
        if TH_LCA.Est_Vide (Th (index)) then
            raise Cle_Absente_Exception;
        else
            return TH_LCA.La_Donnee (Sda => Th (index), Cle => Cle);
        end if;
    end La_Donnee;

    procedure Supprimer (Th : in out T_TH; Cle : in T_Cle) is
        index : Integer;
    begin
        index := Hash (Cle);
        if TH_LCA.Est_Vide (Th (index)) then
            raise Cle_Absente_Exception;
        else
            TH_LCA.Supprimer (Sda => Th (index), Cle => Cle);
        end if;
    end Supprimer;

    procedure Vider (Th : in out T_TH) is
    begin
        for i in Th'Range loop
            TH_LCA.Vider (Sda => Th (i));
        end loop;
    end Vider;

    procedure Pour_Chaque (Th : in T_TH) is
        procedure LCA_Pour_Chaque is new TH_LCA.Pour_Chaque (Traiter);
    begin

        for i in Th'Range loop
            if not TH_LCA.Est_Vide (Th (i)) then
                LCA_Pour_Chaque (Sda => Th (i));
            end if;
        end loop;
    end Pour_Chaque;

end TH;
