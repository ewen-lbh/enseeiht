with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;

procedure LCA_Sujet is
    package LcaStrInt is new LCA (Unbounded_String, Integer);
    use LcaStrInt;
    dict : LcaStrInt.T_LCA;

    procedure Afficher_Cellule (Cle : Unbounded_String; Donnee : Integer) is
    begin
        Put (To_String (Cle));
        Put (":");
        Put (Integer'Image(Donnee));
        Put_Line (",");
    end Afficher_Cellule;

    procedure Afficher is new Pour_Chaque (Afficher_Cellule);
begin
    Initialiser (dict);
    Enregistrer (dict, To_Unbounded_String ("un"), 1);
    Enregistrer (dict, To_Unbounded_String ("deux"), 2);
    Afficher(dict);
end LCA_Sujet;
