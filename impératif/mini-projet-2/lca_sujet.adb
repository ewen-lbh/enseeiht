with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;

procedure LCA_Sujet is
    package LcaStrInt is new LCA (Unbounded_String, Integer);
    use LcaStrInt;
    dict : LcaStrInt.T_LCA;
begin
    Initialiser (dict);
    Enregistrer (dict, To_Unbounded_String("un"), 1);
    Enregistrer (dict, To_Unbounded_String("deux"), 2);
end LCA_Sujet;
