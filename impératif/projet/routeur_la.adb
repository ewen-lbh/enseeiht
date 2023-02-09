with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Text_IO;           use Ada.Text_IO;
with Table;                 use Table.Table_LCA;
with Parsing;               use Parsing;
with operateur_routeur_la;  use operateur_routeur_la;
with cache_abr;             use cache_abr;
with Exceptions;            use Exceptions;
with Ada.IO_Exceptions;
with Ada.Exceptions;        use Ada.Exceptions;

procedure routeur_la is
    i                   : Natural                   := 1;
    args                : arguments := (1 .. Argument_Count => To_Unbounded_String (""));
    taille_cache        : Integer                   := 10;
    politique_cache     : cache_abr.T_Politique;
    fichier_table       : Unbounded_String;
    fichier_paquets     : Unbounded_String;
    fichier_resultats   : Unbounded_String;
    cacher_stats        : Boolean;
    afficher_stats      : Boolean;
    T                   : T_LCA;
    pol_cache           : Unbounded_String;
    arguments_invalides : Boolean                   := False;

begin
    while i <= Argument_Count loop
        args (i) := To_Unbounded_String (Argument (i));
        i        := i + 1;
    end loop; -- On obtient une liste d'arguments.

    Analyse_Ligne_de_commande
       (args, taille_cache, pol_cache, afficher_stats, cacher_stats, fichier_table, fichier_paquets,
        fichier_resultats, arguments_invalides); -- Provient de Parsing.

    if pol_cache = To_Unbounded_String ("LRU") then
        politique_cache := LRU;
    elsif pol_cache = To_Unbounded_String ("LFU") then
        politique_cache := LFU;
    elsif pol_cache = To_Unbounded_String ("FIFO") then
        politique_cache := FIFO;
    else
        Put_Line
           ("Politique de cache """ & To_String (pol_cache) &
            """ invalide: politiques disponibles: ""LRU"", ""LFU"", ""FIFO""");
        arguments_invalides := True;
    end if;

    if Argument_Count = 0 or arguments_invalides then
        print_usage;
    else
        Initialiser (T);
        Analyse_fichier_table (T, fichier_table); -- Provient aussi de Parsing.
        Analyse_fichier_paquets
           (T, politique_cache, fichier_paquets, fichier_resultats, afficher_stats, taille_cache);
        Vider (T);

    end if;

exception
    when Table_Fichier_Incorrect_Exception =>
        Put ("Erreur lors du parsing de la table de routage.");
    when Ada.IO_Exceptions.Name_Error      =>
        Put ("Un des fichiers d'entrées n'existe pas.");

end routeur_la;
