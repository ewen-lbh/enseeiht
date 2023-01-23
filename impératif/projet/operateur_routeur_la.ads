with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with Ada.Directories;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Table;                    use Table.Table_LCA;
with Parsing;                  use Parsing;
with RouteurSimple;

with cache_abr; use cache_abr;

package operateur_routeur_la is
    procedure Analyse_fichier_paquets
       (T : in T_LCA; politique_cache : in T_Politique; Fichier_paquets : Unbounded_String;
        Fichier_Resultats : Unbounded_String; afficher_stats : in Boolean; capacite : in Integer);

    procedure print_usage;

    function meilleur_masque
       (T : in T_LCA; addr : in out Table.T_Adresse_IP; eth : in Unbounded_String)
        return Table.T_Adresse_IP;

end operateur_routeur_la;
