
package body operateur_routeur_ll is

    commande_fin : Boolean := false; -- variable qui permet de savoir si la commande "fin" a été entrée

    inst_fifo: T_FIFO; -- instance FIFO 
    inst_lru: T_LRU; -- instance LRU 
    inst_lfu: T_LFU; -- instance LFU
                     
    interface_existe      : Boolean:=false; -- variable qui permet de savoir si l'interface existe (pour la commande "verifier_cache")
    
    NL    : constant Character        := Character'Val (10);
    USAGE : constant Unbounded_String :=
       To_Unbounded_String
          ("Usage: ./routeur_ll [options]" & NL & "" & NL & "Options:" & NL &
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
           "  routeur_ll -c 15 -t table.txt -p paquets.txt -r resultats.txt -P LFU");
    
    procedure print_usage is

    begin
        Put_Line(USAGE);
    end print_usage;


    function meilleur_masque(T : in T_LCA; addr : in out Table.T_Adresse_IP; eth: in Unbounded_String) return Table.T_Adresse_IP is
        T2: T_LCA;
        Masque_a_choisir: Table.T_Adresse_IP;
        masque: Table.T_Adresse_IP;
    begin

        T2 := T;
        while not (T2 = Null) loop
            if eth = L_interface(T2) then
                masque := Le_Masque(T2);
            end if;
            T2 := Le_suivant(T2);
        end loop;

        T2 := T;
        Masque_a_choisir := 0;
        while not (T2 = Null) loop
            if Table."="(Table."and"(addr, masque), Table."and"(L_ip(T2), masque)) then
                if (Table.">" (Le_Masque(T2), Masque_a_choisir)) then
                    Masque_a_choisir := Le_Masque(T2);
                end if;
            end if;
            T2 := Le_suivant(T2);
        end loop;
        addr := Table."and"(addr, Masque_a_choisir);
        return Masque_a_choisir;
    end meilleur_masque;

    procedure Trouver_interface(politique_cache: in Unbounded_String;addr : in Table.T_Adresse_IP;interface_existe: in out Boolean; eth: in out Unbounded_String) is
    begin
        if politique_cache = "FIFO" then
             verifier_cache(inst_fifo,interface_existe, addr, eth);
        elsif politique_cache = "LRU" then
             verifier_cache(inst_lru,interface_existe, addr, eth);
        elsif politique_cache = "LFU" then
             verifier_cache(inst_lfu,interface_existe, addr, eth);
        end if;
    end Trouver_interface;

    procedure Analyse_fichier_paquets 
       (T                 : in T_LCA; politique_cache: in Unbounded_String; Fichier_paquets : Unbounded_String;
        Fichier_Resultats :    Unbounded_String; afficher_stats: in Boolean; taille_cache: in Integer)
    is
        paquets_descripteur   : File_Type; -- descripteur du fichier de paquets
        resultats_descripteur : File_Type; -- descripteur du fichier de résultats
        Ligne_courante        : Unbounded_String;
        addr                  : Table.T_Adresse_IP; -- adresse IP Temporaire
        masque                : Table.T_Adresse_IP; -- masque temporaire
        eth                   : Unbounded_String;   -- interface 
        numero_ligne          : Integer := 1;
        route_IP             : Table.T_Adresse_IP; -- adresse IP de la route à intégrer au cache 

    begin
        if not Ada.Directories.Exists(To_String(fichier_resultats)) then
                Create
                (resultats_descripteur, Name => To_String (fichier_Resultats));
                Close (resultats_descripteur) ;
            end if;

        if politique_cache = "FIFO" then
            Initialiser( inst_fifo, taille_cache);
        elsif politique_cache = "LRU" then
            Initialiser( inst_lru, taille_cache);
        elsif politique_cache = "LFU" then
            Initialiser( inst_lfu, taille_cache);
        end if;

        Open (paquets_descripteur, In_File, To_String (Fichier_paquets));
        if not Ada.Directories.Exists (To_String(fichier_Resultats)) then
            Create
               (resultats_descripteur, Name => To_String (Fichier_Resultats));
            Close (resultats_descripteur);
        end if;
        Open (resultats_descripteur, Out_File, To_String (Fichier_Resultats));
        while not End_Of_File (paquets_descripteur) and not commande_fin loop
           
            Ligne_courante := Unbounded_IO.Get_Line (paquets_descripteur);
            --  Ada.Strings.Unbounded.Trim (Current_Line);

            if Ligne_courante = "table" then
                Ada.Text_IO.Put_Line
                   ("table (ligne " & Integer'Image (numero_ligne) & ")");
                routeursimple.Commande_Table (T);

            elsif Ligne_courante = "fin" then 
                commande_fin := true;
                Put_Line("fin" & " (ligne " & Integer'Image (numero_ligne) & ")");

            elsif Ligne_courante = "stats" then
                Ada.Text_IO.Put_Line
                   ("stats (ligne " & Integer'Image (numero_ligne) & ")");
                if politique_cache = "FIFO" then
                    Afficher_Stat(inst_fifo);
                elsif politique_cache = "LRU" then
                    Afficher_Stat(inst_lru);
                elsif politique_cache = "LFU" then
                    Afficher_Stat(inst_lfu);
                end if;

            elsif Ligne_courante = "cache" then 
                Ada.Text_IO.Put_Line
                   ("cache (ligne " & Integer'Image (numero_ligne) & ")");
                if politique_cache = "FIFO" then
                    lca_FIFO.Afficher(inst_fifo);
                elsif politique_cache = "LRU" then
                    lca_lru.Afficher(inst_lru);
                elsif politique_cache = "LFU" then
                    lca_lfu.Afficher(inst_lfu);
                end if;

            else -- Ligne_courante est une adresse IP
                addr := Table.String_IP_Vers_T_Adresse_IP (Ligne_courante);
                Trouver_interface (politique_cache, addr, interface_existe, eth);

                if not interface_existe then
                    eth := routeursimple.Trouver_interface (T, addr);
                    Put_Line
                       (resultats_descripteur,Table.T_Adresse_IP_Vers_String_IP (addr) & " " &
                        To_String (eth));
                    masque := meilleur_masque(T, addr, eth);
                    route_IP := Table."and" (addr, masque);
                    if politique_cache = "FIFO" then
                        Ajouter_Dans_Cache(inst_fifo, route_IP, masque,  eth);
                    elsif politique_cache = "LRU" then
                        Ajouter_Dans_Cache(inst_lru, route_IP, masque,  eth);
                    elsif politique_cache = "LFU" then
                        Ajouter_Dans_Cache(inst_lfu, route_IP, masque,  eth);
                    end if;
                else

                    Put_Line
                        (resultats_descripteur,Table.T_Adresse_IP_Vers_String_IP (addr) & " " &
                            To_String (eth));
                    
                end if;

                --Put_Line (To_String(Table.T_Adresse_IP_Vers_String_IP (addr)) & " " & To_String (eth));

            end if;
            numero_ligne := numero_ligne + 1; -- On incrémente le numéro de ligne pour l'affichage
        end loop;

        if afficher_stats then 
            if politique_cache = "FIFO" then
                Afficher_Stat(inst_fifo);
            elsif politique_cache = "LRU" then
                Afficher_Stat(inst_lru);
            elsif politique_cache = "LFU" then
                Afficher_Stat(inst_lfu);
            end if;
        end if;

        Close (resultats_descripteur);
        Close (paquets_descripteur);

        if politique_cache = "FIFO" then
            Vider( inst_fifo);
        elsif politique_cache = "LRU" then
            Vider( inst_lru);
        elsif politique_cache = "LFU" then
            Vider( inst_lfu);
        end if;

    end Analyse_fichier_paquets;

end operateur_routeur_ll;
