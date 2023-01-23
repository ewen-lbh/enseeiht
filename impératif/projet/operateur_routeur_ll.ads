with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Directories;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Table;                 use Table.Table_LCA;
with parsing; use parsing;
with routeursimple;

with lca_FIFO; use lca_FIFO; 
with lca_lru; use lca_lru;
with lca_lfu; use lca_lfu;

package operateur_routeur_ll is 

    procedure Analyse_fichier_paquets 
        (T                 : in T_LCA; politique_cache: in Unbounded_String; Fichier_paquets : Unbounded_String;
            Fichier_Resultats :    Unbounded_String; afficher_stats : in Boolean; taille_cache : in Integer);
    
    procedure print_usage;

    function meilleur_masque(T : in T_LCA; addr : in out Table.T_Adresse_IP; eth: in Unbounded_String) return Table.T_Adresse_IP;
  
     procedure Trouver_interface(politique_cache: in Unbounded_String;addr : in Table.T_Adresse_IP;interface_existe: in out Boolean; eth: in out Unbounded_String);


end operateur_routeur_ll;