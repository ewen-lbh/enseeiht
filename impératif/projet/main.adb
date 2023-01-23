with Parsing;               use Parsing;
with RouteurSimple;         use RouteurSimple;
with Table;                 use Table.Table_LCA;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line;      use Ada.Command_Line;
with Exceptions;            use Exceptions;
with Ada.IO_Exceptions; 
with Ada.Exceptions;  use Ada.Exceptions;
procedure Main is
    T                 : T_LCA;
    args : arguments := (1 .. Argument_Count => To_Unbounded_String (""));
    taille_cache      : Integer;
    politique_cache   : Unbounded_String;
    afficher_stats    : Boolean;
    cacher_stats      : Boolean;
    fichier_table     : Unbounded_String;
    fichier_paquets   : Unbounded_String;
    fichier_resultats : Unbounded_String;
   i                 : Natural   := 1;
   arguments_invalides : Boolean   := False;
begin
    Initialiser (T);
    while i <= Argument_Count loop
        args (i) := To_Unbounded_String (Argument (i));
        i        := i + 1;
    end loop;

    Analyse_Ligne_de_commande
       (args, taille_cache, politique_cache, afficher_stats, cacher_stats,
        fichier_table, fichier_paquets, fichier_resultats, arguments_invalides);

    Analyse_fichier_table (T, fichier_table);
    Analyse_fichier_paquets (T, fichier_paquets, fichier_resultats);
    Vider (T);

exception
    when Table_Fichier_Incorrect_Exception =>
        Put ("Erreur lors du parsing de la table de routage.");
    when Ada.IO_Exceptions.NAME_ERROR =>
        Put ("Un des fichiers d'entrées n'existe pas.");
end Main;
