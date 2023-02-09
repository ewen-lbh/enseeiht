with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Directories;          use Ada.Directories;
with Table;                    use Table;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Parsing;                  use Parsing;
with RouteurSimple;            use RouteurSimple;
with Exceptions;               use Exceptions;

procedure parsing_test is

    CR : constant Character := (Character'Val (13));
    LF : constant Character := (Character'Val (10));
    NL : constant String    := "" & LF;

    procedure Assert_Equal (a, b : String) is
    begin
        Put_Line ("Attendu:" & a);
        Put_Line ("Actuel: " & b);
        pragma Assert (a = b);
    end Assert_Equal;

    procedure Assert_Equal_Integer (a, b : Integer) is
    begin
        Put_Line ("Attendu:" & Integer'Image (a));
        Put_Line ("Actuel: " & Integer'Image (b));
        pragma Assert (a = b);
    end Assert_Equal_Integer;

    procedure Setup_analyse_fichier_paquets
       (contenu_paquets          : in     Unbounded_String;
        contenu_table            : in     Unbounded_String;
        contenu_resultats        : in     Unbounded_String;
        contenu_resultats_obtenu :    out Unbounded_String)
    is
        chemin_paquets : constant String := "test_paquets.txt";
        chemin_table : constant String := "test_table.txt";
        chemin_resultats : constant String := "test_resultats.txt";
        fichier_paquets                           : File_Type;
        fichier_table                             : File_Type;
        fichier_resultats                         : File_Type;
        contenu_effectif_resultats                : Unbounded_String;
        T                                         : Table_LCA.T_LCA;
        ligne_courante_contenu_effectif_resultats : Unbounded_String;
    begin
        Create (fichier_paquets, Out_File, chemin_paquets);
        Put_Line (fichier_paquets, To_String (contenu_paquets));
        Close (fichier_paquets);

        Create (fichier_table, Out_File, chemin_table);
        Put_Line (fichier_table, To_String (contenu_table));
        Close (fichier_table);

        Analyse_fichier_table (T, To_Unbounded_String (chemin_table));
        Table.Afficher (T);
        Analyse_fichier_paquets
           (T, To_Unbounded_String (chemin_paquets),
            To_Unbounded_String (chemin_resultats));
        Table.Table_LCA.Vider (T);

        Open (fichier_resultats, In_File, chemin_resultats);
        while not End_Of_File (fichier_resultats) loop
            ligne_courante_contenu_effectif_resultats :=
               Unbounded_IO.Get_Line (fichier_resultats) & NL;
            contenu_effectif_resultats                :=
               contenu_effectif_resultats &
               ligne_courante_contenu_effectif_resultats;
        end loop;
        Close (fichier_resultats);
    end Setup_analyse_fichier_paquets;

    procedure Teardown_analyse_fichier_paquets is
        chemin_paquets   : constant String := "test_paquets.txt";
        chemin_table     : constant String := "test_table.txt";
        chemin_resultats : constant String := "test_resultats.txt";
        fichier_paquets                           : File_Type;
        fichier_table                             : File_Type;
        fichier_resultats                         : File_Type;
    begin

        Open (fichier_paquets, In_File, chemin_paquets);
        Delete_File (chemin_paquets);
        Close (fichier_paquets);

        Open (fichier_table, In_File, chemin_table);
        Delete_File (chemin_table);
        Close (fichier_table);

        Open (fichier_resultats, In_File, chemin_resultats);
        Delete_File (chemin_resultats);
        Close (fichier_resultats);
    end Teardown_analyse_fichier_paquets;

    procedure Setup_parse_command_line
       (ligne_de_commande : in Unbounded_String; taille_cache : in Natural;
        politique_cache   : in String; afficher_stats : in Boolean;
        cacher_stats      : in Boolean; fichier_table : in String;
        fichier_paquets   : in String; fichier_resultats : in String)
    is
        args : arguments := (1 .. 1_000 => To_Unbounded_String (""));
        actual_taille_cache      : Integer;
        actual_politique_cache   : Unbounded_String;
        actual_afficher_stats    : Boolean;
        actual_cacher_stats      : Boolean;
        actual_fichier_table     : Unbounded_String;
        actual_fichier_paquets   : Unbounded_String;
        actual_fichier_resultats : Unbounded_String;
        i                        : Integer   := 1;
        S                        : Character;
    begin
        for S of To_String (ligne_de_commande) loop
            if S = ' ' then
                i := i + 1;
            else
                args (i) := args (i) & S;
            end if;
        end loop;
        Analyse_Ligne_de_commande
           (args, actual_taille_cache, actual_politique_cache,
            actual_afficher_stats, actual_cacher_stats, actual_fichier_table,
            actual_fichier_paquets, actual_fichier_resultats);
        Assert_Equal
           (Natural'Image (taille_cache), Natural'Image (actual_taille_cache));
        Assert_Equal (politique_cache, To_String (actual_politique_cache));
        Assert_Equal
           (Boolean'Image (afficher_stats),
            Boolean'Image (actual_afficher_stats));
        Assert_Equal
           (Boolean'Image (cacher_stats), Boolean'Image (actual_cacher_stats));
        Assert_Equal (fichier_table, To_String (actual_fichier_table));
        Assert_Equal (fichier_paquets, To_String (actual_fichier_paquets));
        Assert_Equal (fichier_resultats, To_String (actual_fichier_resultats));
    end Setup_parse_command_line;

    procedure Test_Analyse_Fichier is
        use Table.Table_LCA;

        F     : File_Type;
        F_Nom : constant String := "test_parse_table.txt";
        T     : T_LCA;
    begin
        Initialiser (T);

        Create (F, Out_File, F_Nom);
        Put_Line (F, "147.127.16.0 255.255.240.0 eth0");
        Put_Line (F, "147.127.18.0 255.255.255.0 eth1");
        Close (F);

        Analyse_fichier_table (T, To_Unbounded_String (F_Nom));
        Open (F, In_File, F_Nom);
        Delete (F);
        Assert_Equal_Integer (2, Taille (T));
    end Test_Analyse_Fichier;

    procedure Test_Analyse_Fichier_Exception1 is
        use Table.Table_LCA;

        F     : File_Type;
        F_Nom : constant String := "test_parse_table.txt";
        T     : T_LCA;
    begin
        Initialiser (T);

        Create (F, Out_File, F_Nom);
        Put_Line (F, "147.127.16.0 255.255.240.0");
        Close (F);

        Analyse_fichier_table (T, To_Unbounded_String (F_Nom));
        Open (F, In_File, F_Nom);
        Delete (F);
    exception
        when Table_Fichier_Incorrect_Exception =>
            Open (F, In_File, F_Nom);
            Delete (F);
            Put_Line ("Exception OK");
        when others                            =>
            Open (F, In_File, F_Nom);
            Delete (F);
            pragma Assert (False);
    end Test_Analyse_Fichier_Exception1;

    procedure Test_Analyse_Fichier_Exception2 is
        use Table.Table_LCA;

        F     : File_Type;
        F_Nom : constant String := "test_parse_table.txt";
        T     : T_LCA;
    begin
        Initialiser (T);

        Create (F, Out_File, F_Nom);
        Put_Line (F, "147. 255.255.240.0 eth0");
        Close (F);

        Analyse_fichier_table (T, To_Unbounded_String (F_Nom));
        Open (F, In_File, F_Nom);
        Delete (F);
    exception
        when Table_Fichier_Incorrect_Exception =>
            Open (F, In_File, F_Nom);
            Delete (F);
            Put_Line ("Exception OK");
        when others                            =>
            Open (F, In_File, F_Nom);
            Delete (F);
            pragma Assert (False);
    end Test_Analyse_Fichier_Exception2;

    procedure Test_Analyse_Fichier_Exception3 is
        use Table.Table_LCA;

        F     : File_Type;
        F_Nom : constant String := "test_parse_table.txt";
        T     : T_LCA;
    begin
        Initialiser (T);

        Create (F, Out_File, F_Nom);
        Put_Line (F, "147.127.16.0");
        Close (F);

        Analyse_fichier_table (T, To_Unbounded_String (F_Nom));
        Open (F, In_File, F_Nom);
        Delete (F);
    exception
        when Table_Fichier_Incorrect_Exception =>
            Open (F, In_File, F_Nom);
            Delete (F);
            Put_Line ("Exception OK");
        when others                            =>
            Open (F, In_File, F_Nom);
            Delete (F);
            pragma Assert (False);
    end Test_Analyse_Fichier_Exception3;

begin
    -- Tester si la ligne de commande -S -p packets.txt est analysée correctement
    -- et donne les bonnes valeurs pour les options
    Setup_parse_command_line
       (ligne_de_commande => To_Unbounded_String ("-S -p packets.txt"),
        taille_cache => 10, politique_cache => "FIFO", afficher_stats => False,
        cacher_stats      => True, fichier_table => "table.txt",
        fichier_paquets   => "packets.txt",
        fichier_resultats => "resultats.txt");

    -- Tester si la ligne de commande -s -S -s -t lorem.txt -P LRU  est analysée correctement
    -- et donne les bonnes valeurs pour les options
    Setup_parse_command_line
       (ligne_de_commande =>
           To_Unbounded_String ("-s -S -s -t lorem.txt -P LRU"),
        taille_cache => 10, politique_cache => "LRU", afficher_stats => True,
        cacher_stats      => False, fichier_table => "lorem.txt",
        fichier_paquets   => "paquets.txt",
        fichier_resultats => "resultats.txt");

    -- Tester si la ligne de commande  -p p -t t -r r  est analysée correctement
    -- et donne les bonnes valeurs pour les options
    Setup_parse_command_line
       (ligne_de_commande => To_Unbounded_String ("-p p -t t -r r"),
        taille_cache => 10, politique_cache => "FIFO", afficher_stats => True,
        cacher_stats => False, fichier_table => "t", fichier_paquets => "p",
        fichier_resultats => "r");

    -- Tester si la ligne de commande -p commandes.txt est analysée correctement
    -- et donne les bonnes valeurs pour les options
    Setup_parse_command_line
       (ligne_de_commande => To_Unbounded_String ("-p commandes.txt"),
        taille_cache => 10, politique_cache => "FIFO", afficher_stats => True,
        cacher_stats      => False, fichier_table => "table.txt",
        fichier_paquets   => "commandes.txt",
        fichier_resultats => "resultats.txt");
    Put_Line ("Test_parse_command_line OK");
    New_Line;

    Test_Analyse_Fichier;
    Put_Line ("Test_Analyse_Fichier OK");
    Test_Analyse_Fichier_Exception1;
    Put_Line ("Test_Analyse_Fichier_Exception1 OK");
    Test_Analyse_Fichier_Exception2;
    Put_Line ("Test_Analyse_Fichier_Exception2 OK");
    Test_Analyse_Fichier_Exception3;
    Put_Line ("Test_Analyse_Fichier_Exception3 OK");

end parsing_test;
