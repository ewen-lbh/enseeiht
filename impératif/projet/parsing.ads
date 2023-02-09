with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Table;                 use Table.Table_LCA;

package Parsing is

  procedure Analyse_fichier_table (T : in out T_LCA; File : in Unbounded_String) with
   Pre => Est_Vide (T) and Length (File) > 0;

  type arguments is array (Natural range <>) of Unbounded_String;

  -- Parse la ligne de commande
  procedure Analyse_Ligne_de_commande
   (args : in     arguments; taille_cache : out Natural; politique_cache : out Unbounded_String;
    afficher_stats  : out Boolean; cacher_stats : out Boolean; fichier_table : out Unbounded_String;
    fichier_paquets :    out Unbounded_String; fichier_resultats : out Unbounded_String;
    erronee         :    out Boolean);

private

  procedure Analyse_ligne
   (Line : in Unbounded_String; Adress : in out Unbounded_String; Mask : in out Unbounded_String;
    Eth  : in out Unbounded_String);

end Parsing;
