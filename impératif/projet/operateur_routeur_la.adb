package body operateur_routeur_la is

    commande_fin     : Boolean := False;
    interface_existe : Boolean := False;
    inst_cache       : T_Cache_ABR; -- instance de cache
    politique_cache  : T_Politique; -- politique de cache

    NL    : constant Character        := Character'Val (10);
    USAGE : constant Unbounded_String :=
       To_Unbounded_String
          ("Usage: ./routeur_la [options]" & NL & "" & NL & "Options:" & NL &
           "  -h                   Affiche cette aide." & NL &
           "  -P <LRU|LFU|FIFO>    Politique de cache utilisée." & NL &
           "  -p <fichier>         Fichier d'entrée contenant les paquets à router et les commandes à exécuter." &
           NL &
           "  -r <fichier>         Fichier résultats contannt les paquets routés avec leurs interfaces correspondantes" &
           NL &
           "  -t <fichier>         Fichier contenant la table de routage (une règle par ligne, chaque ligne ayant la forme <ip> <masque> <interface>)" &
           NL & "  -c <entier>          Capacité du cache" & NL &
           "  -s                   Cacher les statistiques" & NL &
           "  -S                   Afficher les statistiques" & NL & "" & NL &
           "Commandes dans le fichier des paquets:" & NL &
           "  table                Affiche les règles de routage chargées" & NL &
           "  cache                Affiche les règles contenues dans le cache" & NL &
           "  stats                Affiche les statistiques du cache" & NL &
           "  <ip>                 Route <ip> vers son interface" & NL & "" & NL & "Exemple:" & NL &
           "  routeur_la -c 15 -t table.txt -p paquets.txt -r resultats.txt -P LFU");
    procedure print_usage is

    begin
        Put_Line (USAGE);
    end print_usage;

    function meilleur_masque
       (T : in T_LCA; addr : in out Table.T_Adresse_IP; eth : in Unbounded_String)
        return Table.T_Adresse_IP
    is
        T2               : T_LCA;
        Masque_a_choisir : Table.T_Adresse_IP;
        masque           : Table.T_Adresse_IP;
    begin

        T2 := T;
        while not (T2 = null) loop
            if eth = L_interface (T2) then
                masque := Le_Masque (T2);
            end if;
            T2 := Le_suivant (T2);
        end loop;

        T2               := T;
        Masque_a_choisir := 0;
        while not (T2 = null) loop
            if Table."=" (Table."and" (addr, masque), Table."and" (L_ip (T2), masque)) then
                if (Table.">" (Le_Masque (T2), Masque_a_choisir)) then
                    Masque_a_choisir := Le_Masque (T2);
                end if;
            end if;
            T2 := Le_suivant (T2);
        end loop;
        addr := Table."and" (addr, Masque_a_choisir);
        return Masque_a_choisir;
    end meilleur_masque;

    procedure Analyse_fichier_paquets
       (T : in T_LCA; politique_cache : in T_Politique; Fichier_paquets : Unbounded_String;
        Fichier_Resultats :    Unbounded_String; afficher_stats : in Boolean; capacite : in Integer)
    is
        paquets_descripteur   : File_Type; -- descripteur du fichier de paquets
        resultats_descripteur : File_Type; -- descripteur du fichier de résultats
        Ligne_courante        : Unbounded_String;
        addr                  : Table.T_Adresse_IP; -- adresse IP Temporaire
        masque                : Table.T_Adresse_IP; -- masque temporaire
        eth                   : Unbounded_String;   -- interface
        numero_ligne          : Integer := 1;
        route_IP              : Table.T_Adresse_IP; -- adresse IP de la route à intégrer au cache
        route_masque : Table.T_Adresse_IP; -- masque de la route à déduire puis intégrer au cache
        route_eth             : Unbounded_String;   -- interface de la route à intégrer au cache

    begin
        if not Ada.Directories.Exists (To_String (Fichier_Resultats)) then
            Create (resultats_descripteur, Name => To_String (Fichier_Resultats));
            Close (resultats_descripteur);
        end if;

        Initialiser
           (inst_cache, politique_cache, capacite); -- 10 est la capacité du cache par défaut.

        Open (paquets_descripteur, In_File, To_String (Fichier_paquets));
        if not Ada.Directories.Exists (To_String (Fichier_Resultats)) then
            Create (resultats_descripteur, Name => To_String (Fichier_Resultats));
            Close (resultats_descripteur);
        end if;
        Open (resultats_descripteur, Out_File, To_String (Fichier_Resultats));
        while not End_Of_File (paquets_descripteur) and not commande_fin loop

            Ligne_courante := Unbounded_IO.Get_Line (paquets_descripteur);
            --  Ada.Strings.Unbounded.Trim (Current_Line);

            if Ligne_courante = "table" then
                Put_Line ("table (ligne " & Integer'Image (numero_ligne) & ")");
                RouteurSimple.Commande_Table (T);

            elsif Ligne_courante = "fin" then
                commande_fin := True;
                Put_Line ("fin" & " (ligne " & Integer'Image (numero_ligne) & ")");

            elsif Ligne_courante = "stats" then
                Put_Line ("stats (ligne " & Integer'Image (numero_ligne) & ")");
                Afficher_Stat (inst_cache);

            elsif Ligne_courante = "cache" then
                Put_Line ("cache (ligne " & Integer'Image (numero_ligne) & ")");
                Afficher (inst_cache);

            else -- Ligne_courante est une adresse IP
                addr := Table.String_IP_Vers_T_Adresse_IP (Ligne_courante);
                Verifier_cache (inst_cache, interface_existe, addr, eth);

                if not interface_existe then
                    eth := RouteurSimple.Trouver_interface (T, addr);
                    Put_Line
                       (resultats_descripteur,
                        Table.T_Adresse_IP_Vers_String_IP (addr) & " " & To_String (eth));
                    masque   := meilleur_masque (T, addr, eth);
                    route_IP := Table."and" (addr, masque);

                    Ajouter_Dans_Cache (inst_cache, route_IP, masque, eth);

                else
                    Put_Line
                       (resultats_descripteur,
                        Table.T_Adresse_IP_Vers_String_IP (addr) & " " & To_String (eth));

                end if;

            end if;
            numero_ligne := numero_ligne + 1; -- On incrémente le numéro de ligne pour l'affichage
        end loop;

        if afficher_stats then
            Afficher_Stat (inst_cache);
        end if;

        Close (resultats_descripteur);
        Close (paquets_descripteur);

        Vider (inst_cache);

    end Analyse_fichier_paquets;

end operateur_routeur_la;
