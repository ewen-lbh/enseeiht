with Ada.Text_IO;    use Ada.Text_IO;
with SDA_Exceptions; use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

    procedure Free is new Ada.Unchecked_Deallocation
       (Object => T_Cellule, Name => T_LCA);

    procedure Initialiser (Sda : out T_LCA) is
    begin
        Sda := null;
    end Initialiser;

    function Est_Vide (Sda : T_LCA) return Boolean is
    begin
        return Sda = null;
    end Est_Vide;

    function Taille (Sda : in T_LCA) return Integer is
    begin
        if Sda = null then
            return 0;
        else
            return Taille (Sda.Suivante) + 1;
        end if;
    end Taille;

    procedure Enregistrer
       (Sda : in out T_LCA; Cle : in T_Cle; Donnee : in T_Donnee)
    is
        sda_old: T_LCA;
    begin
        sda_old := Sda;
        if Sda = null then
            Sda :=
               new T_Cellule'(Cle => Cle, Donnee => Donnee, Suivante => null);
            Free (sda_old);
        elsif Sda.all.Cle = Cle then
            Sda :=
               new T_Cellule'
                  (Cle => Cle, Donnee => Donnee, Suivante => Sda.all.Suivante);
            Free(sda_old);
        else
            Enregistrer (Sda.all.Suivante, Cle, Donnee);
        end if;
    end Enregistrer;

    function Cle_Presente (Sda : in T_LCA; Cle : in T_Cle) return Boolean is
    begin
        if Sda = null then
            return False;
        elsif Sda.Cle = Cle then
            return True;
        else
            return Cle_Presente (Sda.Suivante, Cle);
        end if;
    end Cle_Presente;

    function La_Donnee (Sda : in T_LCA; Cle : in T_Cle) return T_Donnee is
    begin
        if Sda = null then
            raise Cle_Absente_Exception;
        else
            null;
        end if;

        if Sda.Cle = Cle then
            return Sda.all.Donnee;
        else
            return La_Donnee (Sda.Suivante, Cle);
        end if;
    end La_Donnee;

    procedure Supprimer (Sda : in out T_LCA; Cle : in T_Cle) is
        old_sda: T_LCA;
        tmp: T_LCA;
    begin
        old_sda := Sda;
        if not Cle_Presente(Sda, Cle) then
            raise Cle_Absente_Exception;
        elsif Sda.all.Cle = Cle then
            Sda := Sda.all.Suivante;
            Free(old_sda);
        else 
            while old_sda.all.Suivante.all.Cle /= Cle loop
                old_sda := old_sda.all.Suivante;
            end loop;
            tmp := old_sda.all.Suivante.all.Suivante;
            Free(old_sda.all.Suivante);
            old_sda.all.Suivante := tmp;
            end if;
    end Supprimer;

    procedure Vider (Sda : in out T_LCA) is
    begin
        if Sda /= null then
            Vider (Sda.Suivante);
        else
            null;
        end if;
        Free (Sda);
    end Vider;

    procedure Pour_Chaque (Sda : in T_LCA) is
    begin
        if Sda = null then
            null;
        else
            Traiter (Sda.Cle, Sda.Donnee);
            Pour_Chaque (Sda.Suivante);
        end if;
    exception
        when others =>
            Pour_Chaque (Sda.Suivante);
    end Pour_Chaque;

end LCA;
