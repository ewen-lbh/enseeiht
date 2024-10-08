with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TH;

procedure TH_Sujet is
function Hash(S: Unbounded_String) return Integer is begin
   return Length(S);
   end Hash;
package ThStrInt is new TH(Unbounded_String, Integer, 50, Hash);
use ThStrInt;
dict : ThStrInt.T_TH;

procedure Afficher_Cellule (Cle: Unbounded_String; Donnee: Integer) is
begin
        Put (To_String (Cle));
        Put (":");
        Put (Integer'Image (Donnee));
        Put_Line (",");
    end Afficher_Cellule;

    procedure Afficher is new Pour_Chaque (Afficher_Cellule);
    begin
    Initialiser (dict);
    Enregistrer (dict, To_Unbounded_String ("un"), 1);
    Enregistrer (dict, To_Unbounded_String ("deux"), 2);
    Afficher (dict);
    Vider (dict);

    end TH_Sujet;
