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
    begin
        if Sda = null then
            Sda :=
               new T_Cellule'(Cle => Cle, Donnee => Donnee, Suivante => null);
        elsif Sda.Cle = Cle then
            Sda :=
               new T_Cellule'
                  (Cle => Cle, Donnee => Donnee, Suivante => Sda.Suivante);
        else
            Enregistrer (Sda.Suivante, Cle, Donnee);
        end if;
        --  elsif Est_Vide (Sda.Suivante) then
        --      if Sda.Cle = Cle then
        --          Sda := new T_Cellule'(Cle => Cle, Donnee => Donnee, Suivante => Sda.Suivante);
        --      else
        --          Sda.Suivante :=
        --      end if;
        --      Sda.Suivante := new T_Cellule;
        --      Initialiser (Sda.Suivante);
        --      Sda.Suivante :=
        --         new T_Cellule'(Cle => Cle, Donnee => Donnee, Suivante => null);
        --  else
        --      Enregistrer (Sda.Suivante, Cle, Donnee);
        --  end if;
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
            return Sda.Donnee;
        else
            return La_Donnee (Sda.Suivante, Cle);
        end if;
    end La_Donnee;

    procedure Supprimer (Sda : in out T_LCA; Cle : in T_Cle) is
    begin
        if Sda = null then
            raise Cle_Absente_Exception;
        elsif Sda.Cle = Cle then
            Sda := Sda.Suivante;
        elsif Sda.Suivante = null then
            if Sda.Cle = Cle then
                Sda := null;
            else
                raise Cle_Absente_Exception;
            end if;
        elsif Sda.Suivante.Cle = Cle then
            Sda.Suivante := Sda.Suivante.Suivante;
        else
            Supprimer (Sda.Suivante, Cle);
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
